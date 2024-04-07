defmodule BudgetTrackerWeb.IncomeLive.Index do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Incomes
  alias BudgetTracker.Incomes.Income

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :incomes, Incomes.list_incomes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Income")
    |> assign(:income, Incomes.get_income!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Income")
    |> assign(:income, %Income{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Incomes")
    |> assign(:income, nil)
  end

  @impl true
  def handle_info({BudgetTrackerWeb.IncomeLive.FormComponent, {:saved, income}}, socket) do
    {:noreply, stream_insert(socket, :incomes, income)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    income = Incomes.get_income!(id)
    {:ok, _} = Incomes.delete_income(income)

    {:noreply, stream_delete(socket, :incomes, income)}
  end
end
