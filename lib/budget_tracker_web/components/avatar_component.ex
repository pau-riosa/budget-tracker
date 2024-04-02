defmodule BudgetTrackerWeb.Components.Avatar do
  @moduledoc false
  use BudgetTrackerWeb, :html
  alias BudgetTracker.Accounts
  alias BudgetTracker.Accounts.User

  attr(:user, User, required: true)
  attr(:rest, :global)
  @spec avatar(map()) :: Phoenix.LiveView.Rendered.t()
  def avatar(assigns) do
    ~H"""
    <div
      class="hidden sm:ml-6 sm:flex sm:items-center sm:justify-center w-12 h-12 rounded-full bg-brand/60 text-white"
      {@rest}
    >
      <%= Accounts.get_user_initials(@user) %>
    </div>
    """
  end
end
