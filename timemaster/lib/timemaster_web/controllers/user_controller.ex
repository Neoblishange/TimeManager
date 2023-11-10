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
          user = Repo.preload(user, :user_roles)
          extra_claims = %{"id" => user.id, "username" => user.username, "email" => user.email, "roles" => user.user_roles}
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
        user = Repo.preload(user, [:team, :user_roles])
        render(conn, :get_user_by_params, user: user)
    end
  end

  def index(conn, _params) do
    #bearer_token = case Enum.at(conn.req_headers, 2) do
    #  {"authorization", value} -> String.split(value, " ") |> Enum.at(1)
    #  _ -> nil
    #end
    users = Accounts.list_users()
    users = Repo.preload(users, [:team, :user_roles])
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    password = Map.get(user_params, "password")
    hashed_password = Bcrypt.hash_pwd_salt(password)
    user_params = Map.put(user_params, "password", hashed_password)
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      user = Repo.preload(user, [:team, :user_roles])
      roles = Map.get(user_params, "roles")
      if roles != nil do
        for role_id <- roles do
          role = Repo.get(Timemaster.Accounts.Roles, role_id)
          case role do
            nil ->
              conn
              |> put_status(:bad_request)
              |> json(%{message: "This role does not exist"})
            _ ->
              user_roles = %{user_id: user.id, role_id: role.id}
              {:ok, _} = Accounts.create_user_roles(user_roles)
          end
        end
      else
        employee_role = Repo.get_by(Timemaster.Accounts.Roles, name: "employee")
        user_roles = %{user_id: user.id, role_id: employee_role.id}
        {:ok, _} = Accounts.create_user_roles(user_roles)
      end
      user = Repo.get(User, user.id)
      user = Repo.preload(user, [:team, :user_roles])
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        user = Repo.preload(user, [:team, :user_roles])
        render(conn, :show, user: user)
    end
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User not found"})
      user ->
        roles = Map.get(user_params, "roles")
        if roles != nil do
          with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
            user = Repo.preload(user, [:team, :user_roles])
              old_user_roles = Repo.get_by(Timemaster.Accounts.UserRoles, user_id: user.id)
              if is_list(old_user_roles) do
                for old_user_role <- old_user_roles do
                  if old_user_role != nil do
                    Accounts.delete_user_roles(old_user_role)
                  end
                end
                else
                  if old_user_roles != nil do
                    Accounts.delete_user_roles(old_user_roles)
                  end
              end
              for role_id <- roles do
                role = Repo.get(Timemaster.Accounts.Roles, role_id)
                case role do
                  nil ->
                    conn
                    |> put_status(:bad_request)
                    |> json(%{message: "This role does not exist"})
                  _ ->
                    user_roles = %{user_id: user.id, role_id: role.id}
                    {:ok, _} = Accounts.create_user_roles(user_roles)
                end
              end

            user = Repo.get(User, user.id)
            user = Repo.preload(user, [:team, :user_roles])
            render(conn, :show, user: user)
          end
        else
          conn
          |> put_status(:bad_request)
          |> json(%{message: "Role is missing"})
        end
    end
  end

  def delete(conn, %{"userID" => id}) do
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
