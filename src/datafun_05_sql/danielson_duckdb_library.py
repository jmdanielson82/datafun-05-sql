"""danielson_duckdb_library.py - Project script (library domain).

Author: Jennifer Danielson
Date: 2026-02

Purpose:
- Read csv files into a DuckDB database.
- Use Python to automate SQL scripts (stored in files).
- Log the pipeline process.

Paths (relative to repo root):
   SQL:  sql/duckdb/*.sql
   CSV:  data/library/*.csv  (update names below if different)
   DB:   artifacts/duckdb/library.duckdb
"""

# === DECLARE IMPORTS ===

import logging
from pathlib import Path
from typing import Final

from datafun_toolkit.logger import get_logger, log_header
import duckdb

# === CONFIGURE LOGGER ONCE PER MODULE (FILE) ===

LOG: logging.Logger = get_logger("P05", level="DEBUG")

# === DECLARE GLOBAL CONSTANTS ===

ROOT_DIR: Final[Path] = Path.cwd()

DATA_DIR: Final[Path] = ROOT_DIR / "data" / "library"
SQL_DIR: Final[Path] = ROOT_DIR / "sql" / "duckdb"
ARTIFACTS_DIR: Final[Path] = ROOT_DIR / "artifacts" / "duckdb"
DB_PATH: Final[Path] = ARTIFACTS_DIR / "library.duckdb"

# Update these two filenames to match your actual CSV names:
BRANCHES_CSV: Final[Path] = DATA_DIR / "branch.csv"
CHECKOUTS_CSV: Final[Path] = DATA_DIR / "checkout.csv"


def read_sql(sql_path: Path) -> str:
    """Read a SQL file from disk (UTF-8)."""
    return sql_path.read_text(encoding="utf-8")


def run_sql_script(con: duckdb.DuckDBPyConnection, sql_path: Path) -> None:
    """Execute a SQL action script file (DDL, COPY, cleanup)."""
    LOG.info(f"RUN SQL script: {sql_path}")
    sql_text = read_sql(sql_path)
    con.execute(sql_text)
    LOG.info(f"DONE SQL script: {sql_path}")


def run_sql_query(con: duckdb.DuckDBPyConnection, sql_path: Path) -> None:
    """Execute a SQL query script file and log results."""
    LOG.info("")
    LOG.info(f"RUN SQL query: {sql_path}")
    sql_text = read_sql(sql_path)

    result = con.execute(sql_text)
    rows = result.fetchall()
    columns = [col[0] for col in result.description]

    LOG.info("====================================")
    LOG.info(sql_path.name)
    LOG.info("====================================")
    LOG.info(", ".join(columns))

    for row in rows:
        LOG.info(", ".join(str(value) for value in row))


def main() -> None:
    """Run the library pipeline."""
    log_header(LOG, "P05 Pipeline (DuckDB) - Library")

    LOG.info("START main()")
    LOG.info(f"ROOT_DIR: {ROOT_DIR}")
    LOG.info(f"DATA_DIR: {DATA_DIR}")
    LOG.info(f"SQL_DIR: {SQL_DIR}")
    LOG.info(f"DB_PATH: {DB_PATH}")
    LOG.info(f"BRANCHES_CSV: {BRANCHES_CSV}")
    LOG.info(f"CHECKOUTS_CSV: {CHECKOUTS_CSV}")

    ARTIFACTS_DIR.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(DB_PATH))

    try:
        # STEP 1: CLEAN (optional during development)
        run_sql_script(con, SQL_DIR / "danielson_library_clean.sql")

        # STEP 2: BOOTSTRAP (create/load)
        run_sql_script(con, SQL_DIR / "danielson_library_bootstrap.sql")

        # STEP 3: BASIC QUERIES
        run_sql_query(con, SQL_DIR / "danielson_library_query_branch_count.sql")
        run_sql_query(con, SQL_DIR / "danielson_library_query_checkout_count.sql")
        run_sql_query(con, SQL_DIR / "danielson_library_query_branch_aggregate.sql")
        run_sql_query(con, SQL_DIR / "danielson_library_query_checkouts_by_material.sql")

        # STEP 4: KPI QUERY
        run_sql_query(con, SQL_DIR / "danielson_library_query_kpi_fines.sql")

    finally:
        con.close()

    LOG.info("END main()")


if __name__ == "__main__":
    main()
