defmodule TimemasterWeb.ClockController do
  use TimemasterWeb, :controller

  alias Timemaster.Time
  alias Timemaster.Time.Clock
  alias Timemaster.Repo
  import Ecto.Query
  alias TimemasterWeb.WorkingTimeController

  action_fallback TimemasterWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"userID" => userID, "clock" => clock_params}) do
    start_date = nil
    end_date = nil
    case Repo.get_by(Timemaster.Accounts.User, id: userID) do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Error while creating user clocks"})

      user ->
        case Repo.get_by(Clock, user_id: userID) do
          nil ->
            clock_params = Map.put(clock_params, "user_id", user.id)
            with {:ok, %Clock{} = clock} <- Time.create_clock(clock_params) do
              conn
              |> put_status(:ok)
              |> json(%{message: "Clock for new day has been created"})
            end
          clock ->
            start_date = clock.time
            with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
              clock = Repo.preload(clock, :user)
              end_date = Map.get(clock_params, "time") # Utilisation de la valeur dans clock_params
              case Map.get(clock_params, "status") do
                false ->
                  clock_params = Map.put(clock_params, "start", start_date)
                  clock_params = Map.put(clock_params, "end", end_date)
                  conn
                  |> put_status(:ok)
                  |> json(%{message: "Clock check of the day done"})
                  WorkingTimeController.create(conn, %{"userID" => userID, "workingtime" => clock_params})
                _ ->
                  with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
                    conn
                    |> put_status(:ok)
                    |> json(%{message: "Clock for new day has been created"})
                  end
              end
            end
        end
    end
  end


  def user_clocks(conn, %{"userID" => userID}) do
    case Repo.get_by(Timemaster.Accounts.User, id: userID) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        clocks = Repo.all(from(c in Clock, where: c.user_id == ^user.id))
        clocks = Repo.preload(clocks, :user)
        render(conn, :index, clocks: clocks)
    end
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{}} <- Time.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
