defmodule TimemasterBackWeb.Router do
  use TimemasterBackWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemasterBackWeb do
    pipe_through :api

    resources "/users", UsersController, except: [:new, :edit]
  end
end
