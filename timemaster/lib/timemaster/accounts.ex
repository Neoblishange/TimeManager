defmodule Timemaster.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Timemaster.Repo

  alias Timemaster.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Timemaster.Accounts.Roles

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Roles{}, ...]

  """
  def list_roles do
    Repo.all(Roles)
  end

  @doc """
  Gets a single roles.

  Raises `Ecto.NoResultsError` if the Roles does not exist.

  ## Examples

      iex> get_roles!(123)
      %Roles{}

      iex> get_roles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_roles!(id), do: Repo.get!(Roles, id)

  @doc """
  Creates a roles.

  ## Examples

      iex> create_roles(%{field: value})
      {:ok, %Roles{}}

      iex> create_roles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_roles(attrs \\ %{}) do
    %Roles{}
    |> Roles.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a roles.

  ## Examples

      iex> update_roles(roles, %{field: new_value})
      {:ok, %Roles{}}

      iex> update_roles(roles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_roles(%Roles{} = roles, attrs) do
    roles
    |> Roles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a roles.

  ## Examples

      iex> delete_roles(roles)
      {:ok, %Roles{}}

      iex> delete_roles(roles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_roles(%Roles{} = roles) do
    Repo.delete(roles)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking roles changes.

  ## Examples

      iex> change_roles(roles)
      %Ecto.Changeset{data: %Roles{}}

  """
  def change_roles(%Roles{} = roles, attrs \\ %{}) do
    Roles.changeset(roles, attrs)
  end

  alias Timemaster.Accounts.UserRoles

  @doc """
  Returns the list of user_roles.

  ## Examples

      iex> list_user_roles()
      [%UserRoles{}, ...]

  """
  def list_user_roles do
    Repo.all(UserRoles)
  end

  @doc """
  Gets a single user_roles.

  Raises `Ecto.NoResultsError` if the User roles does not exist.

  ## Examples

      iex> get_user_roles!(123)
      %UserRoles{}

      iex> get_user_roles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_roles!(id), do: Repo.get!(UserRoles, id)

  @doc """
  Creates a user_roles.

  ## Examples

      iex> create_user_roles(%{field: value})
      {:ok, %UserRoles{}}

      iex> create_user_roles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_roles(attrs \\ %{}) do
    %UserRoles{}
    |> UserRoles.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_roles.

  ## Examples

      iex> update_user_roles(user_roles, %{field: new_value})
      {:ok, %UserRoles{}}

      iex> update_user_roles(user_roles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_roles(%UserRoles{} = user_roles, attrs) do
    user_roles
    |> UserRoles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_roles.

  ## Examples

      iex> delete_user_roles(user_roles)
      {:ok, %UserRoles{}}

      iex> delete_user_roles(user_roles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_roles(%UserRoles{} = user_roles) do
    Repo.delete(user_roles)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_roles changes.

  ## Examples

      iex> change_user_roles(user_roles)
      %Ecto.Changeset{data: %UserRoles{}}

  """
  def change_user_roles(%UserRoles{} = user_roles, attrs \\ %{}) do
    UserRoles.changeset(user_roles, attrs)
  end
end
