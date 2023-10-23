defmodule TimemasterBackWeb.UsersJSON do
  alias TimemasterBack.API.Users.Users

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(users <- users, do: data(users))}
  end

  @doc """
  Renders a single users.
  """
  def show(%{users: users}) do
    %{data: data(users)}
  end

  defp data(%Users{} = users) do
    %{
      id: users.id,
      username: users.username,
      email: users.email
    }
  end
end
