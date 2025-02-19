UPDATE item_instances
SET user_id = $3
WHERE item_instance_id = $1 AND user_id = $2;
