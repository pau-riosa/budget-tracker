defmodule BudgetTracker.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias BudgetTracker.Repo
  alias BudgetTracker.Accounts.User
  alias BudgetTracker.Transactions.Transaction

  @spec transfer_amount_v1_to_amount_v2() :: :ok
  def transfer_amount_v1_to_amount_v2() do
    Transaction
    |> from(as: :transactions)
    |> join(:inner, [transactions: t], u in User, on: u.id == t.user_id, as: :users)
    |> where([transactions: t], is_nil(t.amount_v2))
    |> update([users: u, transactions: t],
      set: [amount_v2: fragment("(?, ?)", t.amount, u.currency)]
    )
    |> Repo.update_all([])
  end

  @spec transaction_to_map(Transaction.t()) :: map()
  def transaction_to_map(transaction) do
    %{
      id: transaction.id,
      date: BudgetTrackerWeb.Live.Helpers.format_datetime(transaction.date),
      amount:
        Money.to_string(transaction.amount, symbol: false)
        |> String.replace(",", "")
        |> String.to_integer(),
      currency: transaction.amount.currency,
      category: transaction.budget_setting.category,
      color: transaction.budget_setting.color
    }
  end

  @doc """
  Total Budget settings in dashboard
  """
  def total_transactions_of_user_per_category(user, category) do
    Transaction
    |> join(:inner, [t], bs in assoc(t, :budget_setting), as: :budget_setting)
    |> where([t], t.user_id == ^user.id)
    |> where([t], fragment("?::date >= date_trunc('month', current_date)", t.date))
    |> where([budget_setting: bs], bs.category == ^category)
    |> Repo.aggregate(:sum, :amount)
  end

  @doc """
  Returns the total transactions of a user.
  """
  @spec total_transactions_of_user(User.t()) :: pos_integer() | neg_integer() | any
  def total_transactions_of_user(user) do
    Transaction
    |> where([t], t.user_id == ^user.id)
    |> Repo.aggregate(:sum, :amount)
  end

  @doc """
  Returns the list of transactions of user

  ## Examples

      iex> list_transactions_of_user()
      [%Transaction{}, ...]

  """
  def list_transactions_of_user(user) do
    Transaction
    |> where([t], t.user_id == ^user.id)
    |> order_by(desc: :date)
    |> preload(:budget_setting)
    |> Repo.all()
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
