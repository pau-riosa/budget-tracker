defmodule BudgetTrackerWeb.InvestmentLiveTest do
  use BudgetTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import BudgetTracker.InvestmentsFixtures

  @create_attrs %{type: :investment, account_type: "some account_type", amount: 120.5}
  @update_attrs %{type: :savings, account_type: "some updated account_type", amount: 456.7}
  @invalid_attrs %{type: nil, account_type: nil, amount: nil}

  setup [:register_and_log_in_user]

  defp create_investment(_) do
    investment = investment_fixture()
    %{investment: investment}
  end

  describe "Index" do
    setup [:create_investment]

    test "lists all investments", %{conn: conn, investment: investment} do
      {:ok, _index_live, html} = live(conn, ~p"/investments")

      assert html =~ "Listing Investments"
      assert html =~ investment.account_type
    end

    test "saves new investment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/investments")

      assert index_live |> element("a", "New Investment") |> render_click() =~
               "New Investment"

      assert_patch(index_live, ~p"/investments/new")

      assert index_live
             |> form("#investment-form", investment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#investment-form", investment: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/investments")

      html = render(index_live)
      assert html =~ "Investment created successfully"
      assert html =~ "some account_type"
    end

    test "updates investment in listing", %{conn: conn, investment: investment} do
      {:ok, index_live, _html} = live(conn, ~p"/investments")

      assert index_live |> element("#investments-#{investment.id} a", "Edit") |> render_click() =~
               "Edit Investment"

      assert_patch(index_live, ~p"/investments/#{investment}/edit")

      assert index_live
             |> form("#investment-form", investment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#investment-form", investment: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/investments")

      html = render(index_live)
      assert html =~ "Investment updated successfully"
      assert html =~ "some updated account_type"
    end

    test "deletes investment in listing", %{conn: conn, investment: investment} do
      {:ok, index_live, _html} = live(conn, ~p"/investments")

      assert index_live |> element("#investments-#{investment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#investments-#{investment.id}")
    end
  end

  describe "Show" do
    setup [:create_investment]

    test "displays investment", %{conn: conn, investment: investment} do
      {:ok, _show_live, html} = live(conn, ~p"/investments/#{investment}")

      assert html =~ "Show Investment"
      assert html =~ investment.account_type
    end

    test "updates investment within modal", %{conn: conn, investment: investment} do
      {:ok, show_live, _html} = live(conn, ~p"/investments/#{investment}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Investment"

      assert_patch(show_live, ~p"/investments/#{investment}/show/edit")

      assert show_live
             |> form("#investment-form", investment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#investment-form", investment: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/investments/#{investment}")

      html = render(show_live)
      assert html =~ "Investment updated successfully"
      assert html =~ "some updated account_type"
    end
  end
end
