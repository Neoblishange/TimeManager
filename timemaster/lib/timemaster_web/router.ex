defmodule TimemasterWeb.Router do
  use TimemasterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemasterWeb do
    pipe_through :api
      resources "/users", UserController, except: [:index, :new, :edit]
      resources "/clocks", WorkingTimeController, except: [:index, :new, :edit, :update, :delete]
      resources "/workingtimes", WorkingTimeController, except: [:new, :edit]
  end
end
