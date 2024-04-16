defmodule BudgetTracker.Repo.Migrations.CreateColorPickerForCategory do
  use Ecto.Migration

  def change do
    alter table(:budget_settings) do
      add :color, :string, default: "#000000"
    end
  end
end
