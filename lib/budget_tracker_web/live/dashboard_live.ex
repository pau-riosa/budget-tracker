defmodule BudgetTrackerWeb.DashboardLive.Index do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.Transactions

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl space-y-5 px-4 sm:px-6 lg:px-8 mt-3">
      <.header>
        <h1 class="font-semibold">Dashboard</h1>
        <:actions>
          <.link patch={~p"/transactions/new"}>
            <.button>New Transaction</.button>
          </.link>
        </:actions>
      </.header>
      <div class="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-5">
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
      <div class="mx-auto grid max-w-2xl items-center grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-1">
        <.async_result :let={transactions} assign={@overall_transaction_list}>
          <:loading>Loading Overall Transactions Analytics...</:loading>
          <:failed>There was an error loading overall transactions analytics...</:failed>
          <div class="w-full h-96">
            <canvas
              phx-hook="BarChart"
              id="overall-transaction-list"
              class="col-span-1"
              data-title="Overall Transactions by Type"
              data-items={Jason.encode!(transactions)}
            >
            </canvas>
          </div>
        </.async_result>
        <.async_result :let={transactions} assign={@transaction_list}>
          <:loading>Loading Transactions Analytics Category...</:loading>
          <:failed>There was an error loading transactions analytics by category...</:failed>
          <div class="w-full flex items-center justify-center h-96">
            <canvas
              phx-hook="HorizontalBarChart"
              id="pie-chart-overall-transaction-list"
              class="col-span-1"
              data-title="Overall Transactions by Category"
              data-items={Jason.encode!(transactions)}
            >
            </canvas>
          </div>
        </.async_result>
      </div>
    </div>
    """
  end

  def total_value_card(assigns) do
    ~H"""
    <.async_result :let={amount} assign={@amount}>
      <:loading>
        <div class="animate-pulse overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200">
          <div class="space-y-5 px-4 py-5 sm:p-6">
            <dt class="text-sm font-medium leading-6 text-gray-500">
              <div class="h-2 bg-gray-300 rounded"></div>
            </dt>
            <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900">
              <div class="w-1/2 h-2 bg-gray-300 rounded"></div>
            </dd>
          </div>
        </div>
      </:loading>
      <:failed :let={_reason}>
        <p>There was an error loading the result</p>
      </:failed>
      <.link patch={@path}>
        <div class="overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200">
          <div class="px-4 py-5 sm:p-6">
            <dt class="text-sm font-medium leading-6 text-gray-500">
              <%= @title %>
            </dt>
            <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900 line-clamp-1">
              <%= amount %>
            </dd>
          </div>
        </div>
      </.link>
    </.async_result>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> assign_async_transaction_list()
     |> assign_async_overall_transaction_list_by_category()
     |> assign_async_incomes_total_amount()
     |> assign_async_expenses_total_amount()
     |> assign_async_debts_total_amount()
     |> assign_async_investments_total_amount()
     |> assign_async_savings_total_amount()}
  end

  defp assign_async_transaction_list(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :transaction_list, fn ->
      transactions =
        current_user
        |> Transactions.list_transactions_of_user()
        |> Enum.map(&Transactions.transaction_to_map(&1, :budget_name))
        |> Enum.group_by(&Map.get(&1, :category))
        |> transform_transactions()

      {:ok, %{transaction_list: transactions}}
    end)
  end

  defp assign_async_overall_transaction_list_by_category(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :overall_transaction_list, fn ->
      transactions =
        current_user
        |> Transactions.list_transactions_of_user()
        |> Enum.map(&Transactions.transaction_to_map/1)
        |> Enum.group_by(&Map.get(&1, :category))
        |> transform_transactions()

      {:ok, %{overall_transaction_list: transactions}}
    end)
  end

  defp transform_transactions(transactions) do
    transactions
    |> Stream.map(fn {category, transactions} ->
      Enum.reduce(
        transactions,
        %{category: category, amount: Money.new(0, :PHP), color: "#FFFFFF"},
        fn transaction, acc ->
          result = Money.add(acc.amount, transaction.amount)
          %{acc | amount: result, color: transaction.color}
        end
      )
    end)
    |> Stream.map(fn transaction ->
      %{transaction | amount: transaction.amount.amount}
    end)
    |> Enum.to_list()
  end

  defp assign_async_incomes_total_amount(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :incomes_total_amount, fn ->
      total_amount =
        Transactions.total_transactions_of_user_per_category(
          current_user,
          :incomes
        )

      {:ok, %{incomes_total_amount: total_amount || 0}}
    end)
  end

  defp assign_async_expenses_total_amount(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :expenses_total_amount, fn ->
      total_amount =
        Transactions.total_transactions_of_user_per_category(
          current_user,
          :expenses
        )

      {:ok, %{expenses_total_amount: total_amount || 0}}
    end)
  end

  defp assign_async_debts_total_amount(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :debts_total_amount, fn ->
      total_amount =
        Transactions.total_transactions_of_user_per_category(
          current_user,
          :debts
        )

      {:ok, %{debts_total_amount: total_amount || 0}}
    end)
  end

  defp assign_async_investments_total_amount(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :investments_total_amount, fn ->
      total_amount =
        Transactions.total_transactions_of_user_per_category(
          current_user,
          :investments
        )

      {:ok, %{investments_total_amount: total_amount || 0}}
    end)
  end

  defp assign_async_savings_total_amount(socket) do
    current_user = socket.assigns.current_user

    assign_async(socket, :savings_total_amount, fn ->
      total_amount =
        Transactions.total_transactions_of_user_per_category(
          current_user,
          :savings
        )

      {:ok, %{savings_total_amount: total_amount || 0}}
    end)
  end
end
