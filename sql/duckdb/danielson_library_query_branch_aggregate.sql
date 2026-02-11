-- ============================================================
-- PURPOSE
-- ============================================================
-- Summarize overall checkout activity across ALL branches.
--
-- This query answers:
-- - "How many checkouts occurred?"
-- - "What were the total fines collected?"
-- - "What was the average fine?"
-- - "What was the average checkout duration?"
--
-- WHY:
-- - Establishes system-wide performance
-- - Provides a baseline before breaking results down by branch

SELECT
  COUNT(*) AS checkout_count,
  ROUND(SUM(fine_amount), 2) AS total_fines,
  ROUND(AVG(fine_amount), 2) AS avg_fine,
  ROUND(AVG(duration_days), 2) AS avg_duration_days
FROM checkout;
