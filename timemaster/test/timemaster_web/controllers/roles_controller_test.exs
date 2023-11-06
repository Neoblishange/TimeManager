defmodule TimemasterWeb.RolesControllerTest do
  use TimemasterWeb.ConnCase

  import Timemaster.AccountsFixtures

  alias Timemaster.Accounts.Roles

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all roles", %{conn: conn} do
      conn = get(conn, ~p"/api/roles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create roles" do
    test "renders roles when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/roles", roles: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/roles", roles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update roles" do
    setup [:create_roles]

    test "renders roles when data is valid", %{conn: conn, roles: %Roles{id: id} = roles} do
      conn = put(conn, ~p"/api/roles/#{roles}", roles: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, roles: roles} do
      conn = put(conn, ~p"/api/roles/#{roles}", roles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete roles" do
    setup [:create_roles]

    test "deletes chosen roles", %{conn: conn, roles: roles} do
      conn = delete(conn, ~p"/api/roles/#{roles}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/roles/#{roles}")
      end
    end
  end

  defp create_roles(_) do
    roles = roles_fixture()
    %{roles: roles}
  end
end
