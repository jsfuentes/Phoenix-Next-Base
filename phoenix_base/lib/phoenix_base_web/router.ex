defmodule PhoenixBaseWeb.Router do
  use PhoenixBaseWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :nextjs do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  scope "/api", PhoenixBaseWeb do
    pipe_through :api

    get "/", ApiController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: PhoenixBaseWeb.Telemetry
    end
  end

  # scope "/" do
  #   pipe_through [:nextjs]

  #   get "/*path", ReverseProxy, upstream: [Application.fetch_env!(:phoenix_base, :node_server)]
  # end
end
