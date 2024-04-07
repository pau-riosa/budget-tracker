defmodule BudgetTrackerWeb.Components.Navigation do
  @moduledoc false
  use BudgetTrackerWeb, :html
  alias BudgetTracker.Accounts.User

  attr(:active_page, :atom)
  attr(:current_user, User)
  @spec navigation(map()) :: Phoenix.LiveView.Rendered.t()
  def navigation(assigns) do
    ~H"""
    <div class="sticky top-0 z-40">
      <nav class="bg-white shadow z-30 relative px-0 lg:px-5">
        <div class="mx-auto max-w-7xl px-3 lg:px-0 py-0 lg:py-1">
          <div class="flex h-16 justify-between">
            <div class="flex">
              <div :if={@current_user} class="hidden sm:ml-6 sm:flex sm:space-x-8">
                <.desktop_active_link
                  path={~p"/dashboard"}
                  text="Dashboard"
                  active_page={@active_page}
                  page={:dashboard}
                />
                <.desktop_active_link
                  path={~p"/incomes"}
                  text="Incomes"
                  active_page={@active_page}
                  page={:income}
                />
                <.desktop_active_link
                  path={~p"/expenses"}
                  text="Expenses"
                  active_page={@active_page}
                  page={:expense}
                />
                <.desktop_active_link
                  path={~p"/investments"}
                  text="Investments"
                  active_page={@active_page}
                  page={:investment}
                />
                <.desktop_active_link
                  path={~p"/debts"}
                  text="Debts"
                  active_page={@active_page}
                  page={:debt}
                />
                <.desktop_active_link
                  path={~p"/assets"}
                  text="Assets"
                  active_page={@active_page}
                  page={:asset}
                />
                <.desktop_active_link
                  path={~p"/transactions"}
                  text="Transactions"
                  active_page={@active_page}
                  page={:transaction}
                />
              </div>
            </div>
            <!-- desktop user menu / register and login -->
            <div
              :if={is_nil(@current_user)}
              class="hidden sm:flex sm:items-center sm:justify-between sm:gap-x-3"
            >
              <.link
                href={~p"/users/log_in"}
                class="text-[0.8125rem] border border-gray-200 px-3 py-1 rounded-md leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Log in
              </.link>
              <.link
                href={~p"/users/register"}
                class="text-[0.8125rem] border border-brand bg-brand px-3 py-1 rounded-md leading-6 text-white font-semibold hover:bg-blue-700/80 hover:border-transparent"
              >
                Register
              </.link>
            </div>
            <div :if={@current_user} class="relative">
              <div class="mt-2">
                <.avatar
                  user={@current_user}
                  phx-click={
                    JS.toggle(
                      to: "#user-menu",
                      in: {"ease-out duration-300", "opacity-0", "opacity-100"},
                      out: {"ease-out duration-300", "opacity-100", "opacity-0"},
                      time: 300
                    )
                  }
                />
              </div>
              <div
                phx-click-away={JS.hide(to: "#user-menu")}
                id="user-menu"
                class="absolute right-0 z-10 mt-7 w-fit min-w-[200px] whitespace-nowrap origin-top-right rounded-md bg-white divide-y divide-gray-100 py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none hidden"
              >
                <ul class="mx-auto space-y-1 px-3 ">
                  <li class="text-[0.8125rem] leading-6 text-zinc-900">
                    <%= @current_user.email %>
                  </li>
                  <li>
                    <.link
                      href={~p"/dashboard"}
                      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                    >
                      Dashboard
                    </.link>
                  </li>
                  <li>
                    <.link
                      href={~p"/users/settings"}
                      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                    >
                      Settings
                    </.link>
                  </li>
                  <li>
                    <.link
                      href={~p"/users/log_out"}
                      method="delete"
                      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                    >
                      Log out
                    </.link>
                  </li>
                </ul>
              </div>
            </div>
            <!-- mobile user menu / register and login -->
            <div class="-mr-2 flex items-center sm:hidden">
              <button
                type="button"
                class="inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500 ml-2"
                aria-controls="mobile-menu"
                aria-expanded="false"
              >
                <span class="sr-only">Open main menu</span>
                <.icon
                  name="hero-bars-3-solid"
                  class="block h-6 w-6 mobile-menu"
                  phx-click={
                    JS.toggle(to: ".mobile-menu")
                    |> JS.remove_class("hidden",
                      to: "#mobile-menu"
                    )
                  }
                />
                <.icon
                  name="hero-x-mark-solid"
                  class="hidden h-6 w-6 mobile-menu"
                  phx-click={
                    JS.toggle(to: ".mobile-menu")
                    |> JS.add_class("hidden",
                      to: "#mobile-menu"
                    )
                  }
                />
              </button>
            </div>
          </div>
        </div>
        <!-- mobile user menu / register and login -->
        <div
          class="sm:hidden hidden absolute z-50 bg-white border border-b-2 border-gray-200 w-full"
          id="mobile-menu"
        >
          <div class="border-t border-gray-200 pb-3 pt-4 divide-y-2 divide-gray-100 space-y-3">
            <div class="px-2 space-y-1">
              <div class="flex flex-col space-y-3">
                <.mobile_active_link
                  path={~p"/dashboard"}
                  text="Dashboard"
                  active_page={@active_page}
                  page={:dashboard}
                />
                <.mobile_active_link
                  path={~p"/incomes"}
                  text="Incomes"
                  active_page={@active_page}
                  page={:income}
                />
                <.mobile_active_link
                  path={~p"/expenses"}
                  text="Expenses"
                  active_page={@active_page}
                  page={:expense}
                />
                <.mobile_active_link
                  path={~p"/investments"}
                  text="Investments"
                  active_page={@active_page}
                  page={:investment}
                />
                <.mobile_active_link
                  path={~p"/debts"}
                  text="Debts"
                  active_page={@active_page}
                  page={:debt}
                />
                <.mobile_active_link
                  path={~p"/assets"}
                  text="Assets"
                  active_page={@active_page}
                  page={:asset}
                />
              </div>
            </div>
            <ul :if={@current_user} class="mx-auto space-y-1 px-3">
              <li class="text-[0.8125rem] leading-6 text-zinc-900">
                <%= @current_user.email %>
              </li>
              <li>
                <.link
                  href={~p"/users/settings"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Settings
                </.link>
              </li>
              <li>
                <.link
                  href={~p"/users/log_out"}
                  method="delete"
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Log out
                </.link>
              </li>
            </ul>
            <ul :if={is_nil(@current_user)} class="mx-auto-spacey-1 px-3">
              <li>
                <.link
                  href={~p"/users/register"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Register
                </.link>
              </li>
              <li>
                <.link
                  href={~p"/users/log_in"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Log in
                </.link>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
    """
  end

  attr(:path, :string)
  attr(:text, :string)
  attr(:page, :atom)
  attr(:active_page, :atom)
  @spec desktop_active_link(map()) :: Phoenix.LiveView.Rendered.t()
  def desktop_active_link(assigns) do
    ~H"""
    <.link
      navigate={@path}
      class={"inline-flex items-center  px-1 pt-1 text-sm font-medium #{if @active_page == @page, do: "border-b-2 border-indigo-500 text-gray-900", else: "text-gray-500 hover:border-b-2 hover:border-gray-300"}"}
    >
      <%= @text %>
    </.link>
    """
  end

  attr(:path, :string)
  attr(:text, :string)
  attr(:page, :atom)
  attr(:active_page, :atom)
  @spec mobile_active_link(map()) :: Phoenix.LiveView.Rendered.t()
  def mobile_active_link(assigns) do
    ~H"""
    <.link
      navigate={@path}
      class={"inline-flex items-center  px-3 py-2 text-sm font-medium #{if @active_page == @page, do: "border-l-2 border-brand text-brand bg-indigo-100 w-full", else: "text-gray-500"}"}
    >
      <%= @text %>
    </.link>
    """
  end
end
