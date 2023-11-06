defmodule TimemasterWeb.RolesController do
  use TimemasterWeb, :controller

  alias Timemaster.Accounts
  alias Timemaster.Accounts.Roles

  action_fallback TimemasterWeb.FallbackController

  def index(conn, _params) do
    roles = Accounts.list_roles()
    render(conn, :index, roles: roles)
  end

  def create(conn, %{"roles" => roles_params}) do
    with {:ok, %Roles{} = roles} <- Accounts.create_roles(roles_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/roles/#{roles}")
      |> render(:show, roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    roles = Accounts.get_roles!(id)
    render(conn, :show, roles: roles)
  end

  def update(conn, %{"id" => id, "roles" => roles_params}) do
    roles = Accounts.get_roles!(id)

    with {:ok, %Roles{} = roles} <- Accounts.update_roles(roles, roles_params) do
      render(conn, :show, roles: roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    roles = Accounts.get_roles!(id)

    with {:ok, %Roles{}} <- Accounts.delete_roles(roles) do
      send_resp(conn, :no_content, "")
    end
  end
end
