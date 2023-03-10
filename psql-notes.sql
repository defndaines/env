-- connect to a db.
\c db_name

-- run queries from file.
\i /tmp/scratch.sql

-- Turn off paging
\pset pager off

-- See all settings
SHOW ALL;

-- Identify index use
SELECT * FROM pg_stat_user_indexes WHERE relname='orders';

-- Long Running Queries (greater than 30 seconds)
  SELECT now() - query_start AS runtime, usename, datname, state, query
    FROM pg_stat_activity
   WHERE now() - query_start > '30 seconds'::INTERVAL
ORDER BY runtime DESC;

-- cache hit rates (should not be less than 0.99)
SELECT sum(heap_blks_read) AS heap_read,
       sum(heap_blks_hit) AS heap_hit,
       (sum(heap_blks_hit) - sum(heap_blks_read)) / sum(heap_blks_hit) AS ratio
  FROM pg_statio_user_tables;

-- table index usage rates (should not be less than 0.99)
  SELECT relname,
         100 * idx_scan / (seq_scan + idx_scan) AS percent_of_times_index_used,
         n_live_tup AS rows_in_table
    FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- show running queries
  SELECT pid, age(clock_timestamp(), query_start), usename, query
    FROM pg_stat_activity
   WHERE query != '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%'
ORDER BY query_start DESC;

-- table index usage rates (should not be less than 0.99)
  SELECT relname,
         CASE
           WHEN (seq_scan + idx_scan) != 0
           THEN 100.0 * idx_scan / (seq_scan + idx_scan)
           ELSE 0
         END AS percent_of_times_index_used,
         n_live_tup AS rows_in_table
    FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- Unused indexes
  SELECT s.schemaname,
         s.relname AS tablename,
         s.indexrelname AS indexname,
         pg_relation_size(s.indexrelid) AS index_size
    FROM pg_catalog.pg_stat_user_indexes AS s
         JOIN pg_catalog.pg_index AS i ON s.indexrelid = i.indexrelid
   WHERE s.idx_scan = 0
         AND 0 != ALL i.indkey
         AND NOT i.indisunique
         AND NOT EXISTS(
                        SELECT 1
                          FROM pg_catalog.pg_constraint AS c
                         WHERE c.conindid = s.indexrelid
                       )
ORDER BY pg_relation_size(s.indexrelid) DESC;

-- Find invalid indices (can happen when running concurrently on release)
SELECT relname
  FROM pg_class, pg_index
 WHERE pg_index.indisvalid = false AND pg_index.indexrelid = pg_class.oid;

-- DB size
SELECT pg_size_pretty(pg_database_size(current_database()));

-- Export to CSV
COPY products TO '/tmp/products.csv' WITH (FORMAT CSV, HEADER);

-- Copy in files (pipe-delimited)
\copy rxnorm_concepts_temp FROM 'rrf/RXNCONSO.RRF' DELIMITER '|' CSV QUOTE AS e'\x1f';
\copy rxnorm_attributes_temp FROM 'rrf/RXNSAT.RRF' DELIMITER '|' CSV QUOTE AS e'\x1f';
\copy rxnorm_relationships_temp FROM 'rrf/RXNREL.RRF' DELIMITER '|' CSV QUOTE AS e'\x1f';
\copy rxnorm_archived_atoms_temp FROM 'rrf/RXNATOMARCHIVE.RRF' DELIMITER '|' CSV QUOTE AS e'\x1f';

-- From Shell: Import a dump
pg_restore --jobs 4 --clean --if-exists --no-privileges --no-owner \
  --host localhost \
  --dbname your_db_name \
  your_db-2021-06-15.dump

--- JSON Queries
SELECT id,
       name,
       key_values_json->'service_user' AS service_user
  FROM your_settings
 WHERE id = 2;

-- Get distinct keys from JSON in a JSON field
SELECT DISTINCT ARRAY (SELECT json_object_keys(key_values_json)) AS keys
  FROM table_with_json;

--- JSONB Queries
 -- Check that field is present
SELECT count(meta) FROM job_states WHERE (meta->>'task') IS NOT NULL;

 -- See distinct top-level keys in object.
SELECT DISTINCT ARRAY (SELECT jsonb_object_keys(meta)) AS keys FROM job_states;

 -- See values based upon non-top-level key value.
SELECT count(meta) FROM job_states WHERE (meta->'task'->>'id') IS NOT NULL;

 -- See distinct keys within a nested object.
SELECT DISTINCT ARRAY (SELECT jsonb_object_keys(meta->'task')) AS keys
  FROM job_states
 WHERE (meta->>'task') IS NOT NULL;

 -- Update a nested field in JSON.
UPDATE events
   SET payload = jsonb_set(payload, '{"companies"}', '[]')
 WHERE id = 821252;


-- CTEs
  WITH x AS (SELECT * FROM y), z AS (SELECT * FROM w WHERE id > 666)
SELECT *
  FROM v
 WHERE u IN (SELECT t FROM w);

-- See what the next ID for a table is
SELECT last_value FROM transactions_id_seq;

-- How many records per month.
  SELECT count(t.id), date_trunc('month', t.created_at)
    FROM date_stamped_table AS t
GROUP BY date_trunc('month', t.created_at)
ORDER BY date_trunc('month', t.created_at);

-- Using a CASE statement to make enumerations explicit
  SELECT category,
         CASE
					 WHEN category = 0 THEN 'labs'
					 WHEN category = 1 THEN 'vitals'
					 WHEN category = 2 THEN 'procedures'
					 WHEN category = 3 THEN 'diagnosis'
					 WHEN category = 4 THEN 'assessments'
					 ELSE 'unknown'
         END AS type,
         count(*)
    FROM your_table
