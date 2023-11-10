defmodule TimemasterWeb.UserJSON do
  alias Timemaster.Accounts.User

  @doc"""
  Renders one user by params
  """
  def get_user_by_params(%{user: user}) do
    %{data: data(user)}
  end

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      team: user.team,
      roles: customRoles(user.user_roles)
    }
  end

  defp customRoles(user_roles) do
    data = user_roles |> Enum.map(& &1.role_id)
    data
  end
end
