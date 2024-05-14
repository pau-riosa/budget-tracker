defmodule BudgetTracker.Repo.Migrations.SetDefaultCurrency do
  use Ecto.Migration

  import Ecto.Query
  alias BudgetTracker.BudgetSettings.BudgetSetting
  alias BudgetTracker.Repo
  alias BudgetTracker.Transactions.Transaction

  def change do
    BudgetSetting
    |> from(as: :budget_settings)
    |> preload(:user)
    |> Repo.all()
    |> Enum.filter(fn budget_setting -> is_nil(budget_setting.planned_amount_v2.currency) end)
    |> Enum.each(fn budget_setting ->
      Repo.update!(budget_setting, %{
        planned_amount_v2:
          Money.new(
            budget_setting.planned_amount_v2.amount,
            budget_setting.user.currency || "PHP"
          )
      })
    end)

    Transaction
    |> from(as: :transactions)
    |> preload(:user)
    |> Repo.all()
    |> Enum.filter(fn transaction -> is_nil(transaction.amount_v2.currency) end)
    |> Enum.each(fn transaction ->
      Repo.update!(transaction, %{
        amount_v2: Money.new(transaction.amount_v2.amount, transaction.user.currency || "PHP")
      })
    end)
  end
end
