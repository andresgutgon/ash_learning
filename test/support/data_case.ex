defmodule AshLearning.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use AshLearning.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias AshLearning.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import AshLearning.DataCase
      import AshLearning.Factory
      import AshLearning.DataCase
      import TestHelpers
    end
  end

  setup tags do
    AshLearning.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  For E2E tests (when E2E=true), uses shared mode so Phoenix server can access test data.
  """
  def setup_sandbox(tags) do
    e2e_mode = System.get_env("E2E") == "true"

    if e2e_mode do
      # E2E tests need shared database access because:
      # 1. Test process creates test data (users, etc.)
      # 2. Phoenix server process handles HTTP requests
      # 3. Both processes need to see the same database state
      # Without shared mode, each process would have isolated data
      pid = Sandbox.start_owner!(AshLearning.Repo, shared: true)

      # Grant the test process permission to use the shared sandbox
      # The Phoenix server will automatically get access via shared: true
      Sandbox.allow(AshLearning.Repo, pid, self())

      on_exit(fn -> Sandbox.stop_owner(pid) end)
    else
      # Normal unit/integration tests use isolated sandbox
      pid = Sandbox.start_owner!(AshLearning.Repo, shared: not tags[:async])
      on_exit(fn -> Sandbox.stop_owner(pid) end)
    end
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
