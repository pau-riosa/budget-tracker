defmodule BudgetTracker.Repo.Migrations.CreateBudgetSettings do
  use Ecto.Migration

  def change do
    create table(:budget_settings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :category, :string
      add :name, :string
      add :planned_amount, :integer
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:budget_settings, [:user_id])
  end
end
