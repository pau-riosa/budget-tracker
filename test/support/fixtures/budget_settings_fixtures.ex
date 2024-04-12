defmodule BudgetTracker.BudgetSettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.BudgetSettings` context.
  """

  @doc """
  Generate a budget_setting.
  """
  import BudgetTracker.AccountsFixtures

  def budget_setting_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, budget_setting} =
      attrs
      |> Enum.into(%{
        category: :incomes,
        name: "some name",
        planned_amount: Money.new(120),
        user_id: user.id
      })
      |> BudgetTracker.BudgetSettings.create_budget_setting()

    budget_setting
  end
end
