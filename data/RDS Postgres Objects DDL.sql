/*
============================================================
Notes:
- Database already created by terraform
- Constraints below set for ease of creating/maintaining the simulated data, not necessarily what a
    production env would use.
============================================================
 */

-- Publisher
create table if not exists publishers
(
    publisher_id      bigint generated always as identity primary key,
    publisher_name    text not null,
    publisher_country text
);

-- Game (published by publisher)
create table if not exists games
(
    game_id           bigint generated always as identity primary key,
    publisher_id      bigint not null references publishers (publisher_id) on delete restrict ,
    game_title        text   not null,
    game_release_date date,
    game_genre        text
);

-- Customer
create table if not exists customers
(
    customer_id bigint generated always as identity primary key,
    name        text not null,
    email       text
);

-- Transactions (placed by customer)
create table if not exists transactions
(
    transaction_id   bigint generated always as identity primary key,
    customer_id      bigint      not null references customers (customer_id) on delete restrict ,
    transaction_type text        not null,
    currency         text        not null,
    placed_at        timestamptz not null
);

-- line Item (consists of transaction; references game)
create table if not exists line_items
(
    line_item_id   bigint generated always as identity primary key,
    transaction_id bigint         not null references transactions (transaction_id) on delete restrict ,
    game_id        bigint         not null references games (game_id) on delete restrict,
    game_platform  text,
    gross_amount   numeric(12, 2) not null,
    platform_fee   numeric(12, 2) not null,
    net_amount     numeric(12, 2) not null generated always as (gross_amount - platform_fee) stored
);

-- Set indexes
create index if not exists ix_game_publisher_id on games (publisher_id);
create index if not exists ix_transactions_customer_id on transactions (customer_id);
create index if not exists ix_line_item_transaction_id on line_items (transaction_id);
create index if not exists ix_line_item_game_id on line_items (game_id);
