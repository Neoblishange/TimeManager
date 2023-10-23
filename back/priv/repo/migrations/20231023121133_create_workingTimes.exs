defmodule Back.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:workingTimes) do
      add :start, :datetime, null: false
      add :end, :datetime, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :uuid), null: false
    end

    create index(:workingTimes, [:user_id])
  end
end
