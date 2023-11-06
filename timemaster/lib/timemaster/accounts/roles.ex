defmodule Timemaster.Accounts.Roles do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "roles" do
    field :name, :string
    has_many :user_roles, Timemaster.Accounts.UserRoles

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(roles, attrs) do
    roles
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
