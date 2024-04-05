defmodule BudgetTracker.InvestmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.Investments` context.
  """

  @doc """
  Generate a investment.
  """
  import BudgetTracker.AccountsFixtures

  def investment_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, investment} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        account_type: "some account_type",
        amount: 120.5,
        type: :investment
      })
      |> BudgetTracker.Investments.create_investment()

    investment
  end
end
