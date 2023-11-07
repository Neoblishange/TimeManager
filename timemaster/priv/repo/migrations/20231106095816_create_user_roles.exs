defmodule Timemaster.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles, primary_key: false) do
      add :user_id, :binary_id
      add :role_id, :binary_id

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_roles, [:user_id, :role_id])
  end
end
