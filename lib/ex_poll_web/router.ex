defmodule ExPollWeb.Router do
  use ExPollWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExPollWeb do
    pipe_through :api

    get "/person/:name", WebhookController, :getnameperson
    put "/person/:id", WebhookController, :putperson

    get "/vehicle", WebhookController, :getqueryvehicle
    post "/vehicle", WebhookController, :postvehicle
    get "/vehicle/header", WebhookController, :headervehicle
    post "/vehicle/status", WebhookController, :statusvehicle
    post "/vehicles", WebhookController, :multiplevehicles
    post "/vehicle/raw/:id", WebhookController, :postvehicleraw

    get "/consume", WebhookController, :consumeservice
    get "/consume2", WebhookController, :consumeservicedecode

    #resources "/polls", PollController, except: [:new, :edit]
    # do
    #   resources "/options", OptionController, except: [:new, :edit]
    # end


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
      live_dashboard "/dashboard", metrics: ExPollWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
