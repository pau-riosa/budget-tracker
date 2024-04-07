defmodule BudgetTracker.Transactions.Transaction do
  use BudgetTracker.Schema

  schema "transactions" do
    field :date, :utc_datetime_usec
    field :description, :string
    field :category, Ecto.Enum, values: [:incomes, :expenses, :assets, :investments, :debts]
    field :money_in_or_out, :boolean, default: false
    field :amount, :float

    belongs_to :income, BudgetTracker.Incomes.Income
    belongs_to :expense, BudgetTracker.Expenses.Expense
    belongs_to :asset, BudgetTracker.Assets.Asset
    belongs_to :investment, BudgetTracker.Investments.Investment
    belongs_to :debt, BudgetTracker.Debts.Debt

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :date,
      :description,
      :category,
      :money_in_or_out,
      :amount,
      :income_id,
      :expense_id,
      :asset_id,
      :investment_id,
      :debt_id
    ])
    |> validate_required([:date, :description, :category, :money_in_or_out, :amount])
    |> check_category_type(attrs)
    |> check_constraint(:check_exclusive, name: :check_exclusive)
  end

  defp check_category_type(changeset, %{"category" => "assets", "asset_id" => ""} = attrs) do
    add_error(changeset, :asset_id, "please select an asset")
  end

  defp check_category_type(
         changeset,
         %{"category" => "investments", "investment_id" => ""} = attrs
       ) do
    add_error(changeset, :investment_id, "please select an investment")
  end

  defp check_category_type(changeset, %{"category" => "debts", "debt_id" => ""} = attrs) do
    add_error(changeset, :debt_id, "please select a debt")
  end

  defp check_category_type(changeset, %{"category" => "incomes", "income_id" => ""} = attrs) do
    add_error(changeset, :income_id, "please select an income")
  end

  defp check_category_type(changeset, %{"category" => "expenses", "expense_id" => ""} = attrs) do
    add_error(changeset, :expense_id, "please select an expense")
  end

  defp check_category_type(changeset, _attrs) do
    changeset
  end
end
