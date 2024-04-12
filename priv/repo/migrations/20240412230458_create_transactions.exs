defmodule BudgetTracker.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :utc_datetime
      add :amount, :integer
      add :description, :text
      add :category_id, references(:budget_settings, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:category_id])
    create index(:transactions, [:user_id])
  end
end
