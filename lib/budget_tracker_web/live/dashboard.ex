defmodule BudgetTrackerWeb.DashboardLive do
  use BudgetTrackerWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 mt-3">
      <div class="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-5">
        <div class="lg:col-start-1 lg:row-end-1">
          <div class="overflow-hidden rounded-lg bg-white ring-1 ring-inset ring-gray-200 ">
            <div class="px-4 py-5 sm:p-6">
              <.link class="flex items-center mb-6">
                <img
                  class="h-14 w-14 rounded-lg ring-4 ring-white mr-3 flex-none"
                  src="https://images.unsplash.com/photo-1522027353578-d23a7be6d503?auto=format&fit=crop&q=80&w=2225&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                />
                <div class="font-bold">John Doe</div>
              </.link>
              <div class="md:row-span-2 divide-y divide-gray-200 text-sm font-medium">
                <div class="pb-4">
                  <span class="text-blue-600">
                    <.icon name="hero-check-circle-solid" class="-mt-1 mr-1 inline-block" />
                    Open to offers
                  </span>
                </div>
                <div class="py-4 space-y-2">
                  <p>
                    <.icon name="hero-home" class="-mt-1 mr-1" /> Hong Kong
                  </p>
                  <p>
                    <.icon name="hero-globe-europe-africa" class="-mt-1 mr-1" />
                    Prefer Local, Overseas
                  </p>
                </div>
                <div class="py-4"></div>
              </div>
              <div class="pt-4 space-y-2">
                <.link
                  navigate={~p"/incomes"}
                  class="inline-flex items-center focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 border text-center rounded-md px-3 py-2 text-sm font-medium leading-4 border-transparent bg-indigo-600 text-white shadow-sm hover:bg-indigo-700 w-full justify-center"
                >
                  Income
                </.link>
                <.link
                  navigate={~p"/expenses"}
                  class="inline-flex items-center focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 border text-center rounded-md px-3 py-2 text-sm font-medium leading-4 border-gray-300 bg-white text-gray-700 shadow-sm hover:bg-gray-50 w-full justify-center"
                >
                  Expenses
                </.link>
                <.link
                  navigate={~p"/investments"}
                  class="inline-flex items-center focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 border text-center rounded-md px-3 py-2 text-sm font-medium leading-4 border-gray-300 bg-white text-gray-700 shadow-sm hover:bg-gray-50 w-full justify-center"
                >
                  Investments
                </.link>
                <.link
                  navigate={~p"/debts"}
                  class="inline-flex items-center focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 border text-center rounded-md px-3 py-2 text-sm font-medium leading-4 border-gray-300 bg-white text-gray-700 shadow-sm hover:bg-gray-50 w-full justify-center"
                >
                  Debts
                </.link>
              </div>
            </div>
          </div>
        </div>

        <div class="lg:col-span-4 lg:row-span-2 lg:row-end-2">
          <div class="grid gap-x-6 gap-y-4 grid-cols-1 md:grid-cols-4">
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
