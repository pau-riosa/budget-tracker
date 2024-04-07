defmodule BudgetTracker.TransactionsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.Transactions

  describe "transactions" do
    alias BudgetTracker.Transactions.Transaction

    import BudgetTracker.TransactionsFixtures

    @invalid_attrs %{date: nil, description: nil, category: nil, money_in_or_out: nil, amount: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{date: ~U[2024-04-06 13:45:00.000000Z], description: "some description", category: :incomes, money_in_or_out: true, amount: 120.5}

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.date == ~U[2024-04-06 13:45:00.000000Z]
      assert transaction.description == "some description"
      assert transaction.category == :incomes
      assert transaction.money_in_or_out == true
      assert transaction.amount == 120.5
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{date: ~U[2024-04-07 13:45:00.000000Z], description: "some updated description", category: :expenses, money_in_or_out: false, amount: 456.7}

      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, update_attrs)
      assert transaction.date == ~U[2024-04-07 13:45:00.000000Z]
      assert transaction.description == "some updated description"
      assert transaction.category == :expenses
      assert transaction.money_in_or_out == false
      assert transaction.amount == 456.7
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
