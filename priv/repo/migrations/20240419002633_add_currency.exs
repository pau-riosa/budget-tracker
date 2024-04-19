defmodule BudgetTracker.Repo.Migrations.AddCurrency do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :currency, :string
    end
  end
end
