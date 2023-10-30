defmodule Timemaster.OrganisationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemaster.Organisation` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Timemaster.Organisation.create_team()

    team
  end
end
