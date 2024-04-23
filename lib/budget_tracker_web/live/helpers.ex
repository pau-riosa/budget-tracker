defmodule BudgetTrackerWeb.Live.Helpers do
  @moduledoc """
  Functions and LiveView helpers for the application.
  """

  @spec map_to_atom_keys(map) :: map
  def map_to_atom_keys(map) do
    map
    |> Enum.map(fn {key, value} ->
      if is_atom(key) do
        {key, value}
      else
        {String.to_atom(key), value}
      end
    end)
    |> Enum.into(%{})
  end

  @spec format_month_year(DateTime.t()) :: String.t()
  def format_month_year(datetime), do: Calendar.strftime(datetime, "%B %Y")

  @spec format_datetime(DateTime.t()) :: String.t()
  def format_datetime(datetime), do: Calendar.strftime(datetime, "%B %d %Y")
end
