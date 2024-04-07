defmodule BudgetTracker.Repo.Migrations.CreateInvestments do
  use Ecto.Migration

  def change do
    create table(:investments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :account_type, :string
      add :amount, :float
      add :type, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:investments, [:user_id])
  end
end
