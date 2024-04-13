defmodule BudgetTrackerWeb.TransactionLive.Index do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Transactions
  alias BudgetTracker.Transactions.Transaction

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :transactions, Transactions.list_transactions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:transaction, Transactions.get_transaction!(id))
    |> assign(
      :total_transactions,
      Transactions.total_transactions_of_user(socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, %Transaction{})
    |> assign(
      :total_transactions,
      Transactions.total_transactions_of_user(socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transactions")
    |> assign(:transaction, nil)
    |> assign(
      :total_transactions,
      Transactions.total_transactions_of_user(socket.assigns.current_user)
    )
  end

  @impl true
  def handle_info({BudgetTrackerWeb.TransactionLive.FormComponent, {:saved, transaction}}, socket) do
    {:noreply, stream_insert(socket, :transactions, transaction)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    {:noreply, stream_delete(socket, :transactions, transaction)}
  end
end
