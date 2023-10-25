defmodule TimemasterWeb.Router do
  use TimemasterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemasterWeb do
    pipe_through :api
      get "/users", UserController, :get_user_by_params
      put "/users/:id", UserController, :update
      resources "/users", UserController, except: [:index, :new, :edit, :update]

      get "/workingtimes/:userID", WorkingTimeController, :get_workingtimes_by_params
      get "/workingtimes/:userID/:id", WorkingTimeController, :show
      post "/workingtimes/:userID", WorkingTimeController, :create
      put "/workingtimes/:id", WorkingTimeController, :update
      resources "/workingtimes", WorkingTimeController, except: [:create, :show, :index, :new, :edit, :update]

      get "/clocks/:userID", ClockController, :user_clocks
      post "/clocks/:userID", ClockController, :create
  end
end
