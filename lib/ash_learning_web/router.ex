defmodule AshLearningWeb.Router do
  use AshLearningWeb, :router

  use AshAuthentication.Phoenix.Router

  import AshAuthentication.Plug.Helpers

  defp require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(to: "/login")
      |> halt()
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshLearningWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :sign_in_with_remember_me
    plug :load_from_session
    plug :set_actor, :user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
    plug :set_actor, :user
  end

  pipeline :require_auth do
    plug :require_authenticated_user
  end

  scope "/", AshLearningWeb do
    pipe_through [:browser, :require_auth]

    get "/", PageController, :home
    delete "/disconnect/:provider/:uid", AuthController, :disconnect_provider
  end

  scope "/", AshLearningWeb do
    pipe_through :browser

    auth_routes AuthController,
                AshLearning.Accounts.User,
                path: "/auth",
                only: [:github, :google]

    scope "/login" do
      get "/", SessionsController, :index
      post "/", SessionsController, :create
      delete "/", SessionsController, :delete
    end

    resources "/register", RegisterController, only: [:index, :create, :edit, :update]
    resources "/magic-link", MagicLinkController, only: [:create, :edit, :update]
    resources "/reset-password", ResetPasswordsController, only: [:index, :edit, :create, :update]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_learning, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AshLearningWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
