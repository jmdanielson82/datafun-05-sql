-- ============================================================
-- PURPOSE
-- ============================================================
-- Answer a simple structural question:
-- "How many branches exist in our library system?"
--
-- This query operates only on the independent/parent table.
--
-- WHY:
-- - Establishes the size of the system
-- - Provides context for other KPIs
-- - Helps answer questions like:
--   "Is the system growing by adding branches?"

SELECT
  COUNT(*) AS branch_count
FROM branch;
