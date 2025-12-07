defmodule AshLearningWeb.Components.IdentityComponents do
  @moduledoc """
  Components for managing user identities (OAuth providers)
  """
  use AshLearningWeb, :html

  @doc """
  Displays a list of OAuth providers with connection status
  """
  attr :current_user, :map, required: true
  attr :class, :string, default: ""

  def identity_list(assigns) do
    # Get providers based on user's actual identities
    providers = get_user_providers(assigns.current_user)

    assigns = assign(assigns, :providers, providers)

    ~H"""
    <div class={["space-y-4", @class]}>
      <h2 class="text-lg font-semibold">Connect your accounts</h2>
      <p class="text-base-content/70">
        Link your social accounts to enable sign-in with multiple providers.
      </p>

      <div class="space-y-3">
        <.identity_card
          :for={provider <- @providers}
          provider={provider}
          identity={get_identity_for_provider(@current_user, provider.name)}
        />
      </div>
    </div>
    """
  end

  @doc """
  Individual identity card component
  """
  attr :provider, :map, required: true
  attr :identity, :map, default: nil

  def identity_card(assigns) do
    ~H"""
    <div class="flex items-center justify-between p-4 border border-base-300 rounded-lg bg-base-100">
      <div class="flex items-center gap-3">
        <.provider_icon name={@provider.name} />
        <div>
          <h3 class="font-medium">{@provider.display_name}</h3>
          <%= if @identity do %>
            <p class="text-sm text-success">
              <.icon name="hero-check-circle" class="w-4 h-4 inline mr-1" /> Connected
              <%= if @identity.email do %>
                as {@identity.email}
              <% end %>
            </p>
          <% else %>
            <p class="text-sm text-base-content/60">Not connected</p>
          <% end %>
        </div>
      </div>

      <div class="flex items-center gap-2">
        <%= if @identity do %>
          <%= if @identity.avatar_url do %>
            <img
              src={@identity.avatar_url}
              alt="{@provider.display_name} profile"
              class="w-8 h-8 rounded-full"
            />
          <% end %>
          <.link
            href={~p"/disconnect/#{@provider.name}"}
            method="delete"
            class="btn btn-sm btn-outline btn-error"
            data-confirm={"Are you sure you want to disconnect your #{@provider.display_name} account?"}
          >
            <.icon name="hero-x-mark" class="w-4 h-4" /> Disconnect
          </.link>
        <% else %>
          <a
            href={@provider.link_path}
            class="btn btn-sm btn-outline hover:scale-105 transition-transform"
          >
            <.icon name={@provider.icon} class="w-4 h-4" /> Connect
          </a>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Provider-specific icons
  """
  attr :name, :string, required: true
  attr :class, :string, default: "w-6 h-6"

  def provider_icon(assigns) do
    ~H"""
    <%= case @name do %>
      <% "github" -> %>
        <div class={["text-gray-700", @class]}>
          <svg viewBox="0 0 24 24" fill="currentColor" class={@class}>
            <path d="M12 0C5.37 0 0 5.506 0 12.303c0 5.445 3.435 10.043 8.205 11.674.6.107.825-.262.825-.585 0-.292-.015-1.261-.015-2.291C6 21.67 5.22 20.346 4.98 19.654c-.135-.354-.72-1.446-1.23-1.738-.42-.23-1.02-.8-.015-.815.945-.015 1.62.892 1.845 1.261 1.08 1.86 2.805 1.338 3.495 1.015.105-.8.42-1.338.765-1.645-2.67-.308-5.46-1.37-5.46-6.075 0-1.338.465-2.446 1.23-3.307-.12-.308-.54-1.569.12-3.26 0 0 1.005-.323 3.3 1.26.96-.276 1.98-.415 3-.415s2.04.139 3 .416c2.295-1.6 3.3-1.261 3.3-1.261.66 1.691.24 2.952.12 3.26.765.861 1.23 1.953 1.23 3.307 0 4.721-2.805 5.767-5.475 6.075.435.384.81 1.122.81 2.276 0 1.645-.015 2.968-.015 3.383 0 .323.225.707.825.585a12.047 12.047 0 0 0 5.919-4.489A12.536 12.536 0 0 0 24 12.304C24 5.505 18.63 0 12 0Z" />
          </svg>
        </div>
      <% "google" -> %>
        <div class={["text-blue-500", @class]}>
          <svg viewBox="0 0 24 24" fill="currentColor" class={@class}>
            <path
              d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              fill="#4285F4"
            />
            <path
              d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              fill="#34A853"
            />
            <path
              d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              fill="#FBBC05"
            />
            <path
              d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              fill="#EA4335"
            />
          </svg>
        </div>
      <% _ -> %>
        <.icon name="hero-globe-alt" class={@class} />
    <% end %>
    """
  end

  # Helper function to get providers based on user identities
  defp get_user_providers(user) do
    case user do
      %{identities: identities} when is_list(identities) ->
        identities
        |> Enum.map(&create_provider_config/1)
        |> Enum.uniq_by(& &1.name)

      _ ->
        []
    end
  end

  # Helper function to create provider config from identity
  defp create_provider_config(%{strategy: strategy}) do
    case strategy do
      "github" ->
        %{
          name: "github",
          display_name: "GitHub",
          icon: "hero-arrow-top-right-on-square",
          link_path: ~p"/link/github"
        }

      "google" ->
        %{
          name: "google",
          display_name: "Google",
          icon: "hero-arrow-top-right-on-square",
          link_path: "/link/google"
        }

      _ ->
        %{
          name: strategy,
          display_name: String.capitalize(strategy),
          icon: "hero-globe-alt",
          link_path: "/link/#{strategy}"
        }
    end
  end

  # Helper function to get identity for a provider
  defp get_identity_for_provider(user, provider_name) do
    case user do
      %{identities: identities} when is_list(identities) ->
        Enum.find(identities, fn identity -> identity.strategy == provider_name end)

      _ ->
        nil
    end
  end
end
