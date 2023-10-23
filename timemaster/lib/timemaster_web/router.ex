defmodule TimemasterWeb.Router do
  use TimemasterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemasterWeb do
    pipe_through :api
      resources "/users", UserController, except: [:new, :edit]
  end
end
