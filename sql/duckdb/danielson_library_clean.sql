-- sql/duckdb/danielson_library_clean.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Completely removes library tables from the DuckDB database.
-- This "clean" step resets the database so we can rebuild it.
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS (relative to repo root):
--   SQL:  sql/duckdb/danielson_library_clean.sql
--   CSV:  data/library/branch.csv
--   CSV:  data/library/checkout.csv
--   DB:   artifacts/duckdb/library.duckdb
--
-- ============================================================
-- TOPIC DOMAIN + 1:M RELATIONSHIP
-- ============================================================
-- OUR DOMAIN: LIBRARY
-- A branch has many checkouts.
-- Therefore, we have two tables: branch (1) and checkout (M).
--
-- REQ: Drop tables in reverse order (CHILD FIRST, THEN PARENT)
-- ============================================================

BEGIN TRANSACTION;

-- Drop the dependent/child table first
DROP TABLE IF EXISTS checkout;

-- Drop the independent/parent table second
DROP TABLE IF EXISTS branch;

COMMIT;
