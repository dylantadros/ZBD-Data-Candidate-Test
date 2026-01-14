-- AI generated mock data to test RDS instance

-- Publishers
insert into
    publishers (publisher_name, publisher_country)
values
    ('Nintendo', 'Japan'),
    ('Sony Interactive Entertainment', 'Japan'),
    ('Valve', 'United States'),
    ('CD Projekt', 'Poland');

select *
from
    publishers;

-- Games
insert into
    games (publisher_id, game_title, game_release_date, game_genre)
select
    p.publisher_id,
    g.game_title,
    g.game_release_date,
    g.game_genre
from
    (values
         ('Nintendo', 'The Legend of Zelda: Breath of the Wild', date '2017-03-03', 'Adventure'),
         ('Nintendo', 'Mario Kart 8 Deluxe', date '2017-04-28', 'Racing'),
         ('Sony Interactive Entertainment', 'God of War Ragnarok', date '2022-11-09', 'Action'),
         ('Sony Interactive Entertainment', 'Spider-Man 2', date '2023-10-20', 'Action'),
         ('Valve', 'Half-Life 2', date '2004-11-16', 'Shooter'),
         ('CD Projekt', 'Cyberpunk 2077', date '2020-12-10',
          'RPG')) as g(publisher_name, game_title, game_release_date, game_genre)
        join publishers p
             on p.publisher_name = g.publisher_name;

select *
from
    games;

-- customers
insert into
    customers (name, email)
values
    ('Ava Johnson', 'ava.johnson@example.com'),
    ('Noah Patel', 'noah.patel@example.com'),
    ('Mia Chen', 'mia.chen@example.com'),
    ('Ethan Rivera', 'ethan.rivera@example.com');

select *
from
    customers;

-- Transactions
insert into
    transactions (customer_id, transaction_type, currency, placed_at)
select
    c.customer_id,
    t.transaction_type,
    t.currency,
    t.placed_at
from
    (values
         ('ava.johnson@example.com', 'purchase', 'USD', timestamptz '2025-01-05T14:22:10Z'),
         ('ava.johnson@example.com', 'refund', 'USD', Timestamptz '2025-01-06T18:40:00Z'),
         ('noah.patel@example.com', 'purchase', 'USD', timestamptz '2025-01-07T11:05:00Z'),
         ('mia.chen@example.com', 'purchase', 'EUR', TImestamptz '2025-01-08T03:12:44Z'),
         ('ethan.rivera@example.com', 'purchase', 'USD', timestamptz '2025-01-10T21:15:33Z'),
         ('noah.patel@example.com', 'purchase', 'USD',
          timestamptz '2025-01-11T10:00:00Z')) as t(customer_email, transaction_type, currency, placed_at)
        join customers c
             on c.email = t.customer_email;

select *
from
    transactions;

-- line items
insert into
    line_items (transaction_id,
                game_id,
                game_platform,
                gross_amount,
                platform_fee)
select
    tr.transaction_id,
    g.game_id,
    li.game_platform,
    li.gross_amount,
    li.platform_fee
