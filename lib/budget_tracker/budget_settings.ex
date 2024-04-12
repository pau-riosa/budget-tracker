defmodule BudgetTracker.BudgetSettings do
  @moduledoc """
  The BudgetSettings context.
  """

  import Ecto.Query, warn: false
  alias BudgetTracker.Repo

  alias BudgetTracker.BudgetSettings.BudgetSetting

  def list_budget_settings_of_user(user) do
    Repo.all(from(b in BudgetSetting, where: b.user_id == ^user.id))
  end

  @doc """
  Returns the list of budget_settings.

  ## Examples

      iex> list_budget_settings()
      [%BudgetSetting{}, ...]

  """
  def list_budget_settings do
    Repo.all(BudgetSetting)
  end

  @doc """
  Gets a single budget_setting.

  Raises `Ecto.NoResultsError` if the Budget setting does not exist.

  ## Examples

      iex> get_budget_setting!(123)
      %BudgetSetting{}

      iex> get_budget_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_budget_setting!(id), do: Repo.get!(BudgetSetting, id)

  @doc """
  Creates a budget_setting.

  ## Examples

      iex> create_budget_setting(%{field: value})
      {:ok, %BudgetSetting{}}

      iex> create_budget_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_budget_setting(attrs \\ %{}) do
    %BudgetSetting{}
    |> BudgetSetting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a budget_setting.

  ## Examples

      iex> update_budget_setting(budget_setting, %{field: new_value})
      {:ok, %BudgetSetting{}}

      iex> update_budget_setting(budget_setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_budget_setting(%BudgetSetting{} = budget_setting, attrs) do
    budget_setting
    |> BudgetSetting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a budget_setting.

  ## Examples

      iex> delete_budget_setting(budget_setting)
      {:ok, %BudgetSetting{}}

      iex> delete_budget_setting(budget_setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_budget_setting(%BudgetSetting{} = budget_setting) do
    Repo.delete(budget_setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking budget_setting changes.

  ## Examples

      iex> change_budget_setting(budget_setting)
      %Ecto.Changeset{data: %BudgetSetting{}}

  """
  def change_budget_setting(%BudgetSetting{} = budget_setting, attrs \\ %{}) do
    BudgetSetting.changeset(budget_setting, attrs)
  end
end
