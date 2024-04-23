defmodule BudgetTracker.Repo.Migrations.AddAmountV2ToTrasactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :amount_v2, :money_with_currency
    end
  end
end
