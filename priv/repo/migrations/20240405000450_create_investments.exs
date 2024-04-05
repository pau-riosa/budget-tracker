defmodule BudgetTracker.Repo.Migrations.CreateInvestments do
  use Ecto.Migration

  def change do
    create table(:investments, primary_key: false) do
      add :id, :binary, primary_key: true
      add :account_type, :string
      add :amount, :float
      add :type, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:investments, [:user_id])
  end
end
