defmodule TimemasterWeb.RolesJSON do
  alias Timemaster.Accounts.Roles

  @doc """
  Renders a list of roles.
  """
  def index(%{roles: roles}) do
    %{data: for(roles <- roles, do: data(roles))}
  end

  @doc """
  Renders a single roles.
  """
  def show(%{roles: roles}) do
    %{data: data(roles)}
  end

  defp data(%Roles{} = roles) do
    %{
      id: roles.id,
      name: roles.name
    }
  end
end
