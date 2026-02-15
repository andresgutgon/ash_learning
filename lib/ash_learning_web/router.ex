defmodule AshLearningWeb.Router do
  import AshLearningWeb.Auth, only: [require_user: 2, redirect_if_user_is_authenticated: 2]
  use Wayfinder.PhoenixRouter
  use AshAuthentication.Phoenix.Router
  use AshLearningWeb, :router

  alias AshAuthentication.Plug.Helpers, as: AuthHelpers
  alias AshLearningWeb.Plugs.Host

  @hosts Application.compile_env(:ash_learning, AshLearningWeb, [])
  @main_host @hosts[:main_host]
  @app_host @hosts[:app_host]

  # Custom plug to avoid ambiguous import
  def set_user_actor(conn, _opts) do
    AuthHelpers.set_actor(conn, :user)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {AshLearningWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:sign_in_with_remember_me)
    plug(:load_from_session)
    plug(:set_user_actor)
    plug(Inertia.Plug)
    plug(Host)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:load_from_bearer)
    plug(:set_user_actor)
  end

  scope "/", AshLearningWeb, host: @main_host do
    pipe_through([:browser])

    get("/", HomeController, :show, as: :public_home)
  end

  scope "/", AshLearningWeb.Auth, host: @app_host do
    pipe_through([:browser])

    get("/oauth/:provider", OAuthRedirectController, :redirect_with_return_to,
      as: :oauth_redirect
    )

    auth_routes(
      AshAuthController,
      AshLearning.Accounts.User,
      path: "/auth",
      only: [:github, :google]
    )
  end

  scope "/", AshLearningWeb.Auth, host: @app_host do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    scope "/login" do
      get("/", SessionsController, :index, as: :login)
      post("/", SessionsController, :create)
    end

    resources("/register", RegisterController, only: [:index, :create, :edit, :update])
    resources("/magic-link", MagicLinkController, only: [:create, :edit, :update])

    resources("/reset-password", ResetPasswordsController,
      only: [:index, :edit, :create, :update]
    )
  end

  scope "/", AshLearningWeb, host: @app_host do
    pipe_through([:browser, :require_user])

    scope "/", Dashboard do
      get("/", DashboardIndexController, :index, as: :dashboard)
    end

    scope "/account", Account do
      get("/connections", ConnectionsController, :index, as: :account_connections)

      delete("/connections/:provider/:uid", ConnectionsController, :delete,
        as: :delete_account_connection
      )
    end

    scope "/", Auth do
      delete("/login", SessionsController, :delete, as: :logout)
    end
  end
end
