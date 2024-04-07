defmodule BudgetTracker.IncomesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.Incomes` context.
  """

  @doc """
  Generate a income.
  """
  import BudgetTracker.AccountsFixtures

  def income_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, income} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        amount: 120.5,
        income_source: "some income_source"
      })
      |> BudgetTracker.Incomes.create_income()

    income
  end
end
