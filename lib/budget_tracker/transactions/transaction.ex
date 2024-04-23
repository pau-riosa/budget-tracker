defmodule BudgetTracker.Transactions.Transaction do
  use BudgetTracker.Schema

  schema "transactions" do
    field :date, :utc_datetime
    field :description, :string
    field :amount, Money.Ecto.Amount.Type
    field :amount_v2, BudgetTracker.Money.Ecto.Composite.Type
    belongs_to :budget_setting, BudgetTracker.BudgetSettings.BudgetSetting
    belongs_to :user, BudgetTracker.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :description, :budget_setting_id, :user_id])
    |> validate_required([:date, :description, :budget_setting_id, :user_id])
    |> validate_amount_v2(attrs)
  end

  defp validate_amount_v2(changeset, attrs) do
    case BudgetTrackerWeb.Live.Helpers.map_to_atom_keys(attrs) do
      %{amount_v2: ""} ->
        changeset

      %{amount_v2: amount} ->
        try do
          put_change(changeset, :amount_v2, Money.parse!(amount, :USD))
        rescue
          _ -> add_error(changeset, :amount_v2, "invalid amount")
        end

      _ ->
        changeset
    end
  end
end
