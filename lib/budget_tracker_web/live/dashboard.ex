defmodule BudgetTrackerWeb.DashboardLive do
  use BudgetTrackerWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl">
      <.header class="text-center">
        Welcome to your dashboard
      </.header>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    {:noreply, socket}
  end
end
