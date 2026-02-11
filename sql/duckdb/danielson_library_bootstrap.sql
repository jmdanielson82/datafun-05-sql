-- sql/duckdb/danielson_library_bootstrap.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Creates library tables and loads data from CSV files (DuckDB).
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS (relative to repo root):
--   SQL:  sql/duckdb/danielson_library_bootstrap.sql
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
-- - branch is the independent/parent table (1).
-- - checkout is the dependent/child table (M).
-- - The foreign key in checkout is branch_id referencing branch.branch_id.
--
-- ============================================================
-- EXECUTION: ATOMIC BOOTSTRAP (ALL OR NOTHING)
-- ============================================================
BEGIN TRANSACTION;

-- ============================================================
-- STEP 1: CREATE TABLES (PARENT FIRST, THEN CHILD)
-- ============================================================

DROP TABLE IF EXISTS checkout;
DROP TABLE IF EXISTS branch;

CREATE TABLE IF NOT EXISTS branch (
  branch_id TEXT PRIMARY KEY,
  branch_name TEXT NOT NULL,
  city TEXT NOT NULL,
  system_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS checkout (
  checkout_id TEXT PRIMARY KEY,
  branch_id TEXT NOT NULL,
  material_type TEXT NOT NULL,
  duration_days INTEGER NOT NULL,
  fine_amount DOUBLE NOT NULL,
  checkout_date TEXT NOT NULL
);

-- ============================================================
-- STEP 2: LOAD DATA (PARENT FIRST, THEN CHILD)
-- ============================================================

COPY branch
FROM 'data/library/branch.csv'
(HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"');

COPY checkout
FROM 'data/library/checkout.csv'
(HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"');

COMMIT;

