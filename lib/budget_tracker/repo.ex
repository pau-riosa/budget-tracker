defmodule BudgetTracker.Repo do
  use Ecto.Repo,
    otp_app: :budget_tracker,
    adapter: Ecto.Adapters.Postgres
end
