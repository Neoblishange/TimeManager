defmodule TimemasterBack.API.UsersTest do
  use TimemasterBack.DataCase

  alias TimemasterBack.API.Users

  describe "users" do
    alias TimemasterBack.API.Users.Users

    import TimemasterBack.API.UsersFixtures

    @invalid_attrs %{email: nil, username: nil}

    test "list_users/0 returns all users" do
      users = users_fixture()
      assert Users.list_users() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert Users.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      valid_attrs = %{email: "some email", username: "some username"}

      assert {:ok, %Users{} = users} = Users.create_users(valid_attrs)
      assert users.email == "some email"
      assert users.username == "some username"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      update_attrs = %{email: "some updated email", username: "some updated username"}

      assert {:ok, %Users{} = users} = Users.update_users(users, update_attrs)
      assert users.email == "some updated email"
      assert users.username == "some updated username"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_users(users, @invalid_attrs)
      assert users == Users.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = Users.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> Users.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = Users.change_users(users)
    end
  end
end
