defmodule BudgetTracker.Expenses.Expense do
  use BudgetTracker.Schema

  schema "expenses" do
    field :type, Ecto.Enum, values: [:variable, :fixed]
    field :expense_source, :string
    field :amount, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:expense_source, :amount, :type])
    |> validate_required([:expense_source, :amount, :type])
  end
end
