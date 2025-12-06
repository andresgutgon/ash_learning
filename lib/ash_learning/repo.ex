defmodule AshLearning.Repo do
  use Ecto.Repo,
    otp_app: :ash_learning,
    adapter: Ecto.Adapters.Postgres
end
