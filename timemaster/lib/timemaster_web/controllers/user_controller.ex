defmodule TimemasterWeb.UserController do
  use TimemasterWeb, :controller

  alias Timemaster.Accounts
  alias Timemaster.Accounts.User
  alias Timemaster.Repo

  action_fallback TimemasterWeb.FallbackController

  def get_user_by_params(conn, %{"email" => email, "username" => username}) do
    case Repo.get_by(User, email: email, username: username) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        user = Repo.preload(user, :team)
        render(conn, :get_user_by_params, user: user)
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    users = Repo.preload(users, :team)
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      user = Repo.preload(user, :team)
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        user = Repo.preload(user, :team)
        render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          user = Repo.preload(user, :team)
          render(conn, :show, user: user)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        with {:ok, %User{}} <- Accounts.delete_user(user) do
          conn
          |> json(%{message: "User deleted"})
        end
    end
  end

  def delete_all(conn, _params) do
    Repo.update_all(Timemaster.Organisation.Team, set: [manager_id: nil])
    Repo.delete_all(User)
    conn
    |> json(%{message: "All users have been deleted"})
  end
end
