defmodule BudgetTracker.Repo.Migrations.CreateDebts do
  use Ecto.Migration

  def change do
    create table(:debts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :debt_type, :string
      add :total_amount, :float
      add :monthly_payment_amount, :float
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:debts, [:user_id])
  end
end
