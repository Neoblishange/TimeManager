defmodule TimemasterWeb.TeamJSON do
  alias Timemaster.Organisation.Team
  alias Timemaster.Repo

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: data(team)}
  end

  defp data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      manager: Repo.preload(team.manager, :user_roles)
    }
  end
end
