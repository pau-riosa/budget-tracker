defmodule BudgetTrackerWeb.DashboardLive.Index do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Transactions

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 mt-3">
      <div class="flex justify-end py-4">
        <h1 class="font-bold text-5xl">April 2024</h1>
      </div>
      <div class="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-4">
        <.total_value_card path={~p"/incomes"} title="Total Incomes" amount={@incomes_total_amount} />
        <.total_value_card
          path={~p"/expenses"}
          title="Total Expenses"
          amount={@expenses_total_amount}
        />
        <.total_value_card path={~p"/debts"} title="Total Debts" amount={@debts_total_amount} />
        <.total_value_card
          path={~p"/investments"}
          title="Total Investments"
          amount={@investments_total_amount}
        />
        <.total_value_card path={~p"/savings"} title="Total Savings" amount={@savings_total_amount} />
      </div>
    </div>
    """
  end

  def total_value_card(assigns) do
    ~H"""
    <.link patch={@path}>
      <div class="overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200">
        <div class="px-4 py-5 sm:p-6">
          <dt class="text-sm font-medium leading-6 text-gray-500">
            <%= @title %>
          </dt>
          <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900">
            <%= @amount %>
          </dd>
        </div>
      </div>
    </.link>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       incomes_total_amount:
         Transactions.total_transactions_of_user_per_category(
           socket.assigns.current_user,
           :incomes
         ) || 0
     )
     |> assign(
       expenses_total_amount:
         Transactions.total_transactions_of_user_per_category(
           socket.assigns.current_user,
           :expenses
         ) || 0
     )
     |> assign(
       debts_total_amount:
         Transactions.total_transactions_of_user_per_category(
           socket.assigns.current_user,
           :debts
         ) || 0
     )
     |> assign(
       investments_total_amount:
         Transactions.total_transactions_of_user_per_category(
           socket.assigns.current_user,
           :investments
         ) || 0
     )
     |> assign(
       savings_total_amount:
         Transactions.total_transactions_of_user_per_category(
           socket.assigns.current_user,
           :savings
         ) || 0
     )}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
