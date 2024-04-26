defmodule BudgetTracker.Repo.Migrations.TransferAmountV1ToAmountV2 do
  use Ecto.Migration

  alias BudgetTracker.{BudgetSettings, Transactions}

  def change do
    Transactions.transfer_amount_v1_to_amount_v2()
    BudgetSettings.transfer_amount_v1_to_amount_v2()
  end
end
