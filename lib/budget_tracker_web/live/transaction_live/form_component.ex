defmodule BudgetTrackerWeb.TransactionLive.FormComponent do
  use BudgetTrackerWeb, :live_component

  alias BudgetTracker.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage transaction records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="transaction-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:category]}
          type="select"
          label="Category"
          prompt="Choose a value"
          options={Ecto.Enum.values(BudgetTracker.Transactions.Transaction, :category)}
        />
        <%= category_type_form_field(
          @form[:category].value || @form.data.category,
          assigns
        ) %>
        <.input field={@form[:date]} type="datetime-local" label="Date" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:money_in_or_out]} type="checkbox" label="Money in?" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Transaction</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def category_type_form_field(:expenses, assigns) do
    ~H"""
    <.input
      field={@form[:expense_id]}
      type="select"
      label="Expense"
      prompt="Choose an expense"
      options={@expenses}
    />
    """
  end

  def category_type_form_field(:incomes, assigns) do
    ~H"""
    <.input
      field={@form[:income_id]}
      type="select"
      label="Income"
      prompt="Choose an income"
      options={@incomes}
    />
    """
  end

  def category_type_form_field(:assets, assigns) do
    ~H"""
    <.input
      field={@form[:asset_id]}
      type="select"
      label="Asset"
      prompt="Choose an asset"
      options={@assets}
    />
    """
  end

  def category_type_form_field(:investments, assigns) do
    ~H"""
    <.input
      field={@form[:investment_id]}
      type="select"
      label="Investment"
      prompt="Choose an investment"
      options={@investments}
    />
    """
  end

  def category_type_form_field(:debts, assigns) do
    ~H"""
    <.input
      field={@form[:debt_id]}
      type="select"
      label="Debt"
      prompt="Choose a debt"
      options={@debts}
    />
    """
  end

  def category_type_form_field(category, assigns) when byte_size(category) > 0 do
    category
    |> String.to_existing_atom()
    |> category_type_form_field(assigns)
  end

  def category_type_form_field(_, assigns),
    do: ~H"""

    """

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_expenses_options()
     |> assign_incomes_options()
     |> assign_assets_options()
     |> assign_investments_options()
     |> assign_debts_options()
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Transactions.change_transaction(transaction_params)
      |> Map.put(:action, :validate)
      |> IO.inspect()

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :edit, transaction_params) do
    case Transactions.update_transaction(socket.assigns.transaction, transaction_params) do
      {:ok, transaction} ->
        notify_parent({:saved, transaction})

        {:noreply,
         socket
         |> put_flash(:info, "Transaction updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    case Transactions.create_transaction(transaction_params) do
      {:ok, transaction} ->
        notify_parent({:saved, transaction})

        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_incomes_options(socket) do
    incomes =
      Enum.map(
        BudgetTracker.Incomes.list_incomes(),
        &{&1.income_source, &1.id}
      )

    assign(socket, :incomes, incomes)
  end

  defp assign_expenses_options(socket) do
    expenses =
      Enum.map(
        BudgetTracker.Expenses.list_expenses(),
        &{&1.expense_source, &1.id}
      )

    assign(socket, :expenses, expenses)
  end

  defp assign_assets_options(socket) do
    assets =
      Enum.map(
        BudgetTracker.Assets.list_assets(),
        &{&1.asset_name, &1.id}
      )

    assign(socket, :assets, assets)
  end

  defp assign_investments_options(socket) do
    investments =
      Enum.map(
        BudgetTracker.Investments.list_investments(),
        &{&1.account_type, &1.id}
      )

    assign(socket, :investments, investments)
  end

  defp assign_debts_options(socket) do
    debts =
      Enum.map(
        BudgetTracker.Debts.list_debts(),
        &{&1.debt_type, &1.id}
      )

    assign(socket, :debts, debts)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
