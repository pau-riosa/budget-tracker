defmodule BudgetTracker.BudgetSettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTracker.BudgetSettings` context.
  """

  @doc """
  Generate a budget_setting.
  """
  def budget_setting_fixture(attrs \\ %{}) do
    {:ok, budget_setting} =
      attrs
      |> Enum.into(%{
        category: :incomes,
        name: "some name",
        planned_amount: Money.new(120)
      })
      |> BudgetTracker.BudgetSettings.create_budget_setting()

    budget_setting
  end
end
