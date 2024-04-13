defmodule BudgetTrackerWeb.TransactionLiveTest do
  use BudgetTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import BudgetTracker.BudgetSettingsFixtures
  import BudgetTracker.TransactionsFixtures

  @create_attrs %{date: "2024-04-11T23:04:00Z", description: "some description", amount: 42}
  @update_attrs %{
    date: "2024-04-12T23:04:00Z",
    description: "some updated description",
    amount: 43
  }
  @invalid_attrs %{date: nil, description: nil, amount: nil}

  setup [:register_and_log_in_user]

  defp create_transaction(%{user: user}) do
    budget_setting = budget_setting_fixture(%{user_id: user.id})
    transaction = transaction_fixture(%{user_id: user.id, budget_setting_id: budget_setting.id})
    %{transaction: transaction}
  end

  describe "Index" do
    setup [:create_transaction]

    test "be able to see formatted datetime", %{conn: conn, transaction: transaction} do
      %{date: date} = transaction
      {:ok, _index_live, html} = live(conn, ~p"/transactions")

      expected_result = BudgetTrackerWeb.Live.Helpers.format_datetime(date)
      assert html =~ expected_result
    end

    test "show total transactions", %{conn: conn, user: user} do
      total_amount = BudgetTracker.Transactions.total_transactions_of_user(user)
      {:ok, _index_live, html} = live(conn, ~p"/transactions")
      assert html =~ "Total Transactions"
      assert html =~ to_string(total_amount)
    end

    test "lists all transactions", %{conn: conn, transaction: transaction} do
      {:ok, _index_live, html} = live(conn, ~p"/transactions")

      assert html =~ "Listing Transactions"
      assert html =~ transaction.description
    end

    test "saves new transaction", %{conn: conn, user: user} do
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      {:ok, index_live, _html} = live(conn, ~p"/transactions")

      assert index_live |> element("a", "New Transaction") |> render_click() =~
               "New Transaction"

      assert_patch(index_live, ~p"/transactions/new")

      assert index_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      attrs =
        @create_attrs
        |> Map.put(:user_id, user.id)
        |> Map.put(:budget_setting_id, budget_setting.id)

      assert index_live
             |> form("#transaction-form", transaction: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/transactions")

      html = render(index_live)
      assert html =~ "Transaction created successfully"
      assert html =~ "some description"
    end

    test "updates transaction in listing", %{conn: conn, transaction: transaction, user: user} do
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      {:ok, index_live, _html} = live(conn, ~p"/transactions")

      assert index_live |> element("#transactions-#{transaction.id} a", "Edit") |> render_click() =~
               "Edit Transaction"

      assert_patch(index_live, ~p"/transactions/#{transaction}/edit")

      assert index_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      attrs =
        @update_attrs
        |> Map.put(:user_id, user.id)
        |> Map.put(:budget_setting_id, budget_setting.id)

      assert index_live
             |> form("#transaction-form", transaction: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/transactions")

      html = render(index_live)
      assert html =~ "Transaction updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes transaction in listing", %{conn: conn, transaction: transaction} do
      {:ok, index_live, _html} = live(conn, ~p"/transactions")

      assert index_live
             |> element("#transactions-#{transaction.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#transactions-#{transaction.id}")
    end
  end

  describe "Show" do
    setup [:create_transaction]

    test "displays transaction", %{conn: conn, transaction: transaction} do
      {:ok, _show_live, html} = live(conn, ~p"/transactions/#{transaction}")

      assert html =~ "Show Transaction"
      assert html =~ transaction.description
    end

    test "updates transaction within modal", %{conn: conn, transaction: transaction, user: user} do
      budget_setting = budget_setting_fixture(%{user_id: user.id})
      {:ok, show_live, _html} = live(conn, ~p"/transactions/#{transaction}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Transaction"

      assert_patch(show_live, ~p"/transactions/#{transaction}/show/edit")

      assert show_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      attrs =
        @update_attrs
        |> Map.put(:user_id, user.id)
        |> Map.put(:budget_setting_id, budget_setting.id)

      assert show_live
             |> form("#transaction-form", transaction: attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/transactions/#{transaction}")

      html = render(show_live)
      assert html =~ "Transaction updated successfully"
      assert html =~ "some updated description"
    end
  end
end
