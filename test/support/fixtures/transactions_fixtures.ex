defmodule BudgetTracker.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 42,
        amount_v2: 42,
        date: ~U[2024-04-11 23:04:00Z],
        description: "some description"
      })
      |> BudgetTracker.Transactions.create_transaction()

    transaction
  end
end
