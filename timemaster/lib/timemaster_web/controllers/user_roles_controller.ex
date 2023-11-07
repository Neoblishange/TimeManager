defmodule TimemasterWeb.UserRolesController do
  use TimemasterWeb, :controller

  alias Timemaster.Accounts
  alias Timemaster.Accounts.UserRoles

  action_fallback TimemasterWeb.FallbackController

  def index(conn, _params) do
    user_roles = Accounts.list_user_roles()
    render(conn, :index, user_roles: user_roles)
  end

  def create(conn, %{"user_roles" => user_roles_params}) do
    with {:ok, %UserRoles{} = user_roles} <- Accounts.create_user_roles(user_roles_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/user_roles/#{user_roles}")
      |> render(:show, user_roles: user_roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user_roles = Accounts.get_user_roles!(id)
    render(conn, :show, user_roles: user_roles)
  end

  def update(conn, %{"id" => id, "user_roles" => user_roles_params}) do
    user_roles = Accounts.get_user_roles!(id)

    with {:ok, %UserRoles{} = user_roles} <- Accounts.update_user_roles(user_roles, user_roles_params) do
      render(conn, :show, user_roles: user_roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_roles = Accounts.get_user_roles!(id)

    with {:ok, %UserRoles{}} <- Accounts.delete_user_roles(user_roles) do
      send_resp(conn, :no_content, "")
    end
  end
end
