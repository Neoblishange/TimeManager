defmodule Timemaster.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :email, :username, :roles]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :username, :string
    field :roles, {:array, :string}, default: ["employee"]#employee/manager/director
    belongs_to :team, Timemaster.Organisation.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :roles, :team_id])
    |> validate_required([:username, :email])
    |> unique_constraint(:email)
  end
end
