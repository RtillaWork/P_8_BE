json.extract! task, :id, :title, :description, :kind, :is_published, :is_fullfilled, :lat, :lng, :user_id, :created_at, :updated_at, :unpublished_at, :republishable_start_time , :is_fullfilling , :is_republishable
json.distance task.distance
json.is_within_radius task.is_within_radius
json.active_conversations task.authz_volunteer_ids.count
json.inactive_conversations task.inactive_conversation_ids.count
json.authz_volunteer_ids task.authz_volunteer_ids
json.active_conversation_ids task.active_conversation_ids

