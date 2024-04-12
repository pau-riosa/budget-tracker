defmodule BudgetTrackerWeb.BudgetSettingLive.Show do
  use BudgetTrackerWeb, :live_view

  alias BudgetTracker.BudgetSettings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:budget_setting, BudgetSettings.get_budget_setting!(id))}
  end

  defp page_title(:show), do: "Show Budget setting"
  defp page_title(:edit), do: "Edit Budget setting"
end
