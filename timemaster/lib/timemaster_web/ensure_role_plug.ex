defmodule Timemaster.EnsureRolePlug do
  import Plug.Conn
  alias Timemaster.Repo

  def init(opts), do: opts

  def call(conn, roles) do
    case Timemaster.JwtAuthPlug.jwt_from_authorization(conn) do
      { :success, data } ->
        user_roles = Map.get(data.claims, "roles")
        user_roles = for role <- user_roles do
          Repo.get(Timemaster.Accounts.Roles, Map.get(role, "role_id"))
        end

        case user_roles do
          [nil] ->
            conn
            |> not_enough_privileges
          _ ->
            has_matching_role = Enum.any?(roles, fn role_name ->
              Enum.any?(user_roles, fn user_role ->
                user_role.name == role_name
              end)
            end)
            if has_matching_role do
              if !Map.get(conn.path_params, "teamID")
                 && Map.get(conn.path_params, "userID")
                 && Map.get(conn.assigns.claims, "id") != Map.get(conn.path_params, "userID") do
                conn
                |> forbidden
                else
                conn
              end
            else
              conn
              |> not_enough_privileges
            end

        end

      _ ->
        conn
        |> not_enough_privileges
    end
  end

  defp not_enough_privileges(conn) do
    response = %{"message" => "Unauthorized: You have not enough privileges"}
    conn
    |> put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(401, Poison.encode!(response))
    |> Plug.Conn.halt()
  end

  defp forbidden(conn) do
    response = %{"message" => "Unauthorized: It's not your account"}
    conn
    |> put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(401, Poison.encode!(response))
    |> Plug.Conn.halt()
  end
end
