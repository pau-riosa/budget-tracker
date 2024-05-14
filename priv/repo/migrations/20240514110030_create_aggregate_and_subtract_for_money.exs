defmodule BudgetTracker.Repo.Migrations.CreateAggregateAndSubtractForMoney do
  use Ecto.Migration

  def up do
    execute("""
    CREATE OR REPLACE FUNCTION subtract(agg_state1 money_with_currency, agg_state2 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF currency(agg_state1) = currency(agg_state2) THEN
          return row(amount(agg_state1) - amount(agg_state2), currency(agg_state1));
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_sum_state_function(agg_state money_with_currency, money money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        expected_currency varchar(3);
        aggregate numeric;
        addition numeric;
      BEGIN
        if currency(agg_state) IS NULL then
          expected_currency := currency(money);
          aggregate := 0;
        else
          expected_currency := currency(agg_state);
          aggregate := amount(agg_state);
        end if;

        IF currency(money) = expected_currency THEN
          addition := aggregate + amount(money);
          return row(addition, expected_currency);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_sum_combine_function(agg_state1 money_with_currency, agg_state2 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF currency(agg_state1) = currency(agg_state2) THEN
          return row(amount(agg_state1) + amount(agg_state2), currency(agg_state1));
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE AGGREGATE sum(money_with_currency)
    (
      sfunc = money_sum_state_function,
      stype = money_with_currency,
      combinefunc = money_sum_combine_function,
      parallel = SAFE
    );
    """)
  end

  def down do
    execute("DROP FUNCTION IF EXISTS subtract(money_with_currency, money_with_currency)")

    execute(
      "DROP FUNCTION IF EXISTS money_sum_state_function(money_with_currency, money_with_currency)  CASCADE "
    )

    execute(
      "DROP FUNCTION IF EXISTS  money_sum_combine_function(money_with_currency, money_with_currency)  CASCADE "
    )

    execute("DROP AGGREGATE IF EXISTS sum(money_with_currency)")
  end
end
