defmodule BudgetTrackerWeb.DebtLive.Index do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Debts
  alias BudgetTracker.Debts.Debt

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :debts, Debts.list_debts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Debt")
    |> assign(:debt, Debts.get_debt!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Debt")
    |> assign(:debt, %Debt{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Debts")
    |> assign(:debt, nil)
  end

  @impl true
  def handle_info({BudgetTrackerWeb.DebtLive.FormComponent, {:saved, debt}}, socket) do
    {:noreply, stream_insert(socket, :debts, debt)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    debt = Debts.get_debt!(id)
    {:ok, _} = Debts.delete_debt(debt)

    {:noreply, stream_delete(socket, :debts, debt)}
  end
end
