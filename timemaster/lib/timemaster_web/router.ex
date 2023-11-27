defmodule TimemasterWeb.Router do
  use TimemasterWeb, :router

  pipeline :employee do
    plug :accepts, ["json"]
    plug Timemaster.EnsureRolePlug, ["employee"]
  end

  pipeline :manager do
    plug :accepts, ["json"]
    plug Timemaster.EnsureRolePlug, ["manager"]
  end

  pipeline :director do
    plug :accepts, ["json"]
    plug Timemaster.EnsureRolePlug, ["director"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Timemaster.JwtAuthPlug
    plug CORSPlug
  end

  pipeline :no_auth do
    plug :accepts, ["json"]
  end

  scope "/api", TimemasterWeb do
    pipe_through [:api, :director]
      get "/users/all", UserController, :index
      delete "/users", UserController, :delete_all
  end

  scope "/api", TimemasterWeb do
    pipe_through [:api, :manager]
      get "/teams/:teamID", TeamController, :show
      get "/teams/:teamID/users", TeamController, :get_users
      get "/teams/:teamID/avg", TeamController, :get_avg_workingtimes
      post "/teams/:userID/:teamID", TeamController, :add_user
      put "/teams/:teamID", TeamController, :update
      delete "/teams/:teamID", TeamController, :delete
      resources "/teams", TeamController, except: [:show, :update, :new, :edit, :delete]
  end

  scope "/api", TimemasterWeb do
    pipe_through :no_auth
      post "/login", UserController, :login
      post "/users", UserController, :create

    pipe_through [:api, :employee]
      get "/users", UserController, :get_user_by_params
      get "/users/:userID", UserController, :show
      put "/users/:userID", UserController, :update
      delete "/users/:userID", UserController, :delete
      resources "/users", UserController, except: [:show, :index, :new, :edit, :update, :delete]

      get "/workingtimes/:userID", WorkingTimeController, :get_workingtimes_by_params
      get "/workingtimes/:userID/:workingtimeID", WorkingTimeController, :show
      post "/workingtimes/:userID", WorkingTimeController, :create
      put "/workingtimes/:workingtimeID", WorkingTimeController, :update
      delete "/workingtimes/:workingtimeID", WorkingTimeController, :delete
      resources "/workingtimes", WorkingTimeController, except: [:create, :show, :index, :new, :edit, :update, :delete]

      get "/clocks/:userID", ClockController, :user_clock
      post "/clocks/:userID", ClockController, :create

      resources "/roles", RolesController, except: [:update, :edit, :delete]
  end
end
