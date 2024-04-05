defmodule BudgetTracker.AssetsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.Assets

  describe "assets" do
    alias BudgetTracker.Assets.Asset

    import BudgetTracker.AccountsFixtures
    import BudgetTracker.AssetsFixtures

    @invalid_attrs %{total_market_value: nil, asset_name: nil}

    test "list_assets/0 returns all assets" do
      asset = asset_fixture()
      assert Assets.list_assets() == [asset]
    end

    test "get_asset!/1 returns the asset with given id" do
      asset = asset_fixture()
      assert Assets.get_asset!(asset.id) == asset
    end

    test "create_asset/1 with valid data creates a asset" do
      user = user_fixture()
      valid_attrs = %{total_market_value: 120.5, asset_name: "some asset_name", user_id: user.id}

      assert {:ok, %Asset{} = asset} = Assets.create_asset(valid_attrs)
      assert asset.total_market_value == 120.5
      assert asset.asset_name == "some asset_name"
    end

    test "create_asset/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assets.create_asset(@invalid_attrs)
    end

    test "update_asset/2 with valid data updates the asset" do
      asset = asset_fixture()
      update_attrs = %{total_market_value: 456.7, asset_name: "some updated asset_name"}

      assert {:ok, %Asset{} = asset} = Assets.update_asset(asset, update_attrs)
      assert asset.total_market_value == 456.7
      assert asset.asset_name == "some updated asset_name"
    end

    test "update_asset/2 with invalid data returns error changeset" do
      asset = asset_fixture()
      assert {:error, %Ecto.Changeset{}} = Assets.update_asset(asset, @invalid_attrs)
      assert asset == Assets.get_asset!(asset.id)
    end

    test "delete_asset/1 deletes the asset" do
      asset = asset_fixture()
      assert {:ok, %Asset{}} = Assets.delete_asset(asset)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_asset!(asset.id) end
    end

    test "change_asset/1 returns a asset changeset" do
      asset = asset_fixture()
      assert %Ecto.Changeset{} = Assets.change_asset(asset)
    end
  end
end
