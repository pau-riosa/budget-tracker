defmodule BudgetTrackerWeb.InvestmentLive.Show do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Investments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:investment, Investments.get_investment!(id))}
  end

  defp page_title(:show), do: "Show Investment"
  defp page_title(:edit), do: "Edit Investment"
end
