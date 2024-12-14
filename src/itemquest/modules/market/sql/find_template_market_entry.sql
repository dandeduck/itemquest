-- Find template market entry by template_id
SELECT template_market_entries.*, templates.name
FROM template_market_entries 
INNER JOIN templates ON template_market_entries.template_id=templates.template_id
WHERE template_market_entries.template_id = $1
