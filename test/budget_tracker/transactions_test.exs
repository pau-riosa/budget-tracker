defmodule BudgetTracker.TransactionsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.Transactions

  describe "transactions" do
    alias BudgetTracker.Transactions.Transaction

    import BudgetTracker.AccountsFixtures
    import BudgetTracker.BudgetSettingsFixtures
    import BudgetTracker.TransactionsFixtures

    @invalid_attrs %{date: nil, description: nil, amount: nil}

    test "list_transactions/0 returns all transactions" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})

      valid_attrs = %{
        date: ~U[2024-04-11 23:04:00Z],
        description: "some description",
        amount: 42,
        user_id: user.id,
        budget_setting_id: budget_setting.id
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.date == ~U[2024-04-11 23:04:00Z]
      assert transaction.description == "some description"
      assert transaction.amount == %Money{amount: 42, currency: :PHP}
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})

      update_attrs = %{
        date: ~U[2024-04-12 23:04:00Z],
        description: "some updated description",
        amount: 43
      }

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.date == ~U[2024-04-12 23:04:00Z]
      assert transaction.description == "some updated description"
      assert transaction.amount == %Money{amount: 43, currency: :PHP}
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
