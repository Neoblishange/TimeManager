defmodule TimemasterWeb.WorkingTimeController do
  use TimemasterWeb, :controller

  alias Timemaster.Work
  alias Timemaster.Work.Workingtime
  alias Timemaster.Repo
  import Ecto.Query

  action_fallback TimemasterWeb.FallbackController

  def get_workingtimes_by_params(conn, %{"userID" => userID, "start" => startTime, "end" => endTime}) do
    user = Repo.get_by(Timemaster.Accounts.User, id: userID)

    # Convertir startTime et endTime en valeurs :utc_datetime
    start_datetime = DateTime.from_naive(startTime, "Etc/UTC")
    end_datetime = DateTime.from_naive(endTime, "Etc/UTC")

    query = from(w in Workingtime,
      where: w.start >= ^start_datetime and w.end <= ^end_datetime and w.user == ^user)

    workingtimes = Repo.all(query)
    render(conn, :get_workingtimes_by_params, workingtimes: workingtimes)
  end


  def index(conn, _params) do
    workingtimes = Work.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"userID" => userID, "workingtime" => workingtime_params}) do
    user = Repo.get_by(Timemaster.Accounts.User, id: userID)
    workingtime_params = Map.put(workingtime_params, "user_id", user.id)
    with {:ok, %Workingtime{} = workingtime} <- Work.create_workingtime(workingtime_params) do
      workingtime = Repo.preload(workingtime, :user)
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"userID" => userID, "id" => id}) do
    user = Repo.get_by(Timemaster.Accounts.User, id: userID)
    workingtime = Repo.get_by(Workingtime, user_id: user.id, id: id)
    workingtime = Repo.preload(workingtime, :user)
    render(conn, :show, workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Work.get_workingtime!(id)
    workingtime = Repo.preload(workingtime, :user)
    with {:ok, %Workingtime{} = workingtime} <- Work.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Work.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Work.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
