defmodule Timemaster.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :email, :username, :team_id, :user_roles]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    belongs_to :team, Timemaster.Organisation.Team
    has_many :user_roles, Timemaster.Accounts.UserRoles

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :team_id])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:email)
  end
end
