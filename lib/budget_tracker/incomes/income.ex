defmodule BudgetTracker.Incomes.Income do
  use BudgetTracker.Schema

  schema "incomes" do
    field :income_source, :string
    field :amount, :float
    belongs_to :user, BudgetTracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(income, attrs) do
    income
    |> cast(attrs, [:income_source, :amount, :user_id])
    |> validate_required([:income_source, :amount, :user_id])
  end
end
