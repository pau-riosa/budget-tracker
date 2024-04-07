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

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        category: :incomes,
        date: ~U[2024-04-06 13:45:00.000000Z],
        description: "some description",
        money_in_or_out: true
      })
      |> BudgetTracker.Transactions.create_transaction()

    transaction
  end
end