from
    (values
         ('ava.johnson@example.com', '2025-01-05T14:22:10Z', 'purchase', 'Nintendo',
          'The Legend of Zelda: Breath of the Wild', 'Switch', 59.99, 9.00),
         ('ava.johnson@example.com', '2025-01-05T14:22:10Z', 'purchase', 'Nintendo', 'Mario Kart 8 Deluxe', 'Switch',
          49.99, 7.50),
         ('ava.johnson@example.com', '2025-01-06T18:40:00Z', 'refund', 'Nintendo', 'Mario Kart 8 Deluxe', 'Switch',
          49.99, 7.50),
         ('noah.patel@example.com', '2025-01-07T11:05:00Z', 'purchase', 'Sony Interactive Entertainment',
          'God of War Ragnarok', 'PS5', 69.99, 10.50),
         ('noah.patel@example.com', '2025-01-07T11:05:00Z', 'purchase', 'Valve', 'Half-Life 2', 'PC', 9.99, 1.50),
         ('mia.chen@example.com', '2025-01-08T03:12:44Z', 'purchase', 'CD Projekt', 'Cyberpunk 2077', 'PC', 29.99,
          4.50),
         ('mia.chen@example.com', '2025-01-08T03:12:44Z', 'purchase', 'Valve', 'Half-Life 2', 'PC', 9.99, 1.50),
         ('ethan.rivera@example.com', '2025-01-10T21:15:33Z', 'purchase', 'Sony Interactive Entertainment',
          'Spider-Man 2', 'PS5', 69.99, 10.50),
         ('noah.patel@example.com', '2025-01-11T10:00:00Z', 'purchase', 'Nintendo',
          'The Legend of Zelda: Breath of the Wild', 'Switch', 59.99, 9.00),
         ('noah.patel@example.com', '2025-01-11T10:00:00Z', 'purchase', 'CD Projekt', 'Cyberpunk 2077', 'PC', 29.99,
          4.50)) as li(
                       customer_email,
                       placed_at,
                       transaction_type,
                       publisher_name,
                       game_title,
                       game_platform,
                       gross_amount,
                       platform_fee
        )
        join customers c
             on c.email = li.customer_email
        join transactions tr
             on tr.customer_id = c.customer_id
                 and tr.placed_at = li.placed_at::timestamptz
                 and tr.transaction_type = li.transaction_type
        join publishers p
             on p.publisher_name = li.publisher_name
        join games g
             on g.publisher_id = p.publisher_id
                 and g.game_title = li.game_title;

select *
from
    line_items;


-- Sample Analytics queries

-- Totals
SELECT
    COUNT(DISTINCT t.transaction_id) AS transactions,
    COUNT(DISTINCT t.customer_id) AS customers,
    SUM(li.gross_amount) AS gross_amount,
    SUM(li.platform_fee) AS platform_fee,
    SUM(li.net_amount) AS net_amount,
    ROUND(SUM(li.platform_fee) / NULLIF(SUM(li.gross_amount), 0), 4) AS fee_rate
FROM
    transactions t
        JOIN line_items li ON li.transaction_id = t.transaction_id;

-- Revenue by platform
SELECT
    li.game_platform,
    SUM(li.gross_amount) AS gross_amount,
    SUM(li.platform_fee) AS platform_fee,
    SUM(li.net_amount) AS net_amount,
    COUNT(*) AS line_items
FROM
    line_items li
GROUP BY
    1
ORDER BY
    net_amount DESC;

-- Fee rate by platform
SELECT
    li.game_platform,
    ROUND(SUM(li.platform_fee) / NULLIF(SUM(li.gross_amount), 0), 4) AS fee_rate,
    SUM(li.gross_amount) AS gross_amount
FROM
    line_items li
GROUP BY
    1
ORDER BY
    fee_rate DESC;

-- daily revenue
SELECT
    date_trunc('day', t.placed_at)::date AS day,
    SUM(li.gross_amount) AS gross_amount,
    SUM(li.platform_fee) AS platform_fee,
    SUM(li.net_amount) AS net_amount,
    COUNT(DISTINCT t.transaction_id) AS transactions
FROM
    transactions t
        JOIN line_items li ON li.transaction_id = t.transaction_id
GROUP BY
    1
ORDER BY
    1;

-- LTV
SELECT
  c.customer_id,
  c.name,
  c.email,
  COUNT(DISTINCT t.transaction_id) AS transactions,
  SUM(li.gross_amount)             AS gross_amount,
  SUM(li.net_amount)               AS net_amount
FROM customers c
JOIN transactions t ON t.customer_id = c.customer_id
JOIN line_items li  ON li.transaction_id = t.transaction_id
GROUP BY 1,2,3
ORDER BY net_amount DESC;