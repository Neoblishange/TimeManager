defmodule TimemasterBack.Repo do
  use Ecto.Repo,
    otp_app: :timemaster_back,
    adapter: Ecto.Adapters.Postgres
end
