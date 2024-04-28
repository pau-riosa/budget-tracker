defmodule BudgetTracker.BudgetSettings.BudgetSetting do
  use BudgetTracker.Schema

  schema "budget_settings" do
    field :name, :string
    field :color, :string, default: "#000000"
    field :category, Ecto.Enum, values: [:incomes, :expenses, :savings, :investments, :debts]
    field :type, Ecto.Enum, values: [:fixed, :variable, :planned], default: :planned
    field :planned_amount, Money.Ecto.Amount.Type

    field :planned_amount_v2, BudgetTracker.Money.Ecto.Composite.Type

    belongs_to :user, BudgetTracker.Accounts.User

    field :actual_amount, Money.Ecto.Amount.Type, virtual: true
    field :diff_amount, Money.Ecto.Amount.Type, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget_setting, attrs) do
    budget_setting
    |> cast(attrs, [
      :category,
      :name,
      :user_id,
      :color,
      :type
    ])
    |> validate_required([:category, :name, :user_id, :color])
    |> validate_planned_amount_v2(attrs)
    |> add_random_color()
  end

  defp add_random_color(changeset) do
    case changeset.data do
      %__MODULE__{color: "#000000"} ->
        put_change(changeset, :color, RandomColor.rgba([format: :string], 0.5))

      _ ->
        changeset
    end
  end

  defp validate_planned_amount_v2(changeset, attrs) do
    case BudgetTrackerWeb.Live.Helpers.map_to_atom_keys(attrs) do
      %{planned_amount_v2: ""} ->
        changeset

      %{planned_amount_v2: amount} ->
        try do
          put_change(changeset, :planned_amount_v2, Money.parse!(amount, :PHP))
        rescue
          _ -> add_error(changeset, :planned_amount_v2, "invalid amount")
        end

      _ ->
        changeset
    end
  end
end
