defmodule AshLearningWeb.Components.IdentityComponents do
  @moduledoc """
  Components for managing user identities (OAuth providers)
  """
  use AshLearningWeb, :html

  alias AshLearningWeb.AuthComponents

  @doc """
  Displays a list of OAuth providers with connection status
  """
  attr :current_user, :map, required: true
  attr :class, :string, default: ""

  def identity_list(assigns) do
    providers = AuthComponents.oauth_providers()

    assigns =
      assigns
      |> assign(:providers, providers)
      |> assign(:identities_by_provider, group_identities_by_provider(assigns.current_user))

    ~H"""
    <div class={["space-y-4", @class]}>
      <h2 class="text-lg font-semibold">Connect your accounts</h2>
      <p class="text-base-content/70">
        Link your social accounts to enable sign-in with multiple providers.
      </p>

      <div class="space-y-3">
        <%= for provider <- @providers do %>
          <.provider_section
            provider={provider}
            identities={Map.get(@identities_by_provider, provider.name, [])}
          />
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Provider section showing the provider and all connected identities
  """
  attr :provider, :map, required: true
  attr :identities, :list, default: []

  def provider_section(assigns) do
    ~H"""
    <div class="border border-base-300 rounded-lg bg-base-100 overflow-hidden">
      <%!-- Provider header with connect button --%>
      <div class="flex items-center justify-between p-4 bg-base-200/50">
        <div class="flex items-center gap-3">
          <.provider_icon name={@provider.icon} />
          <div>
            <h3 class="font-medium">{@provider.display_name}</h3>
            <%= if @identities == [] do %>
              <p class="text-sm text-base-content/60">Not connected</p>
            <% else %>
              <p class="text-sm text-success">
                <.icon name="hero-check-circle" class="w-4 h-4 inline mr-1" />
                {length(@identities)} account(s) connected
              </p>
            <% end %>
          </div>
        </div>

        <.link href={@provider.auth_url} class="btn btn-sm btn-primary">
          <.icon name="hero-link" class="w-4 h-4" />
          <%= if @identities == [], do: "Connect", else: "Add another" %>
        </.link>
      </div>

      <%!-- Connected identities list --%>
      <%= if @identities != [] do %>
        <div class="divide-y divide-base-300">
          <.identity_row :for={identity <- @identities} identity={identity} provider={@provider} />
        </div>
      <% end %>
    </div>
    """
  end

  @doc """
  Individual connected identity row
  """
  attr :identity, :map, required: true
  attr :provider, :map, required: true

  def identity_row(assigns) do
    ~H"""
    <div class="flex items-center justify-between p-3 pl-12">
      <div class="flex items-center gap-2">
        <%= if @identity.avatar_url do %>
          <img
            src={@identity.avatar_url}
            alt={"#{@provider.display_name} profile"}
            referrerpolicy="no-referrer"
            class="w-8 h-8 rounded-full"
          />
        <% end %>
        <div>
          <%= if @identity.full_name do %>
            <span class="text-sm font-medium">{@identity.full_name}</span>
          <% end %>
          <%= if @identity.email do %>
            <p class="text-xs text-base-content/60">{@identity.email}</p>
          <% end %>
        </div>
      </div>

      <.link
        href={~p"/disconnect/#{@provider.name}/#{@identity.uid}"}
        method="delete"
        class="btn btn-xs btn-outline btn-error"
        data-confirm={"Are you sure you want to disconnect this #{@provider.display_name} account?"}
      >
        <.icon name="hero-x-mark" class="w-3 h-3" /> Disconnect
      </.link>
    </div>
    """
  end

  # Helper function to group identities by provider/strategy
  defp group_identities_by_provider(user) do
    case user do
      %{identities: identities} when is_list(identities) ->
        Enum.group_by(identities, & &1.strategy)

      _ ->
        %{}
    end
  end
end
