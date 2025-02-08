defmodule ScadaWeb.Router do
  use ScadaWeb, :router

  # Pipeline for handling browser-related requests
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ScadaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScadaWeb do
    pipe_through :browser

    live "/", Pages.ScadaLive
  end

  if Application.compile_env(:scada, :dev_routes) do
    # import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      # LiveView route for connection page
      live "/", Pages.ScadaLive
    end
  end
end