GROUP BY category
ORDER BY category;

-- Update sequence values in the DB.
SELECT pg_catalog.setval(pg_get_serial_sequence('table_name', 'id'), max(id))
  FROM table_name;

-- Largest tables in DB
  SELECT nspname || '.' || relname AS relation,
         pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
    FROM pg_class AS c LEFT JOIN pg_namespace AS n ON n.oid = c.relnamespace
   WHERE nspname NOT IN ('pg_catalog', 'information_schema')
         AND c.relkind != 'i'
         AND nspname !~ '^pg_toast'
ORDER BY pg_total_relation_size(c.oid) DESC;

-- Find tables with a certain field name ('organization_id')
  SELECT t.table_schema, t.table_name
    FROM information_schema.tables AS t
         INNER JOIN information_schema.columns AS c
                 ON c.table_name = t.table_name
                    AND c.table_schema = t.table_schema
   WHERE c.column_name = 'organization_id'
         AND t.table_schema NOT IN ('information_schema', 'pg_catalog')
         AND t.table_type = 'BASE TABLE'
ORDER BY t.table_schema;

-- Find records from the last fifteen minutes
WHERE created_at > (NOW() - INTERVAL '15 minutes')

-- Selecting records where a field appears more than once:
    WITH rs AS (
              SELECT *, count(*) OVER (PARTITION BY rule_id) AS cnt FROM rules
            )
  SELECT rule_id, check_period
    FROM rs
   WHERE cnt > 1
ORDER BY rule_id;

-- New records chunked in 10 minute intervals.
  SELECT count(*) AS cnt,
         timezone(
          'UTC',
          to_timestamp(floor(extract('epoch', created_at) / 600) * 600)
         ) AS interval_alias
    FROM snapshots
GROUP BY interval_alias
ORDER BY 2 DESC;

-- Export data as JSON (NOTE: still needs to be formatted, like adding "," between records).
COPY (
  SELECT ROW_TO_JSON(r)
  FROM (SELECT id, name FROM rules ORDER BY name) r
) TO '/tmp/rules.json';

-- Index and table hit rates for the current database
SELECT current_database() AS database,
       (
        SELECT sum(idx_blks_hit) / sum(idx_blks_hit + idx_blks_read)
          FROM pg_statio_user_indexes
       ) AS index_hit_rate,
       (
        SELECT sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read))
          FROM pg_statio_user_tables
       ) AS table_hit_rate;

-- See how large tables are:
  SELECT table_name, pg_relation_size(quote_ident(table_name))
    FROM information_schema.tables
   WHERE table_schema = 'public'
ORDER BY pg_relation_size;

-- To see size of DBs on disk:
\l+

-- Query for Locking
  SELECT pg_stat_activity.pid,
         pg_class.relname,
         pg_locks.transactionid,
         pg_locks.granted,
         substr(pg_stat_activity.query, 1, 30) AS query_snippet,
         age(now(), pg_stat_activity.query_start) AS age
    FROM pg_stat_activity,
         pg_locks
         LEFT JOIN pg_class ON pg_locks.relation = pg_class.oid
   WHERE pg_stat_activity.query != '<insufficient privilege>'
         AND pg_locks.pid = pg_stat_activity.pid
         AND pg_locks.mode = 'ExclusiveLock'
ORDER BY query_start;

-- Queries for Stats Statements
  SELECT total_time / 1000 / 60 AS total_minutes,
         total_time / calls AS average_time,
         query
    FROM pg_stat_statements
ORDER BY 1 DESC
   LIMIT 10;

-- Order by total_time from stats
  SELECT substring(query, 1, 50) AS short_query,
         round(total_time::NUMERIC, 2) AS total_time,
         calls,
         round(mean_time::NUMERIC, 2) AS mean,
         round(
          (100 * total_time / sum(total_time::NUMERIC) OVER ())::NUMERIC,
          2
         ) AS percentage_cpu,
         max_time,
         stddev_time
    FROM pg_stat_statements
ORDER BY total_time DESC
   LIMIT 20;

-- to test out the autovacuum and analyze scale factor changes
  SELECT relname,
         last_vacuum,
         last_autovacuum,
         last_analyze,
         last_autoanalyze,
         n_dead_tup AS deadrows
    FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC
   LIMIT 10;

-- Just see what's going on in the DB at the moment:
SELECT pid, usename, application_name, client_addr, backend_start, query_start, wait_event_type, state
  FROM pg_stat_activity
 WHERE datname = 'your_db_name';

-- As above, showing the query:
SELECT pid, usename, application_name, client_addr, backend_start, query_start, wait_event_type, state, query
  FROM pg_stat_activity
 WHERE datname = 'your_db_name';

-- See what the value of a sequence is:
SELECT last_value FROM correlations_id_seq;
SELECT CURRVAL('correlations_id_seq');

-- Update a sequence
BEGIN;
-- protect against concurrent inserts while you update the counter
LOCK TABLE your_table IN EXCLUSIVE MODE;
-- Update the sequence
SELECT setval('your_table_id_seq', COALESCE((SELECT MAX(id)+1 FROM your_table), 1), false);
COMMIT;

-- count all tables
CREATE OR REPLACE FUNCTION
count_rows(schema TEXT, tablename TEXT) RETURNS INTEGER
AS
$body$
DECLARE
  result INTEGER;
  query VARCHAR;
BEGIN
  query := 'SELECT count(1) FROM ' || schema || '.' || tablename;
  EXECUTE query INTO result;
  RETURN result;
END;
$body$
LANGUAGE plpgsql;

  SELECT table_schema, table_name, count_rows(table_schema, table_name)
    FROM information_schema.tables
   WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
         AND table_type = 'BASE TABLE'
ORDER BY count_rows DESC;
