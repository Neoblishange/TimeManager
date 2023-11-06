defmodule TimemasterWeb.Router do
  use TimemasterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Timemaster.JwtAuthPlug
  end

  pipeline :no_auth do
    plug :accepts, ["json"]
  end

  scope "/api", TimemasterWeb do
    pipe_through :no_auth
      post "/login", UserController, :login
      post "/users", UserController, :create
    pipe_through :api
      get "/users", UserController, :get_user_by_params
      get "/users/all", UserController, :index
      put "/users/:id", UserController, :update
      delete "/users", UserController, :delete_all
      resources "/users", UserController, except: [:index, :new, :edit, :update]

      get "/workingtimes/:userID", WorkingTimeController, :get_workingtimes_by_params
      get "/workingtimes/:userID/:id", WorkingTimeController, :show
      post "/workingtimes/:userID", WorkingTimeController, :create
      put "/workingtimes/:id", WorkingTimeController, :update
      resources "/workingtimes", WorkingTimeController, except: [:create, :show, :index, :new, :edit, :update]

      get "/clocks/:userID", ClockController, :user_clock
      post "/clocks/:userID", ClockController, :create

      get "/teams/:id/users", TeamController, :get_users
      get "/teams/:id/avg", TeamController, :get_avg_workingtimes
      post "/teams/:userID/:id", TeamController, :add_user
      put "/teams/:id", TeamController, :update
      resources "/teams", TeamController, except: [:update, :new, :edit]
  end
end
