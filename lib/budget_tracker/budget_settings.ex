defmodule BudgetTracker.BudgetSettings do
  @moduledoc """
  The BudgetSettings context.
  """

  import Ecto.Query, warn: false
  alias BudgetTracker.Repo
  alias BudgetTracker.Accounts.User
  alias BudgetTracker.BudgetSettings.BudgetSetting

  @spec transfer_amount_v1_to_amount_v2() :: :ok
  def transfer_amount_v1_to_amount_v2() do
    BudgetSetting
    |> from(as: :budget_settings)
    |> join(:inner, [budget_settings: b], u in User, on: u.id == b.user_id, as: :users)
    |> where([budget_settings: b], is_nil(b.planned_amount_v2))
    |> update([users: u, budget_settings: b],
      set: [planned_amount_v2: fragment("(?, ?)", b.planned_amount, u.currency)]
    )
    |> Repo.update_all([])
  end

  @doc """
  Returns the total budget.
  """
  @spec total_budget_of_user(user :: User.t()) :: pos_integer | neg_integer | nil
  def total_budget_of_user(user) do
    BudgetSetting
    |> where(user_id: ^user.id)
    |> Repo.aggregate(:sum, :planned_amount)
  end

  @doc """
  Returns the list of budget_settings of a user.
  """
  @spec list_budget_settings_of_user(user :: User.t()) :: list(BudgetSetting.t())
  def list_budget_settings_of_user(user) do
    transaction_query =
      from(t in BudgetTracker.Transactions.Transaction, where: t.user_id == ^user.id)

    user_id = Ecto.UUID.dump!(user.id)

    BudgetSetting
    |> where(user_id: ^user.id)
    |> order_by(asc: :inserted_at)
    |> select_merge([b], %{
      actual_amount:
        fragment(
          """
            (SELECT sum(amount) FROM transactions WHERE budget_setting_id = ? AND user_id = ?)
          """,
          b.id,
          ^user_id
        ),
      diff_amount:
        fragment(
          """
            (SELECT abs(?::integer - sum(amount)::integer) FROM transactions WHERE budget_setting_id = ? AND user_id = ?)
          """,
          b.planned_amount,
          b.id,
          ^user_id
        )
    })
    |> preload(transactions: ^transaction_query)
    |> Repo.all()
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
