defmodule BudgetTrackerWeb.DashboardLive do
  use BudgetTrackerWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 mt-3">
      <div class="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-4">
        <.link patch={~p"/income"}>
          <div class="overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200 ring-4">
            <div class="px-4 py-5 sm:p-6">
              <dt class="text-sm font-medium leading-6 text-gray-500">
                Total Income
              </dt>
              <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900">
                0
              </dd>
            </div>
          </div>
        </.link>
        <.link patch={~p"/expenses"}>
          <div class="overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200">
            <div class="px-4 py-5 sm:p-6">
              <dt class="text-sm font-medium leading-6 text-gray-500">
                Total Expenses
              </dt>
              <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900">
                0
              </dd>
            </div>
          </div>
        </.link>
        <.link patch={~p"/debts"}>
          <div class="overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200">
            <div class="px-4 py-5 sm:p-6">
              <dt class="text-sm font-medium leading-6 text-gray-500">
                Total Debts
              </dt>
              <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900">
                0
              </dd>
            </div>
          </div>
        </.link>
        <.link patch={~p"/investments"}>
          <div class="overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200">
            <div class="px-4 py-5 sm:p-6">
              <dt class="text-sm font-medium leading-6 text-gray-500">
                Total Investments
              </dt>
              <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900">
                0
              </dd>
            </div>
          </div>
        </.link>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    {:noreply, socket}
  end
end
