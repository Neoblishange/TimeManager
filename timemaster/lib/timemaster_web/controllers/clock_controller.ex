defmodule TimemasterWeb.ClockController do
  use TimemasterWeb, :controller

  alias Timemaster.Time
  alias Timemaster.Time.Clock
  alias Timemaster.Repo

  action_fallback TimemasterWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"userID" => userID, "clock" => clock_params}) do
    user = Repo.get_by(Timemaster.Accounts.User, id: userID)
    clock_params = Map.put(clock_params, "user_id", user.id)
    with {:ok, %Clock{} = clock} <- Time.create_clock(clock_params) do
      clock = Repo.preload(clock, :user)
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
      |> render(:show, clock: clock)
    end
  end


  def show(conn, %{"userID" => userID}) do
    case Repo.get_by(Timemaster.Accounts.User, id: userID) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(TimemasterWeb.ErrorView)
        |> render(:"404")
      user ->
        clock = Repo.get_by(Clock, user_id: user.id)
        clock = Repo.preload(clock, :user)
        render(conn, :show, clock: clock)
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
