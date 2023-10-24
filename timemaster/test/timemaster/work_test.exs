defmodule Timemaster.WorkTest do
  use Timemaster.DataCase

  alias Timemaster.Work

  describe "workingtimes" do
    alias Timemaster.Work.Workingtime

    import Timemaster.WorkFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtime = workingtime_fixture()
      assert Work.list_workingtimes() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert Work.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      valid_attrs = %{start: ~U[2023-10-22 16:40:00Z], end: ~U[2023-10-22 16:40:00Z]}

      assert {:ok, %Workingtime{} = workingtime} = Work.create_workingtime(valid_attrs)
      assert workingtime.start == ~U[2023-10-22 16:40:00Z]
      assert workingtime.end == ~U[2023-10-22 16:40:00Z]
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{start: ~U[2023-10-23 16:40:00Z], end: ~U[2023-10-23 16:40:00Z]}

      assert {:ok, %Workingtime{} = workingtime} = Work.update_workingtime(workingtime, update_attrs)
      assert workingtime.start == ~U[2023-10-23 16:40:00Z]
      assert workingtime.end == ~U[2023-10-23 16:40:00Z]
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == Work.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = Work.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Work.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = Work.change_workingtime(workingtime)
    end
  end
end
