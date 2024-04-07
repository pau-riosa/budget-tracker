defmodule BudgetTracker.Repo.Migrations.CreateIncomes do
  use Ecto.Migration

  def change do
    create table(:incomes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :income_source, :string
      add :amount, :float
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:incomes, [:user_id])
  end
end
