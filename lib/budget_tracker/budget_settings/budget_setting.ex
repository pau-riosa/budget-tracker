defmodule BudgetTracker.BudgetSettings.BudgetSetting do
  use BudgetTracker.Schema

  schema "budget_settings" do
    field :name, :string
    field :color, :string, default: "#000000"
    field :category, Ecto.Enum, values: [:incomes, :expenses, :savings, :investments, :debts]
    field :planned_amount, Money.Ecto.Amount.Type
    belongs_to :user, BudgetTracker.Accounts.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget_setting, attrs) do
    budget_setting
    |> cast(attrs, [:category, :name, :planned_amount, :user_id, :color])
    |> validate_required([:category, :name, :planned_amount, :user_id, :color])
  end
end
