defmodule BudgetTrackerWeb.DebtLive.Show do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Debts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:debt, Debts.get_debt!(id))}
  end

  defp page_title(:show), do: "Show Debt"
  defp page_title(:edit), do: "Edit Debt"
end
