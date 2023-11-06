defmodule Timemaster.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :email, :username, :team_id, :roles]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    field :roles, {:array, :string}, default: ["employee"]#employee/manager/director
    belongs_to :team, Timemaster.Organisation.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :roles, :team_id])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:email)
  end
end
