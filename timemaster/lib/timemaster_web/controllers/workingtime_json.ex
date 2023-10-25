defmodule TimemasterWeb.WorkingTimeJSON do
  alias Timemaster.Work.Workingtime

  def get_workingtimes_by_params(%{workingtimes: workingtimes}) do
    %{data: for(workingtime <- workingtimes, do: data(workingtime))}
  end

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(workingtime <- workingtimes, do: data(workingtime))}
  end

  @doc """
  Renders a single workingtime.
  """
  def show(%{workingtime: workingtime}) do
    %{data: data(workingtime)}
  end

  defp data(%Workingtime{} = workingtime) do
    %{
      id: workingtime.id,
      start: workingtime.start,
      end: workingtime.end,
      user: workingtime.user
    }
  end
end
