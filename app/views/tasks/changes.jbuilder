json.created do
  json.array! @created do |task|
    json.extract! task, :id, :title, :kind, :is_published, :is_fullfilled, :lat, :lng, :user_id, :created_at, :updated_at, :unpublished_at,:republishable_start_time ,:is_fullfilling , :is_republishable
    json.distance task.distance
    json.active_conversations task.authz_volunteer_ids.count
    json.inactive_conversations task.inactive_conversation_ids.count
    json.active_conversation_ids task.active_conversation_ids

    # json.query_radius @query_radius
    # json.query_lat @query_lat
    # json.query_lng @query_lng
    json.query_since @query_since
    json.is_within_radius task.is_within_radius
    json.authz_volunteer_ids task.authz_volunteer_ids
    # json.url task_url(task, format: :json)
  end
end

# NOTE updated only sends back data that might have changed. Every other field is RO after task is created
json.updated do
  json.array! @updated do |task|
    json.extract! task, :id, :is_published, :is_fullfilled, :updated_at, :unpublished_at,:republishable_start_time ,:is_fullfilling , :is_publishable   
    json.active_conversations task.authz_volunteer_ids.count
    json.inactive_conversations task.inactive_conversation_ids.count
    json.active_conversation_ids task.active_conversation_ids

    json.query_since @query_since
  end
end