defmodule BudgetTrackerWeb.Components.Footer do
  @moduledoc false
  use BudgetTrackerWeb, :html

  @spec footer(map()) :: Phoenix.LiveView.Rendered.t()
  def footer(assigns) do
    ~H"""
    <div class="mx-auto mt-8 sm:mt-32 max-w-7xl sm:px-3 lg:px-5">
      <footer
        aria-labelledby="footer-heading"
        class="relative border-t border-gray-900/10 py-24 sm:py-32"
      >
        <div class="xl:grid xl:grid-cols-3 xl:gap-8">
          <div class="space-y-4">
            <p class="h-8 inline-block align-bottom text-gray-400 text-md">
              © 2023 HoopsProfile All rights reserved.
            </p>
          </div>
          <div class="mt-16 grid grid-cols-2 gap-8 xl:col-span-2 xl:mt-0">
            <div class="md:grid md:grid-cols-2 md:gap-8">
              <div>
                <h3 class="text-sm font-semibold leading-6 text-gray-900">
                  For Coaches &amp; Scouts
                </h3>
                <ul role="list" class="mt-6 space-y-4">
                  <li>
                    <.link
                      navigate="/players"
                      class="text-sm leading-6 text-gray-400 hover:text-gray-500"
                    >
                      Player Profiles
                    </.link>
                  </li>
                </ul>
              </div>

              <div>
                <h3 class="text-sm font-semibold leading-6 text-gray-900">For Players</h3>
                <ul role="list" class="mt-6 space-y-4">
                  <li>
                    <.link
                      navigate="/players"
                      class="text-sm leading-6 text-gray-400 hover:text-gray-500"
                    >
                      Want to bring your A game?
                    </.link>
                  </li>
                </ul>
              </div>
            </div>
            <div class="md:grid md:grid-cols-2 md:gap-8">
              <div>
                <h3 class="text-sm font-semibold leading-6 text-gray-900">Company</h3>
                <ul role="list" class="mt-6 space-y-4">
                  <li>
                    <.link
                      navigate="/about"
                      class="text-sm leading-6 text-gray-400 hover:text-gray-500"
                    >
                      About
                    </.link>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </footer>
    </div>
    """
  end
end
