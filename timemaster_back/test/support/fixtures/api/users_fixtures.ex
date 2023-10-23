defmodule TimemasterBack.API.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimemasterBack.API.Users` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> TimemasterBack.API.Users.create_users()

    users
  end
end
