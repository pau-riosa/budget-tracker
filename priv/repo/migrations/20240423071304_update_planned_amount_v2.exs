defmodule BudgetTracker.Repo.Migrations.UpdatePlannedAmountV2 do
  use Ecto.Migration
  alias BudgetTracker.BudgetSettings

  def change do
    BudgetSettings.transfer_amount_v1_to_amount_v2()
  end
end
