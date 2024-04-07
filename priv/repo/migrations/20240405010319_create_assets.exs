defmodule BudgetTracker.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :total_market_value, :float
      add :asset_name, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:assets, [:user_id])
  end
end
