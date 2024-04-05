defmodule BudgetTracker.DebtsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.Debts

  describe "debts" do
    alias BudgetTracker.Debts.Debt

    import BudgetTracker.AccountsFixtures
    import BudgetTracker.DebtsFixtures

    @invalid_attrs %{debt_type: nil, total_amount: nil, monthly_payment_amount: nil}

    test "list_debts/0 returns all debts" do
      debt = debt_fixture()
      assert Debts.list_debts() == [debt]
    end

    test "get_debt!/1 returns the debt with given id" do
      debt = debt_fixture()
      assert Debts.get_debt!(debt.id) == debt
    end

    test "create_debt/1 with valid data creates a debt" do
      user = user_fixture()

      valid_attrs = %{
        debt_type: "some debt_type",
        total_amount: 120.5,
        monthly_payment_amount: 120.5,
        user_id: user.id
      }

      assert {:ok, %Debt{} = debt} = Debts.create_debt(valid_attrs)
      assert debt.debt_type == "some debt_type"
      assert debt.total_amount == 120.5
      assert debt.monthly_payment_amount == 120.5
    end

    test "create_debt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Debts.create_debt(@invalid_attrs)
    end

    test "update_debt/2 with valid data updates the debt" do
      debt = debt_fixture()

      update_attrs = %{
        debt_type: "some updated debt_type",
        total_amount: 456.7,
        monthly_payment_amount: 456.7
      }

      assert {:ok, %Debt{} = debt} = Debts.update_debt(debt, update_attrs)
      assert debt.debt_type == "some updated debt_type"
      assert debt.total_amount == 456.7
      assert debt.monthly_payment_amount == 456.7
    end

    test "update_debt/2 with invalid data returns error changeset" do
      debt = debt_fixture()
      assert {:error, %Ecto.Changeset{}} = Debts.update_debt(debt, @invalid_attrs)
      assert debt == Debts.get_debt!(debt.id)
    end

    test "delete_debt/1 deletes the debt" do
      debt = debt_fixture()
      assert {:ok, %Debt{}} = Debts.delete_debt(debt)
      assert_raise Ecto.NoResultsError, fn -> Debts.get_debt!(debt.id) end
    end

    test "change_debt/1 returns a debt changeset" do
      debt = debt_fixture()
      assert %Ecto.Changeset{} = Debts.change_debt(debt)
    end
  end
end
