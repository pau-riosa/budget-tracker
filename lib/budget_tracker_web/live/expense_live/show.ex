defmodule BudgetTrackerWeb.ExpenseLive.Show do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Expenses

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:expense, Expenses.get_expense!(id))}
  end

  defp page_title(:show), do: "Show Expense"
  defp page_title(:edit), do: "Edit Expense"
end
