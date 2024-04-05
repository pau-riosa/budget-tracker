defmodule BudgetTracker.Debts do
  @moduledoc """
  The Debts context.
  """

  import Ecto.Query, warn: false
  alias BudgetTracker.Repo

  alias BudgetTracker.Debts.Debt

  @doc """
  Returns the list of debts.

  ## Examples

      iex> list_debts()
      [%Debt{}, ...]

  """
  def list_debts do
    Repo.all(Debt)
  end

  @doc """
  Gets a single debt.

  Raises `Ecto.NoResultsError` if the Debt does not exist.

  ## Examples

      iex> get_debt!(123)
      %Debt{}

      iex> get_debt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_debt!(id), do: Repo.get!(Debt, id)

  @doc """
  Creates a debt.

  ## Examples

      iex> create_debt(%{field: value})
      {:ok, %Debt{}}

      iex> create_debt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_debt(attrs \\ %{}) do
    %Debt{}
    |> Debt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a debt.

  ## Examples

      iex> update_debt(debt, %{field: new_value})
      {:ok, %Debt{}}

      iex> update_debt(debt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_debt(%Debt{} = debt, attrs) do
    debt
    |> Debt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a debt.

  ## Examples

      iex> delete_debt(debt)
      {:ok, %Debt{}}

      iex> delete_debt(debt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_debt(%Debt{} = debt) do
    Repo.delete(debt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking debt changes.

  ## Examples

      iex> change_debt(debt)
      %Ecto.Changeset{data: %Debt{}}

  """
  def change_debt(%Debt{} = debt, attrs \\ %{}) do
    Debt.changeset(debt, attrs)
  end
end
