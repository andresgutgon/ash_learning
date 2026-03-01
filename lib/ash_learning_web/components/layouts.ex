defmodule AshLearningWeb.Layouts do
  @moduledoc false
  use AshLearningWeb, :html

  embed_templates "layouts/*"
  def dev_mode? do
    dev = Application.get_env(:ash_learning, :dev_mode)
    dev_test = Application.get_env(:ash_learning, :test_dev_mode)
    dev || dev_test
  end
end
