defmodule TimemasterWeb.WorkingTimeController do
  use TimemasterWeb, :controller

  alias Timemaster.Work
  alias Timemaster.Work.Workingtime
  alias Timemaster.Repo
  import Ecto.Query

  action_fallback TimemasterWeb.FallbackController

  def get_workingtimes_by_params(conn, params) do
    case Map.fetch(params, "start") do
      {:ok, startTime} ->
        case Map.fetch(params, "end") do
          {:ok, endTime} ->
            case Map.fetch(params, "userID") do
              {:ok, userID} ->
                user = Repo.get_by(Timemaster.Accounts.User, id: userID)
                case Repo.get_by(Timemaster.Accounts.User, id: userID) do
                  nil ->
                    conn
                    |> put_status(:not_found)
                    |> json(%{message: "User not found"})
                  user ->
                    case DateTime.from_iso8601(startTime) && DateTime.from_iso8601(endTime) do
                      {:error, :invalid_format} ->
                        conn
                        |> put_status(:not_found)
                        |> json(%{message: "Error datetime of format YYYY-mm-dd HH:ii:ss required"})
                      _ ->
                        workingtimes = Repo.all(from(w in Workingtime,
                          where: w.start >= ^startTime and w.end <= ^endTime and w.user_id == ^user.id))
                        workingtimes = Repo.preload(workingtimes, :user)
                        render(conn, :get_workingtimes_by_params, workingtimes: workingtimes)
                    end
                end
              :error ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{message: "User ID is missing"})
            end
          :error ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{message: "Parameter 'end' is missing"})
        end
      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Parameter 'start' is missing"})
    end
  end

  def index(conn, _params) do
    workingtimes = Work.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"userID" => userID, "workingtime" => workingtime_params}) do
    case Repo.get_by(Timemaster.Accounts.User, id: userID) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        workingtime_params = Map.put(workingtime_params, "user_id", user.id)
        with {:ok, %Workingtime{} = workingtime} <- Work.create_workingtime(workingtime_params) do
          workingtime = Repo.preload(workingtime, :user)
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
          |> render(:show, workingtime: workingtime)
        end
    end

  end

  def show(conn, %{"userID" => userID, "id" => id}) do
    case Repo.get_by(Timemaster.Accounts.User, id: userID) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        workingtime = Repo.get_by(Workingtime, user_id: user.id, id: id)
        workingtime = Repo.preload(workingtime, :user)
        render(conn, :show, workingtime: workingtime)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    case Repo.get(Workingtime, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User workingtime not found"})
      workingtime ->
        workingtime = Repo.preload(workingtime, :user)
        with {:ok, %Workingtime{} = workingtime} <- Work.update_workingtime(workingtime, workingtime_params) do
          render(conn, :show, workingtime: workingtime)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.get(Workingtime, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User workingtime not found"})
      workingtime ->
        with {:ok, %Workingtime{}} <- Work.delete_workingtime(workingtime) do
          conn
          |> json(%{message: "WorkingTime deleted"})
        end
    end
  end
end
