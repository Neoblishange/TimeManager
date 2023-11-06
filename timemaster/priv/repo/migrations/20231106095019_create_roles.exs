  defmodule Timemaster.Repo.Migrations.CreateRoles do
    use Ecto.Migration
    import Ecto.Query
    alias Timemaster.Repo
    alias Timemaster.Accounts.Roles

    def change do
      create table(:roles, primary_key: false) do
        add :id, :binary_id, primary_key: true
        add :name, :string

        timestamps(type: :utc_datetime)
      end
    end
  end
