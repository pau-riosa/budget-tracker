defmodule BudgetTracker.Repo.Migrations.AddDefaultCurrency do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :currency, :string, default: "PHP"
    end
  end
end
