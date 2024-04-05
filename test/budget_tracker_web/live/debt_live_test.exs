defmodule BudgetTrackerWeb.DebtLiveTest do
  use BudgetTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import BudgetTracker.DebtsFixtures

  @create_attrs %{debt_type: "some debt_type", total_amount: 120.5, monthly_payment_amount: 120.5}
  @update_attrs %{
    debt_type: "some updated debt_type",
    total_amount: 456.7,
    monthly_payment_amount: 456.7
  }
  @invalid_attrs %{debt_type: nil, total_amount: nil, monthly_payment_amount: nil}

  setup [:register_and_log_in_user]

  defp create_debt(_) do
    debt = debt_fixture()
    %{debt: debt}
  end

  describe "Index" do
    setup [:create_debt]

    test "lists all debts", %{conn: conn, debt: debt} do
      {:ok, _index_live, html} = live(conn, ~p"/debts")

      assert html =~ "Listing Debts"
      assert html =~ debt.debt_type
    end

    test "saves new debt", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/debts")

      assert index_live |> element("a", "New Debt") |> render_click() =~
               "New Debt"

      assert_patch(index_live, ~p"/debts/new")

      assert index_live
             |> form("#debt-form", debt: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#debt-form", debt: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/debts")

      html = render(index_live)
      assert html =~ "Debt created successfully"
      assert html =~ "some debt_type"
    end

    test "updates debt in listing", %{conn: conn, debt: debt} do
      {:ok, index_live, _html} = live(conn, ~p"/debts")

      assert index_live |> element("#debts-#{debt.id} a", "Edit") |> render_click() =~
               "Edit Debt"

      assert_patch(index_live, ~p"/debts/#{debt}/edit")

      assert index_live
             |> form("#debt-form", debt: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#debt-form", debt: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/debts")

      html = render(index_live)
      assert html =~ "Debt updated successfully"
      assert html =~ "some updated debt_type"
    end

    test "deletes debt in listing", %{conn: conn, debt: debt} do
      {:ok, index_live, _html} = live(conn, ~p"/debts")

      assert index_live |> element("#debts-#{debt.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#debts-#{debt.id}")
    end
  end

  describe "Show" do
    setup [:create_debt]

    test "displays debt", %{conn: conn, debt: debt} do
      {:ok, _show_live, html} = live(conn, ~p"/debts/#{debt}")

      assert html =~ "Show Debt"
      assert html =~ debt.debt_type
    end

    test "updates debt within modal", %{conn: conn, debt: debt} do
      {:ok, show_live, _html} = live(conn, ~p"/debts/#{debt}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Debt"

      assert_patch(show_live, ~p"/debts/#{debt}/show/edit")

      assert show_live
             |> form("#debt-form", debt: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#debt-form", debt: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/debts/#{debt}")

      html = render(show_live)
      assert html =~ "Debt updated successfully"
      assert html =~ "some updated debt_type"
    end
  end
end
