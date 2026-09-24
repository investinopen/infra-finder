WITH claimed_providers AS (
  SELECT DISTINCT provider_id
  FROM provider_editor_assignments
), claimed_solutions AS (
  SELECT DISTINCT solution_id
  FROM solution_editor_assignments
)
SELECT
  s.id AS solution_id,
  s.provider_id AS provider_id,
  details.claimed_through_provider,
  details.claimed_directly,
  CASE
  WHEN details.claimed_through_provider OR details.claimed_directly
  THEN 'claimed'
  ELSE
    'unclaimed'
  END::public.solution_claim_state AS claim_state
FROM solutions s
LEFT OUTER JOIN claimed_providers cp USING (provider_id)
LEFT OUTER JOIN claimed_solutions cs ON cs.solution_id = s.id
LEFT JOIN LATERAL (
  SELECT
    cp.provider_id IS NOT NULL AS claimed_through_provider,
    cs.solution_id IS NOT NULL AS claimed_directly
) details ON true
