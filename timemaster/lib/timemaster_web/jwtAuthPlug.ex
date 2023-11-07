defmodule Timemaster.JwtAuthPlug do
  import Plug.Conn
  alias Timemaster.JwtAuthToken
  require Poison

  def init(opts), do: opts

  def call(conn, _opts) do
    case jwt_from_authorization(conn) do
      { :success, data } ->
        conn
        |> success(data)
      _ ->
        conn
        |> forbidden
    end
  end

  defp public_key do
    # Votre clé publique, lisez-la à partir d'un fichier PEM, d'une variable d'environnement, ou autre
  end

  defp success(conn, token_payload) do
    assign(conn, :claims, token_payload.claims)
    |> assign(:jwt, token_payload.token)
  end

  def jwt_from_authorization(conn) do
    [bearer_token] = for {"authorization", token} <- conn.req_headers do
      String.split(token, " ") |> Enum.at(1)
    end

    case bearer_token do
      nil -> conn |> forbidden
      jwt ->
        case JwtAuthToken.decode(jwt, 'oui') do
          {:ok, claims} ->
            { :success, %{token: jwt, claims: claims} }
          _ -> conn |> forbidden
        end
    end
  end

  defp forbidden(conn) do
    response = %{"message" => "Unauthorized: You are not connected"}
    conn
    |> put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(401, Poison.encode!(response))
    |> Plug.Conn.halt()
  end
end
