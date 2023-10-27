defmodule Timemaster.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :manager_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
    create index(:teams, [:manager_id])

    alter table(:users) do
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
    end
  end
end
