-- ============================================================
-- PURPOSE
-- ============================================================
-- Break overall checkout activity down by material type.
--
-- This query answers:
-- "How many checkouts and how much in fines occur by material type?"
--
-- WHY:
-- - Overall totals hide differences between materials
-- - Grouping lets us compare usage patterns
-- - Reveals insights like:
--   * Which materials are checked out most?
--   * Which generate the most fines?
--
-- IMPORTANT:
-- Uses GROUP BY without joins.
-- Operates only on the dependent/child table (checkout).

SELECT
  material_type,
  COUNT(*) AS checkout_count,
  ROUND(SUM(fine_amount), 2) AS total_fines,
  ROUND(AVG(fine_amount), 2) AS avg_fine
FROM checkout
GROUP BY material_type
ORDER BY total_fines DESC;

