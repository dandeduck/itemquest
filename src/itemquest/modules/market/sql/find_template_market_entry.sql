-- Find template market entry by template_id
SELECT template_market_entries.*, item_templates.name
FROM template_market_entries 
INNER JOIN item_templates ON template_market_entries.template_id=item_templates.template_id
WHERE template_market_entries.template_id = $1
