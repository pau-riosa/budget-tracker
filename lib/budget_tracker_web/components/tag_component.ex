defmodule BudgetTrackerWeb.Components.Tag do
  @moduledoc false
  use BudgetTrackerWeb, :html

  attr(:color, :string, default: "#000000")
  slot :inner_block
  @spec tag(map()) :: Phoenix.LiveView.Rendered.t()
  def tag(assigns) do
    ~H"""
    <span class="px-2 py-2 rounded-md text-white font-semibold" style={"background-color: #{@color};"}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end
