defmodule Timemaster.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration
  import Ecto.Query
  alias Timemaster.Repo
  alias Timemaster.Accounts.Roles

  def change do
    create table(:user_roles, primary_key: false) do
      add :user_id, :binary_id
      add :role_id, :binary_id

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_roles, [:user_id, :role_id])

    Repo.insert %Roles{name: "employee"}
    Repo.insert %Roles{name: "manager"}
    Repo.insert %Roles{name: "director"}
  end
end
