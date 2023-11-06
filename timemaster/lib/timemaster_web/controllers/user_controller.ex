defmodule TimemasterWeb.UserController do
  use TimemasterWeb, :controller

  alias Timemaster.Accounts
  alias Timemaster.Accounts.User
  alias Timemaster.Repo
  import Joken

  action_fallback TimemasterWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{"error" => "Invalid email or password"})
      user ->
        if Bcrypt.verify_pass(password, user.password) do
          {:ok, token, _claims} = Timemaster.Token.generate_and_sign()
          extra_claims = %{"id" => user.id, "username" => user.username, "email" => user.email, "roles" => user.roles}
          token_with_custom_claims = Timemaster.Token.generate_and_sign!(extra_claims)
          conn
          |> put_status(:ok)
          |> json(%{"token" => token_with_custom_claims})
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{"error" => "Invalid email or password"})
        end
    end
  end

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
    #bearer_token = case Enum.at(conn.req_headers, 2) do
    #  {"authorization", value} -> String.split(value, " ") |> Enum.at(1)
    #  _ -> nil
    #end
    users = Accounts.list_users()
    users = Repo.preload(users, :team)
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    password = Map.get(user_params, "password")
    hashed_password = Bcrypt.hash_pwd_salt(password)
    user_params = Map.put(user_params, "password", hashed_password)
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
