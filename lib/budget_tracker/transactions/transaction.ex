defmodule BudgetTracker.Transactions.Transaction do
  use BudgetTracker.Schema

  schema "transactions" do
    field :date, :utc_datetime
    field :description, :string
    field :amount, Money.Ecto.Amount.Type
    belongs_to :budget_setting, BudgetTracker.BudgetSettings.BudgetSetting
    belongs_to :user, BudgetTracker.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :amount, :description, :budget_setting_id, :user_id])
    |> validate_required([:date, :amount, :description, :budget_setting_id, :user_id])
  end
end
