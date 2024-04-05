defmodule BudgetTracker.InvestmentsTest do
  use BudgetTracker.DataCase

  alias BudgetTracker.Investments

  describe "investments" do
    alias BudgetTracker.Investments.Investment
    import BudgetTracker.AccountsFixtures
    import BudgetTracker.InvestmentsFixtures

    @invalid_attrs %{type: nil, account_type: nil, amount: nil}

    test "list_investments/0 returns all investments" do
      investment = investment_fixture()
      assert Investments.list_investments() == [investment]
    end

    test "get_investment!/1 returns the investment with given id" do
      investment = investment_fixture()
      assert Investments.get_investment!(investment.id) == investment
    end

    test "create_investment/1 with valid data creates a investment" do
      user = user_fixture()

      valid_attrs = %{
        type: :investment,
        account_type: "some account_type",
        amount: 120.5,
        user_id: user.id
      }

      assert {:ok, %Investment{} = investment} = Investments.create_investment(valid_attrs)
      assert investment.type == :investment
      assert investment.account_type == "some account_type"
      assert investment.amount == 120.5
    end

    test "create_investment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Investments.create_investment(@invalid_attrs)
    end

    test "update_investment/2 with valid data updates the investment" do
      investment = investment_fixture()
      update_attrs = %{type: :savings, account_type: "some updated account_type", amount: 456.7}

      assert {:ok, %Investment{} = investment} =
               Investments.update_investment(investment, update_attrs)

      assert investment.type == :savings
      assert investment.account_type == "some updated account_type"
      assert investment.amount == 456.7
    end

    test "update_investment/2 with invalid data returns error changeset" do
      investment = investment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Investments.update_investment(investment, @invalid_attrs)

      assert investment == Investments.get_investment!(investment.id)
    end

    test "delete_investment/1 deletes the investment" do
      investment = investment_fixture()
      assert {:ok, %Investment{}} = Investments.delete_investment(investment)
      assert_raise Ecto.NoResultsError, fn -> Investments.get_investment!(investment.id) end
    end

    test "change_investment/1 returns a investment changeset" do
      investment = investment_fixture()
      assert %Ecto.Changeset{} = Investments.change_investment(investment)
    end
  end
end
