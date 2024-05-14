defmodule BudgetTracker.Repo.Migrations.SetDefaultCurrency3 do
  use Ecto.Migration

  def change do
    execute(
      "update budget_settings set planned_amount_v2.currency = 'PHP' where (planned_amount_v2).currency IS NULL;"
    )

    execute(
      "update transactions set amount_v2.currency = 'PHP' where (amount_v2).currency IS NULL;"
    )
  end
end
