defmodule AshLearningWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use AshLearningWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  @hosts Application.compile_env(:ash_learning, AshLearningWeb, [])

  using do
    quote do
      # The default endpoint for testing
      @endpoint AshLearningWeb.Endpoint

      use AshLearningWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import AshLearningWeb.ConnCase
    end
  end

  @doc """
  Builds a connection with the main host (public site).
  """
  def build_main_conn do
    conn = Phoenix.ConnTest.build_conn()
    %{conn | host: @hosts[:main_host] || "localhost"}
  end

  @doc """
  Builds a connection with the app host (authenticated app).
  """
  def build_app_conn do
    conn = Phoenix.ConnTest.build_conn()
    %{conn | host: @hosts[:app_host] || "localhost"}
  end

  setup tags do
    AshLearning.DataCase.setup_sandbox(tags)

    conn =
      case tags[:host] do
        :main -> build_main_conn()
        :app -> build_app_conn()
        _ -> Phoenix.ConnTest.build_conn()
      end

    {:ok, conn: conn}
  end
end
