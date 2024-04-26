defmodule BudgetTrackerWeb.BudgetSettingLiveTest do
  use BudgetTrackerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import BudgetTracker.BudgetSettingsFixtures

  @create_attrs %{name: "some name", category: :incomes, planned_amount_v2: 120.5}
  @update_attrs %{name: "some updated name", category: :expenses, planned_amount_v2: 456.7}
  @invalid_attrs %{name: nil, category: nil, planned_amount_v2: nil}

  setup [:register_and_log_in_user]

  defp create_budget_setting(%{user: user}) do
    budget_setting = budget_setting_fixture(%{user_id: user.id})
    %{budget_setting: budget_setting}
  end

  describe "Index" do
    setup [:create_budget_setting]

    test "show total budget planned", %{conn: conn, user: user} do
      %{planned_amount: planned_amount} =
        budget_setting_fixture(%{user_id: user.id, planned_amount: Money.new(12000)})

      {:ok, _index_live, html} = live(conn, ~p"/budget_settings")

      assert html =~ "Total Budget Planned"
      assert html =~ to_string(planned_amount)
    end

    test "lists all budget_settings", %{conn: conn, budget_setting: budget_setting} do
      {:ok, _index_live, html} = live(conn, ~p"/budget_settings")

      assert html =~ "Listing Budget settings"
      assert html =~ budget_setting.name
    end

    test "saves new budget_setting", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/budget_settings")

      assert index_live |> element("a", "New Budget setting") |> render_click() =~
               "New Budget setting"

      assert_patch(index_live, ~p"/budget_settings/new")

      assert index_live
             |> form("#budget_setting-form", budget_setting: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#budget_setting-form", budget_setting: @create_attrs)
             |> render_submit(%{user_id: user.id})

      assert_patch(index_live, ~p"/budget_settings")

      html = render(index_live)
      assert html =~ "Budget setting created successfully"
      assert html =~ "some name"
    end

    test "updates budget_setting in listing", %{conn: conn, budget_setting: budget_setting} do
      {:ok, index_live, _html} = live(conn, ~p"/budget_settings")

      assert index_live
             |> element("#budget_settings-#{budget_setting.id} a", "Edit")
             |> render_click() =~
               "Edit Budget setting"

      assert_patch(index_live, ~p"/budget_settings/#{budget_setting}/edit")

      assert index_live
             |> form("#budget_setting-form", budget_setting: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#budget_setting-form", budget_setting: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/budget_settings")

      html = render(index_live)
      assert html =~ "Budget setting updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes budget_setting in listing", %{conn: conn, budget_setting: budget_setting} do
      {:ok, index_live, _html} = live(conn, ~p"/budget_settings")

      assert index_live
             |> element("#budget_settings-#{budget_setting.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#budget_settings-#{budget_setting.id}")
    end
  end

  describe "Show" do
    setup [:create_budget_setting]

    test "displays budget_setting", %{conn: conn, budget_setting: budget_setting} do
      {:ok, _show_live, html} = live(conn, ~p"/budget_settings/#{budget_setting}")

      assert html =~ "Show Budget setting"
      assert html =~ budget_setting.name
    end

    test "updates budget_setting within modal", %{conn: conn, budget_setting: budget_setting} do
      {:ok, show_live, _html} = live(conn, ~p"/budget_settings/#{budget_setting}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Budget setting"

      assert_patch(show_live, ~p"/budget_settings/#{budget_setting}/show/edit")

      assert show_live
             |> form("#budget_setting-form", budget_setting: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#budget_setting-form", budget_setting: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/budget_settings/#{budget_setting}")

      html = render(show_live)
      assert html =~ "Budget setting updated successfully"
      assert html =~ "some updated name"
    end
  end
end
