defmodule Timemaster.WorkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemaster.Work` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~U[2023-10-22 16:40:00Z],
        start: ~U[2023-10-22 16:40:00Z]
      })
      |> Timemaster.Work.create_workingtime()

    workingtime
  end
end
