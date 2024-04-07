defmodule BudgetTracker.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :utc_datetime_usec
      add :description, :string
      add :category, :string
      add :money_in_or_out, :boolean, default: false, null: false
      add :amount, :float

      add :income_id, references(:incomes, on_delete: :delete_all, type: :binary_id)
      add :expense_id, references(:expenses, on_delete: :delete_all, type: :binary_id)
      add :asset_id, references(:assets, on_delete: :delete_all, type: :binary_id)
      add :investment_id, references(:investments, on_delete: :delete_all, type: :binary_id)
      add :debt_id, references(:debts, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create constraint(:transactions, :check_exclusive, check: "(
      (income_id IS NOT NULL)::integer +
      (expense_id IS NOT NULL)::integer +
      (asset_id IS NOT NULL)::integer +
      (investment_id IS NOT NULL)::integer +
      (debt_id IS NOT NULL)::integer
    ) = 1")

    create index(:transactions, [:income_id], where: "income_id IS NOT NULL")
    create index(:transactions, [:expense_id], where: "expense_id IS NOT NULL")
    create index(:transactions, [:asset_id], where: "asset_id IS NOT NULL")
    create index(:transactions, [:investment_id], where: "investment_id IS NOT NULL")
    create index(:transactions, [:debt_id], where: "debt_id IS NOT NULL")
  end
end
