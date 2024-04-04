defmodule BudgetTracker.TransactionsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.Transactions

  describe "incomes" do
    alias BudgetTracker.Transactions.Income

    import BudgetTracker.AccountsFixtures
    import BudgetTracker.TransactionsFixtures

    @invalid_attrs %{income_source: nil, amount: nil}

    test "list_incomes/0 returns all incomes" do
      income = income_fixture()
      assert Transactions.list_incomes() == [income]
    end

    test "get_income!/1 returns the income with given id" do
      income = income_fixture()
      assert Transactions.get_income!(income.id) == income
    end

    test "create_income/1 with valid data creates a income" do
      user = user_fixture()

      valid_attrs = %{
        income_source: "some income_source",
        amount: 120.5,
        user_id: user.id
      }

      assert {:ok, %Income{} = income} = Transactions.create_income(valid_attrs)
      assert income.income_source == "some income_source"
      assert income.amount == 120.5
    end

    test "create_income/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_income(@invalid_attrs)
    end

    test "update_income/2 with valid data updates the income" do
      income = income_fixture()
      update_attrs = %{income_source: "some updated income_source", amount: 456.7}

      assert {:ok, %Income{} = income} = Transactions.update_income(income, update_attrs)
      assert income.income_source == "some updated income_source"
      assert income.amount == 456.7
    end

    test "update_income/2 with invalid data returns error changeset" do
      income = income_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_income(income, @invalid_attrs)
      assert income == Transactions.get_income!(income.id)
    end

    test "delete_income/1 deletes the income" do
      income = income_fixture()
      assert {:ok, %Income{}} = Transactions.delete_income(income)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_income!(income.id) end
    end

    test "change_income/1 returns a income changeset" do
      income = income_fixture()
      assert %Ecto.Changeset{} = Transactions.change_income(income)
    end
  end
end
