defmodule BudgetTracker.Repo.Migrations.CreatePlannedAmountMoneyCurrencyType do
  use Ecto.Migration

  def change do
    execute "CREATE TYPE public.money_with_currency AS (amount numeric, currency varchar(3))"

    alter table(:budget_settings) do
      add :planned_amount_v2, :money_with_currency
    end
  end
end
