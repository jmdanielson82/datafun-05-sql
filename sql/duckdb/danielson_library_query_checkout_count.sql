-- ============================================================
-- PURPOSE
-- ============================================================
-- Answer a basic activity question:
-- "How many checkout events have occurred?"
--
-- This query operates on the dependent/child table.
--
-- WHY:
-- - Event volume is an important usage signal
-- - A branch may have many short checkouts or fewer long ones
-- - Analysts often begin by understanding activity counts
--   before deeper analysis

SELECT
  COUNT(*) AS checkout_count
FROM checkout;
