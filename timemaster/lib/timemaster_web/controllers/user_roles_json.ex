defmodule TimemasterWeb.UserRolesJSON do
  alias Timemaster.Accounts.UserRoles

  @doc """
  Renders a list of user_roles.
  """
  def index(%{user_roles: user_roles}) do
    %{data: for(user_roles <- user_roles, do: data(user_roles))}
  end

  @doc """
  Renders a single user_roles.
  """
  def show(%{user_roles: user_roles}) do
    %{data: data(user_roles)}
  end

  defp data(%UserRoles{} = user_roles) do
    %{
      user_id: user_roles.user_id,
      role_id: user_roles.role_id,
    }
  end
end
