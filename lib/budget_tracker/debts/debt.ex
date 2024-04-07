defmodule BudgetTracker.Debts.Debt do
  use BudgetTracker.Schema

  schema "debts" do
    field :debt_type, :string
    field :total_amount, :float
    field :monthly_payment_amount, :float
    belongs_to :user, BudgetTracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(debt, attrs) do
    debt
    |> cast(attrs, [:debt_type, :total_amount, :monthly_payment_amount, :user_id])
    |> validate_required([:debt_type, :total_amount, :monthly_payment_amount, :user_id])
  end
end
