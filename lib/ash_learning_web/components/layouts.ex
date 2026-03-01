defmodule AshLearningWeb.Layouts do
  @moduledoc false
  use AshLearningWeb, :html

  embed_templates "layouts/*"
  def dev_mode? do
    Application.get_env(:ash_learning, :dev_mode)
  end
end
