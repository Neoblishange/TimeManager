defmodule Timemaster.Repo do
  use Ecto.Repo,
    otp_app: :timemaster,
    adapter: Ecto.Adapters.Postgres
end
