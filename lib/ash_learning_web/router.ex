defmodule AshLearningWeb.Router do
  use AshLearningWeb, :router

  use AshAuthentication.Phoenix.Router

  import AshAuthentication.Plug.Helpers

  defp require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: "/sign-in")
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
    get "/link/github", AuthController, :link_github
    get "/link/google", AuthController, :link_google
    delete "/disconnect/:provider", AuthController, :disconnect_provider
  end

  scope "/", AshLearningWeb do
    pipe_through :browser

    auth_routes AuthController, AshLearning.Accounts.User, path: "/auth"

    # My UI authentication routes
    sign_out_route AuthController

    # Remove these if you'd like to use your own authentication views
    sign_in_route register_path: "/register",
                  reset_path: "/reset",
                  auth_routes_prefix: "/auth",
                  on_mount: [{AshLearningWeb.LiveUserAuth, :live_no_user}],
                  overrides: [
                    AshLearningWeb.AuthOverrides,
                    Elixir.AshAuthentication.Phoenix.Overrides.DaisyUI
                  ]

    reset_route auth_routes_prefix: "/auth",
                overrides: [
                  AshLearningWeb.AuthOverrides,
                  Elixir.AshAuthentication.Phoenix.Overrides.DaisyUI
                ]

    confirm_route AshLearning.Accounts.User, :confirm_new_user,
      auth_routes_prefix: "/auth",
      overrides: [
        AshLearningWeb.AuthOverrides,
        Elixir.AshAuthentication.Phoenix.Overrides.DaisyUI
      ]

    magic_sign_in_route(AshLearning.Accounts.User, :magic_link,
      auth_routes_prefix: "/auth",
      overrides: [
        AshLearningWeb.AuthOverrides,
        Elixir.AshAuthentication.Phoenix.Overrides.DaisyUI
      ]
    )
  end

  # Other scopes may use custom stacks.
  # scope "/api", AshLearningWeb do
  #   pipe_through :api
  # end

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
