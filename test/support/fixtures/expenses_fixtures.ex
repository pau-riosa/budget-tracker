defmodule BudgetTracker.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.Expenses` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        expense_source: "some expense_source",
        type: :variable
      })
      |> BudgetTracker.Expenses.create_expense()

    expense
  end
end
