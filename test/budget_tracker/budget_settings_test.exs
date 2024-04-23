defmodule BudgetTracker.BudgetSettingsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.BudgetSettings

  describe "budget_settings" do
    alias BudgetTracker.BudgetSettings.BudgetSetting

    import BudgetTracker.AccountsFixtures
    import BudgetTracker.BudgetSettingsFixtures

    @invalid_attrs %{name: nil, category: nil, planned_amount: nil}

    test "valid planned_amount_v2 with currency even with letters" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      attrs = %{"planned_amount_v2" => "₱ 123,412asdfasdf"}

      assert changeset = BudgetSetting.changeset(budget_setting, attrs)
      assert changeset.valid?
    end

    test "valid planned_amount_v2 with currency" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      attrs = %{"planned_amount_v2" => "₱ 123,412"}

      assert changeset = BudgetSetting.changeset(budget_setting, attrs)
      assert changeset.valid?
    end

    test "invalid planned_amount_v2" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      attrs = %{"planned_amount_v2" => "a"}

      assert changeset = BudgetSetting.changeset(budget_setting, attrs)
      assert errors_on(changeset).planned_amount_v2 == ["invalid amount"]
      refute changeset.valid?
    end

    test "valid planned_amount_v2 -> whole number" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      attrs = %{"planned_amount_v2" => "1000000"}

      changeset = BudgetSetting.changeset(budget_setting, attrs)
      assert changeset.valid?

      assert {:ok, result} = BudgetTracker.Repo.update(changeset)
      assert result.planned_amount_v2 == %Money{amount: 100_000_000, currency: :USD}
    end

    test "valid planned_amount_v2 -> decimal number" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      attrs = %{"planned_amount_v2" => "10000.00"}

      changeset = BudgetSetting.changeset(budget_setting, attrs)
      assert changeset.valid?

      assert {:ok, result} = BudgetTracker.Repo.update(changeset)
      assert result.planned_amount_v2 == %Money{amount: 1_000_000, currency: :USD}
    end

    test "list_budget_settings/0 returns all budget_settings" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      assert BudgetSettings.list_budget_settings() == [budget_setting]
    end

    test "get_budget_setting!/1 returns the budget_setting with given id" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      assert BudgetSettings.get_budget_setting!(budget_setting.id) == budget_setting
    end

    test "create_budget_setting/1 with valid data creates a budget_setting" do
      user = user_fixture()

      valid_attrs = %{
        name: "some name",
        category: :incomes,
        planned_amount_v2: 120,
        user_id: user.id
      }

      assert {:ok, %BudgetSetting{} = budget_setting} =
               BudgetSettings.create_budget_setting(valid_attrs)

      assert budget_setting.name == "some name"
      assert budget_setting.category == :incomes
      assert budget_setting.planned_amount_v2 == %Money{amount: 12000, currency: :USD}
    end

    test "create_budget_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BudgetSettings.create_budget_setting(@invalid_attrs)
    end

    test "update_budget_setting/2 with valid data updates the budget_setting" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})

      update_attrs = %{
        name: "some updated name",
        category: :expenses,
        planned_amount_v2: 456
      }

      assert {:ok, %BudgetSetting{} = budget_setting} =
               BudgetSettings.update_budget_setting(budget_setting, update_attrs)

      assert budget_setting.name == "some updated name"
      assert budget_setting.category == :expenses
      assert budget_setting.planned_amount_v2 == %Money{amount: 45600, currency: :USD}
    end

    test "update_budget_setting/2 with invalid data returns error changeset" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} =
               BudgetSettings.update_budget_setting(budget_setting, @invalid_attrs)

      assert budget_setting == BudgetSettings.get_budget_setting!(budget_setting.id)
    end

    test "delete_budget_setting/1 deletes the budget_setting" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      assert {:ok, %BudgetSetting{}} = BudgetSettings.delete_budget_setting(budget_setting)

      assert_raise Ecto.NoResultsError, fn ->
        BudgetSettings.get_budget_setting!(budget_setting.id)
      end
    end

    test "change_budget_setting/1 returns a budget_setting changeset" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = BudgetSettings.change_budget_setting(budget_setting)
    end
  end
end
