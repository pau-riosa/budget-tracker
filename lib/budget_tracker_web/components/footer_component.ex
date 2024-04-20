defmodule BudgetTrackerWeb.Components.Footer do
  @moduledoc false
  use BudgetTrackerWeb, :html

  @spec footer(map()) :: Phoenix.LiveView.Rendered.t()
  def footer(assigns) do
    ~H"""
    <div class="mx-auto mt-8 sm:mt-32 max-w-7xl px-10 lg:px-5">
      <footer
        aria-labelledby="footer-heading"
        class="relative border-t border-gray-900/10 py-24 sm:py-32"
      >
        <div class="xl:grid xl:grid-cols-3 xl:gap-8">
          <div class="space-y-4">
            <p class="h-8 inline-block align-bottom text-gray-400 text-md">
              © 2024 PennyWise: Budget Tracker All rights reserved.
            </p>
          </div>
          <div class="mt-16 grid grid-cols-2 gap-8 xl:col-span-2 xl:mt-0">
            <div class="md:grid md:grid-cols-2 md:gap-8">
              <div>
                <h3 class="text-sm font-semibold leading-6 text-gray-900">Credits</h3>
                <ul role="list" class="mt-6 space-y-4">
                  <li>
                    <a
                      href="https://unsplash.com/@alexandermils?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash"
                      class="text-sm leading-6 text-gray-400 hover:text-gray-500"
                    >
                      Photo by Alexander Mills on
                    </a>
                    <a
                      href="https://unsplash.com/photos/fan-of-100-us-dollar-banknotes-lCPhGxs7pww?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash"
                      class="text-sm leading-6 text-gray-400 hover:text-gray-500"
                    >
                      Unsplash
                    </a>
                  </li>
                  <li>
                    <a
                      href="https://unsplash.com/@micheile?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash"
                      class="text-sm leading-6 text-gray-400 hover:text-gray-500"
                    >
                      Micheile Henderson
                    </a>
                    <a
                      href="https://unsplash.com/photos/green-plant-in-clear-glass-vase-ZVprbBmT8QA?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash"
                      class="text-sm leading-6 text-gray-400 hover:text-gray-500"
                    >
                      Photo by Unsplash
                    </a>
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
