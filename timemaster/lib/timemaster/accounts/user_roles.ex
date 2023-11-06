defmodule Timemaster.Accounts.UserRoles do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:role_id]}
  @primary_key false
  @foreign_key_type :binary_id
  schema "user_roles" do
    field :user_id, :binary_id, primary_key: true
    field :role_id, :binary_id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_roles, attrs) do
    user_roles
    |> cast(attrs, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> unique_constraint([:user_id, :role_id])
  end
end
