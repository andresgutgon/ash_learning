defmodule AshLearningWeb.AuthComponents do
  import AshLearningWeb.CoreComponents
  import AshLearningWeb.ProviderIcons
  import Phoenix.Component, only: [to_form: 1, attr: 3, sigil_H: 2, form: 1]

  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: AshLearningWeb.Endpoint,
    router: AshLearningWeb.Router

  alias AshLearning.Accounts.User
  alias AshAuthentication.{Info, Strategy}
  alias AshPhoenix.Form

  def providers_list(assigns) do
    assigns = Map.put(assigns, :oauth_providers, oauth_providers())

    ~H"""
    <div class="space-y-3 mb-6">
      <%= for provider <- @oauth_providers do %>
        <a
          href={provider.auth_url}
          class="w-full flex items-center justify-center px-4 py-3 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 hover:border-gray-400 transition-colors duration-200 shadow-sm hover:shadow"
        >
          <.provider_icon name={provider.icon} class="w-5 h-5 mr-3" />
          Continue with {provider.display_name}
        </a>
      <% end %>
    </div>
    """
  end

  def remember_me_checkbox(assigns) do
    ~H"""
    <div class="flex items-center">
      <input
        id="remember_me"
        name="user[remember_me]"
        type="checkbox"
        value="true"
        class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
      />
      <label for="remember_me" class="ml-2 block text-sm text-gray-700">
        Remember me on this device
      </label>
    </div>
    """
  end

  attr :return_to, :string, required: false

  def magic_link_form(assigns) do
    assigns = Map.put(assigns, :form, magic_link_form_object(return_to: assigns[:return_to]))

    ~H"""
    <.form for={@form} action={~p"/magic-link"} method="post" class="mb-6">
      <div>
        <.input field={@form[:return_to]} type="hidden" />
        <.input
          field={@form[:email]}
          type="email"
          label="Email address"
          placeholder="Enter your email"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
          required
        />
      </div>
      <button
        type="submit"
        class="w-full mt-4 bg-indigo-600 text-white py-3 px-4 rounded-lg font-medium hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition-colors duration-200"
      >
        Send Magic Link
      </button>
    </.form>
    """
  end

  attr :label, :string, required: true

  def divider(assigns) do
    ~H"""
    <div class="relative mb-6">
      <div class="absolute inset-0 flex items-center">
        <div class="w-full border-t border-gray-300"></div>
      </div>
      <div class="relative flex justify-center text-sm">
        <span class="px-2 bg-white text-gray-500">{assigns[:label]}</span>
      </div>
    </div>
    """
  end

  defp magic_link_form_object(return_to: return_to) do
    domain = Info.authentication_domain!(User)

    User
    |> Form.for_action(:request_magic_link,
      domain: domain,
      as: "user",
      id: "register-magic-link-form",
      params: %{"return_to" => return_to}
    )
    |> to_form()
  end

  @doc """
  Returns a list of configured OAuth providers with their metadata.

  Each provider map contains:
  - `name` - the strategy name as a string (e.g., "github")
  - `display_name` - human readable name (e.g., "GitHub")
  - `icon` - icon identifier for provider_icon component
  - `auth_url` - the OAuth authorization URL
  """
  def oauth_providers do
    User
    |> Info.authentication_strategies()
    |> Enum.filter(fn strategy ->
      match?(%Strategy.OAuth2{}, strategy)
    end)
    |> Enum.map(fn strategy ->
      %{
        name: to_string(Strategy.name(strategy)),
        display_name: strategy_display_name(strategy),
        icon: get_strategy_icon(strategy),
        auth_url: build_oauth_url(strategy)
      }
    end)
  end

  defp strategy_display_name(%{name: :github}), do: "GitHub"
  defp strategy_display_name(%{name: :google}), do: "Google"
  defp strategy_display_name(%{name: name}), do: Phoenix.Naming.humanize(name)

  defp get_strategy_icon(%{name: :github}), do: "github"
  defp get_strategy_icon(%{name: :google}), do: "google"
  defp get_strategy_icon(_), do: "globe"

  defp build_oauth_url(strategy) do
    "/auth/user/#{strategy.name}"
  end
end
