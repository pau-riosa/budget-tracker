defmodule BudgetTrackerWeb.Live.Helpers do
  @moduledoc """
  Functions and LiveView helpers for the application.
  """

  def format_datetime(datetime), do: Calendar.strftime(datetime, "%B %d %Y")
end
