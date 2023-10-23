defmodule TimemasterBackWeb.UsersController do
  use TimemasterBackWeb, :controller

  alias TimemasterBack.API.Users
  alias TimemasterBack.API.Users.Users

  action_fallback TimemasterBackWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"users" => users_params}) do
    with {:ok, %Users{} = users} <- Users.create_users(users_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{users}")
      |> render(:show, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    users = Users.get_users!(id)
    render(conn, :show, users: users)
  end

  def update(conn, %{"id" => id, "users" => users_params}) do
    users = Users.get_users!(id)

    with {:ok, %Users{} = users} <- Users.update_users(users, users_params) do
      render(conn, :show, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    users = Users.get_users!(id)

    with {:ok, %Users{}} <- Users.delete_users(users) do
      send_resp(conn, :no_content, "")
    end
  end
end
