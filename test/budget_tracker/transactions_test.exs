defmodule BudgetTracker.TransactionsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.Transactions

  describe "transactions" do
    alias BudgetTracker.Transactions.Transaction

    import BudgetTracker.AccountsFixtures
    import BudgetTracker.BudgetSettingsFixtures
    import BudgetTracker.TransactionsFixtures

    @invalid_attrs %{date: nil, description: nil, amount: nil}
    test "valid amount_v2 with letters" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      attrs = %{"amount_v2" => "₱ 123,412asdfasdf"}
      changeset = Transaction.changeset(transaction, attrs)
      assert changeset.valid?
    end

    test "valid amount_v2 with currency" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      attrs = %{"amount_v2" => "₱ 123,412"}
      changeset = Transaction.changeset(transaction, attrs)
      assert changeset.valid?
    end

    test "invalid amount_v2" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      attrs = %{"amount_v2" => "hello world"}

      changeset = Transaction.changeset(transaction, attrs)

      assert errors_on(changeset).amount_v2 == ["invalid amount"]
      refute changeset.valid?
    end

    test "valid amount_v2 -> whole number" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      attrs = %{"amount_v2" => "1000000"}

      changeset = Transaction.changeset(transaction, attrs)
      assert changeset.valid?

      assert {:ok, result} = BudgetTracker.Repo.update(changeset)
      assert result.amount_v2 == %Money{amount: 100_000_000, currency: :PHP}
    end

    test "valid amount_v2 -> decimal number" do
      user = user_fixture()
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
      attrs = %{"amount_v2" => "10000.00"}

      changeset = Transaction.changeset(transaction, attrs)
      assert changeset.valid?

      assert {:ok, result} = BudgetTracker.Repo.update(changeset)
      assert result.amount_v2 == %Money{amount: 1_000_000, currency: :PHP}
    end

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
        amount_v2: 42,
        user_id: user.id,
        budget_setting_id: budget_setting.id
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.date == ~U[2024-04-11 23:04:00Z]
      assert transaction.description == "some description"
      assert transaction.amount_v2 == %Money{amount: 4200, currency: :PHP}
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
        amount_v2: 43
      }

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.date == ~U[2024-04-12 23:04:00Z]
      assert transaction.description == "some updated description"
      assert transaction.amount_v2 == %Money{amount: 4300, currency: :PHP}
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
