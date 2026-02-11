-- ============================================================
-- PURPOSE
-- ============================================================
-- Calculate a Key Performance Indicator (KPI) for the library domain using DuckDB SQL.
--
-- KPI DRIVES THE WORK:
-- We start with a KPI that supports an actionable decision.
--
-- ACTIONABLE OUTCOME (EXAMPLE):
-- Identify which branches generate the most fines so we can:
-- - target overdue reminders,
-- - review lending policies for high-fine branches,
-- - allocate staffing or resources to high-activity branches.
--
-- ============================================================
-- KPI DEFINITION
-- ============================================================
-- KPI NAME: Total Fines by Branch
--
-- KPI QUESTION:
-- "How much in fines did each branch generate?"
--
-- MEASURES:
-- - total_fines = SUM(checkout.fine_amount)
-- - checkout_count = COUNT(checkout.checkout_id)
-- - avg_fine = AVG(checkout.fine_amount)
-- - avg_duration_days = AVG(checkout.duration_days)
--
-- GRAIN:
-- - one row per branch
--
-- ============================================================
-- EXECUTION
-- ============================================================
-- Strategy:
-- - JOIN branch (1) to checkout (M) on branch_id
-- - GROUP BY branch
-- - Aggregate fines and activity
-- - ORDER so top branches appear first

SELECT
  b.branch_id,
  b.branch_name,
  b.city,
  b.system_name,
  COUNT(c.checkout_id) AS checkout_count,
  ROUND(SUM(c.fine_amount), 2) AS total_fines,
  ROUND(AVG(c.fine_amount), 2) AS avg_fine,
  ROUND(AVG(c.duration_days), 2) AS avg_duration_days
FROM branch AS b
JOIN checkout AS c
  ON c.branch_id = b.branch_id
GROUP BY
  b.branch_id,
  b.branch_name,
  b.city,
  b.system_name
ORDER BY total_fines DESC;
