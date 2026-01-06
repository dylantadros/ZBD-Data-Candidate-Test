-- I use DuckDB locally. It's lightweight, fast, and it's syntax is very similar to PGs.

/*
 I imported the data to my DB to take advantage of my local development environment. If you want
 to run this yourself, DuckDB is an easy install and you could use the `read_csv('data/game.csv')`
 function to read directly from the CSV files.
 Note: I imported everything as text and trimmed whitespace.
 */

-- Games table
/*
 mixed date formats and invalid dates present
 duplicate games
 */
select
    game_id::text as game_id,
    title::text as game_title,
    release_date::text as game_release_date,
    coalesce(try_strptime(release_date, '%m/%d/%Y'),
    try(release_date::date)
    )::date as game_release__date,
    genre::text as game_genre
from game;

-- Publishers table
/*
 duplicate publishers
 */
select
    publisher_id,
    name,
    country
from publisher;

with transactions as (
-- Transactions Table
/*
 More date/time issues, removing tz as it's not always present
 Line item totals do not match transaction totals
 */
select
    transaction_id,
    txn_type as transaction_type,
    txn_ts as transaction_ts,
    -- assumes UTC
    coalesce(
        try_strptime(txn_ts, '%Y-%m-%dT%H:%M:%SZ'),
        try_strptime(txn_ts, '%Y-%m-%dT%H:%M:%S'),
        try_strptime(txn_ts, '%Y/%m/%d %H:%M:%S'),
        try_strptime(txn_ts, '%m-%d-%Y %H:%M'),
        try_cast(txn_ts AS timestamp)
    ) as transaction__ts,
    currency,
    total_amount::numeric(18,2) as transaction_total,
    customer_ref
from transaction),

transaction_details as (
-- Transaction Details Table
/*
 game, and pub have inconsistent types
 Line item totals do not match transaction totals
 */
select
    -- in practice would likely use hashing function
    concat(transaction_id, '-', line_no) as transaction_detail_id,
    transaction_id,
    line_no,
    game_ref, -- contains name and ID observations
    publisher_ref, -- contains name and ID observations
    region,
    platform,
    gross_amount::numeric(18,2) as gross_amount,
    platform_fee::numeric(18,2) as platform_fee,
    net_amount::numeric(18,2) as net_amount
from transaction_detail
order by transaction_id, line_no)

select
    t.transaction_id,
    sum(td.gross_amount) as calculated_total,
    t.transaction_total as reported_total,
    calculated_total = reported_total as is_match
from transaction_details td
left join transactions t on td.transaction_id = t.transaction_id
group by t.transaction_id,t.transaction_total;

