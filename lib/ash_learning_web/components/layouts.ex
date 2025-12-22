defmodule AshLearningWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use AshLearningWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true
  attr :current_user, :any, default: nil, doc: "the current authenticated user"

  def app(assigns) do
    ~H"""
    <!-- Fixed top bar positioned over content -->
    <header class="fixed top-0 left-0 right-0 z-50 bg-base-100/95 backdrop-blur border-b border-base-300">
      <div class="navbar px-4 sm:px-6 lg:px-8">
        <div class="flex-1">
          <a href="/" class="flex items-center gap-2">
            <img src={~p"/images/logo.svg"} width="36" />
            <span class="text-sm font-semibold">AshLearning</span>
          </a>
        </div>
        <div class="flex-none">
          <ul class="flex items-center space-x-4">
            <li>
              <.theme_toggle />
            </li>
            <%= if assigns[:current_user] do %>
              <li>
                <span class="text-sm">Hello, {@current_user.email}</span>
              </li>
              <li>
                <.link href={~p"/login"} method="delete" class="btn btn-ghost btn-sm">
                  Logout
                </.link>
              </li>
            <% else %>
              <li>
                <a href={~p"/login"} class="btn btn-ghost btn-sm">Log In</a>
              </li>
              <li>
                <a href={~p"/register"} class="btn btn-primary btn-sm">Register</a>
              </li>
            <% end %>
          </ul>
        </div>
      </div>
    </header>

    <main class="pt-16">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true
  attr :current_user, :any, default: nil, doc: "the current authenticated user"
  attr :title, :string, required: true
  attr :description, :string, required: true

  def auth(assigns) do
    ~H"""
    <.app flash={@flash}>
      <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full bg-white rounded-xl shadow-lg p-8">
          <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900">{@title}</h1>
            <p class="mt-2 text-gray-600">{@description}</p>
          </div>
          {render_slot(@inner_block)}
        </div>
      </div>
    </.app>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
