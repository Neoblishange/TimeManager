defmodule Timemaster.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemaster.Time` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2023-10-22 16:47:00Z]
      })
      |> Timemaster.Time.create_clock()

    clock
  end
end
