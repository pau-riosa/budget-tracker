defmodule BudgetTracker.Repo.Migrations.AddExpenseTypeToBudgetSettings do
  use Ecto.Migration

  def change do
    alter table(:budget_settings) do
      add :type, :string, default: "planned"
    end
  end
end
