defmodule Timemaster.Repo.Migrations.InsertDefaultData do
  use Ecto.Migration
  import Ecto.Query
  alias Timemaster.Repo
  alias Timemaster.Accounts.Roles
  alias Timemaster.Accounts.User
  alias Timemaster.Accounts.UserRoles

  def change do
    {:ok, employee_role} = Repo.insert %Roles{name: Application.get_env(:timemaster, :employee)}
    {:ok, manager_role} = Repo.insert %Roles{name: Application.get_env(:timemaster, :manager)}
    {:ok, director_role} = Repo.insert %Roles{name: Application.get_env(:timemaster, :director)}

    {:ok, director} = Repo.insert %User{username: "director", email: "director@director.com", password: Bcrypt.hash_pwd_salt("director")}
    Repo.insert %UserRoles{user_id: director.id, role_id: employee_role.id}
    Repo.insert %UserRoles{user_id: director.id, role_id: manager_role.id}
    Repo.insert %UserRoles{user_id: director.id, role_id: director_role.id}
  end
end
