defmodule BudgetTrackerWeb.PageControllerTest do
  use BudgetTrackerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Pennywise"
  end
end
