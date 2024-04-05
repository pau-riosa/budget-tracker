defmodule BudgetTracker.Investments.Investment do
  use BudgetTracker.Schema

  schema "investments" do
    field :type, Ecto.Enum, values: [:investment, :savings]
    field :account_type, :string
    field :amount, :float
    belongs_to :user, BudgetTracker.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(investment, attrs) do
    investment
    |> cast(attrs, [:account_type, :amount, :type, :user_id])
    |> validate_required([:account_type, :amount, :type, :user_id])
  end
end
