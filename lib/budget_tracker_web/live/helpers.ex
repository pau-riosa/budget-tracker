defmodule BudgetTrackerWeb.Live.Helpers do
  @moduledoc """
  Functions and LiveView helpers for the application.
  """

  @spec format_month_year(DateTime.t()) :: String.t()
  def format_month_year(datetime), do: Calendar.strftime(datetime, "%B %Y")

  @spec format_datetime(DateTime.t()) :: String.t()
  def format_datetime(datetime), do: Calendar.strftime(datetime, "%B %d %Y")
end
