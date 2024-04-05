defmodule BudgetTracker.DebtsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.Debts` context.
  """

  @doc """
  Generate a debt.
  """
  import BudgetTracker.AccountsFixtures

  def debt_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, debt} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        debt_type: "some debt_type",
        monthly_payment_amount: 120.5,
        total_amount: 120.5
      })
      |> BudgetTracker.Debts.create_debt()

    debt
  end
end
