defmodule BudgetTrackerWeb.IncomeLiveTest do
  use BudgetTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import BudgetTracker.AccountsFixtures
  import BudgetTracker.IncomesFixtures

  @create_attrs %{income_source: "some income_source", amount: 120.5}
  @update_attrs %{income_source: "some updated income_source", amount: 456.7}
  @invalid_attrs %{income_source: nil, amount: nil}

  setup [:register_and_log_in_user]

  defp create_income(_) do
    income = income_fixture()
    %{income: income}
  end

  describe "Index" do
    setup [:create_income]

    test "lists all incomes", %{conn: conn, income: income} do
      {:ok, _index_live, html} = live(conn, ~p"/incomes")

      assert html =~ "Listing Incomes"
      assert html =~ income.income_source
    end

    test "saves new income", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/incomes")

      assert index_live |> element("a", "New Income") |> render_click() =~
               "New Income"

      assert_patch(index_live, ~p"/incomes/new")

      assert index_live
             |> form("#income-form", income: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#income-form", income: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/incomes")

      html = render(index_live)
      assert html =~ "Income created successfully"
      assert html =~ "some income_source"
    end

    test "updates income in listing", %{conn: conn, income: income} do
      {:ok, index_live, _html} = live(conn, ~p"/incomes")

      assert index_live |> element("#incomes-#{income.id} a", "Edit") |> render_click() =~
               "Edit Income"

      assert_patch(index_live, ~p"/incomes/#{income}/edit")

      assert index_live
             |> form("#income-form", income: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#income-form", income: @update_attrs)
             |> render_submit(%{user_id: user_fixture().id})

      assert_patch(index_live, ~p"/incomes")

      html = render(index_live)
      assert html =~ "Income updated successfully"
      assert html =~ "some updated income_source"
    end

    test "deletes income in listing", %{conn: conn, income: income} do
      {:ok, index_live, _html} = live(conn, ~p"/incomes")

      assert index_live |> element("#incomes-#{income.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#incomes-#{income.id}")
    end
  end

  describe "Show" do
    setup [:create_income]

    test "displays income", %{conn: conn, income: income} do
      {:ok, _show_live, html} = live(conn, ~p"/incomes/#{income}")

      assert html =~ "Show Income"
      assert html =~ income.income_source
    end

    test "updates income within modal", %{conn: conn, income: income} do
      {:ok, show_live, _html} = live(conn, ~p"/incomes/#{income}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Income"

      assert_patch(show_live, ~p"/incomes/#{income}/show/edit")

      assert show_live
             |> form("#income-form", income: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#income-form", income: @update_attrs)
             |> render_submit(%{user_id: user_fixture().id})

      assert_patch(show_live, ~p"/incomes/#{income}")

      html = render(show_live)
      assert html =~ "Income updated successfully"
      assert html =~ "some updated income_source"
    end
  end
end
