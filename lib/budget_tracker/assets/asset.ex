defmodule BudgetTracker.Assets.Asset do
  use BudgetTracker.Schema

  schema "assets" do
    field :total_market_value, :float
    field :asset_name, :string
    belongs_to :user, BudgetTracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:total_market_value, :asset_name, :user_id])
    |> validate_required([:total_market_value, :asset_name, :user_id])
  end
end
