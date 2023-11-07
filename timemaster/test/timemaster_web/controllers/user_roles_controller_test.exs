defmodule TimemasterWeb.UserRolesControllerTest do
  use TimemasterWeb.ConnCase

  import Timemaster.AccountsFixtures

  alias Timemaster.Accounts.UserRoles

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_roles", %{conn: conn} do
      conn = get(conn, ~p"/api/user_roles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_roles" do
    test "renders user_roles when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_roles", user_roles: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/user_roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_roles", user_roles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_roles" do
    setup [:create_user_roles]

    test "renders user_roles when data is valid", %{conn: conn, user_roles: %UserRoles{id: id} = user_roles} do
      conn = put(conn, ~p"/api/user_roles/#{user_roles}", user_roles: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/user_roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_roles: user_roles} do
      conn = put(conn, ~p"/api/user_roles/#{user_roles}", user_roles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_roles" do
    setup [:create_user_roles]

    test "deletes chosen user_roles", %{conn: conn, user_roles: user_roles} do
      conn = delete(conn, ~p"/api/user_roles/#{user_roles}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/user_roles/#{user_roles}")
      end
    end
  end

  defp create_user_roles(_) do
    user_roles = user_roles_fixture()
    %{user_roles: user_roles}
  end
end
