defmodule BudgetTrackerWeb.BudgetSettingLive.Index do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.BudgetSettings
  alias BudgetTracker.BudgetSettings.BudgetSetting
  alias BudgetTracker.Repo

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    {:ok,
     stream(socket, :budget_settings, BudgetSettings.list_budget_settings_of_user(current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Budget setting")
    |> assign(:budget_setting, BudgetSettings.get_budget_setting!(id))
    |> assign(:total_budget, BudgetSettings.total_budget_of_user(socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Budget setting")
    |> assign(:budget_setting, %BudgetSetting{})
    |> assign(:total_budget, BudgetSettings.total_budget_of_user(socket.assigns.current_user))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Budget settings")
    |> assign(:budget_setting, nil)
    |> assign(:total_budget, BudgetSettings.total_budget_of_user(socket.assigns.current_user))
  end

  @impl true
  def handle_info(
        {BudgetTrackerWeb.BudgetSettingLive.FormComponent, {:saved, budget_setting}},
        socket
      ) do
    {:noreply,
     stream_insert(socket, :budget_settings, Repo.preload(budget_setting, :transactions), at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    budget_setting = BudgetSettings.get_budget_setting!(id)
    {:ok, _} = BudgetSettings.delete_budget_setting(budget_setting)

    {:noreply, stream_delete(socket, :budget_settings, budget_setting)}
  end

  defp transform_diff_amount(nil), do: Money.new(0)

  defp transform_diff_amount({amount, currency}) do
    amount
    |> Decimal.to_string()
    |> String.to_integer()
    |> Money.new(currency)
  end
end
