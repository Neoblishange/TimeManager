defmodule TimemasterWeb.TeamController do
  use TimemasterWeb, :controller

  alias Timemaster.Organisation
  alias Timemaster.Organisation.Team
  alias Timemaster.Repo
  import Ecto.Query
  import Ecto.Enum

  action_fallback TimemasterWeb.FallbackController

  def get_users(conn, params) do
    case Map.fetch(params, "id") do
      {:ok, id} ->
        case Repo.get(Team, id) do
          nil ->
            conn
            |> put_status(:bad_request)
            |> json(%{message: "Team not found"})
          team ->
            users = Repo.all(from(u in Timemaster.Accounts.User, where: u.team_id == ^team.id))
            conn
            |> put_status(:ok)
            |> json(%{data: users})
        end
    end
  end

  def get_avg_workingtimes(conn, params) do
    case Map.fetch(params, "start") do
      {:ok, startTime} ->
        case Map.fetch(params, "end") do
          {:ok, endTime} ->
            case Map.fetch(params, "id") do
              {:ok, id} ->
                case Repo.get(Team, id) do
                  nil ->
                    conn
                    |> put_status(:bad_request)
                    |> json(%{message: "Team not found"})
                  team ->
                    users = Repo.all(from(u in Timemaster.Accounts.User, where: u.team_id == ^team.id))
                    workingtimes = Enum.flat_map(users, fn user ->
                      Repo.all(from(w in Timemaster.Work.Workingtime, where: w.user_id == ^user.id))
                    end)
                    times =
                      workingtimes
                      |> Enum.map(fn workingtime ->
                        if workingtime.start && workingtime.end do
                          %{date: "#{workingtime.start.year()}-#{workingtime.start.month()}-#{workingtime.start.day()}", diff: DateTime.diff(workingtime.end, workingtime.start)}
                        end
                      end)

                    {test, counts} = Enum.reduce(times, {%{}, %{}}, fn time, {test, counts} ->
                      case Map.get(counts, time.date) do
                        nil ->
                          {Map.update(test, time.date, time.diff, &(&1 + time.diff)), Map.update(counts, time.date, 1, &(&1 + 1))}
                        count ->
                          {Map.update(test, time.date, time.diff, &(&1 + time.diff)), Map.update(counts, time.date, count + 1, &(&1 + 1))}
                      end
                    end)

                    average_times = Enum.map(Map.to_list(test), fn {date, total_diff} ->
                      average_diff = div(total_diff, Map.get(counts, date, 1))
                      %{"date" => date, "average_diff" => average_diff, "total_diff" => total_diff}
                    end)

                    conn
                    |> json(%{average_times: average_times})
                end
            end
        end
    end
  end

  def add_user(conn, %{"userID" => userID, "id" => id}) do
    case Repo.get(Timemaster.Accounts.User, userID) do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "User not found"})
      user ->
        case Repo.get(Team, id) do
          nil ->
            conn
            |> put_status(:bad_request)
            |> json(%{message: "Team not found"})
          team ->
            updated_user_params = %{
              "team_id" => team.id,
            }
            with {:ok, %Timemaster.Accounts.User{} = user} <- Timemaster.Accounts.update_user(user, updated_user_params) do
              conn
              |> put_status(:ok)
              |> json(%{user: %{"user" => user, "team" => team}})
            end
        end
    end
  end


  def index(conn, _params) do
    teams = Organisation.list_teams()
    teams = Repo.preload(teams, :manager)
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    manager_id = Map.fetch(team_params, "manager_id")
    case Map.fetch(team_params, "manager_id") do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Manager ID is missing"})
      {:ok, manager_id} ->
        case Repo.get_by(Timemaster.Accounts.User, id: manager_id) do
          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{message: "User not found"})
          user ->
            if "manager" in user.roles do
              with {:ok, %Team{} = team} <- Organisation.create_team(team_params) do
                team = Repo.preload(team, :manager)
                conn
                |> put_status(:created)
                |> put_resp_header("location", ~p"/api/teams/#{team}")
                |> render(:show, team: team)
              end
            else
              conn
              |> put_status(:unauthorized)
              |> json(%{message: "User has not enough privileges"})
            end
        end
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Team, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Team not found"})
      team ->
        team = Repo.preload(team, :manager)
        render(conn, :show, team: team)
    end
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    case Repo.get(Team, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Team not found"})
      team ->
        team = Repo.preload(team, :manager)
        with {:ok, %Team{} = team} <- Organisation.update_team(team, team_params) do
          render(conn, :show, team: team)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.get(Team, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Team not found"})
      team ->
        with {:ok, %Team{}} <- Organisation.delete_team(team) do
          conn
          |> json(%{message: "Team has been deleted"})
        end
    end
  end
end
