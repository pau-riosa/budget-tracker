defmodule BudgetTracker.AssetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.Assets` context.
  """

  @doc """
  Generate a asset.
  """
  import BudgetTracker.AccountsFixtures

  def asset_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, asset} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        asset_name: "some asset_name",
        total_market_value: 120.5
      })
      |> BudgetTracker.Assets.create_asset()

    asset
  end
end
