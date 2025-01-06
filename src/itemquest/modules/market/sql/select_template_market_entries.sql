-- Select template market entries with (sort_by, limit, offset)
SELECT template_market_entries.*, templates.name, templates.image_url
FROM template_market_entries 
INNER JOIN templates ON template_market_entries.template_id=templates.template_id
ORDER BY $1
LIMIT $2 OFFSET $3;
