#  json.partial! "tasks/task", task: @task
json.array! @tasks do |task|
  json.extract! task, :id, :title, :description, :kind, :is_published, :is_fullfilled, :lat, :lng, :user_id, :created_at, :updated_at, :unpublished_at, :republishable_start_time, :is_fullfilling, :is_republishable
  json.distance task.distance
  json.is_within_radius task.is_within_radius
  json.active_conversations task.authz_volunteer_ids.count
  json.inactive_conversations task.inactive_conversation_ids.count
  json.active_conversation_ids task.active_conversation_ids

  # json.url task_url(task, format: :json)
  json.query_radius @query_radius
  json.query_lat @query_lat
  json.query_lng @query_lng
end

# json.array! @tasks do |task|
# json.extract! task, :id, :title, :description, :kind, :is_published, :is_fullfilled, :lat, :lng, :user_id, :created_at, :updated_at,:republishable_start_time ,:is_fullfilling , :is_publishable
# json.default_distance task.default_distance
# json.distance task.distance
# json.active_conversations task.active_conversations.count
# json.inactive_conversations task.inactive_conversations.count
# json.query_radius @query_radius
# json.query_lat @query_lat
# json.query_lng @query_lng
# json.within_radius task.within_radius
# json.url task_url(task, format: :json)
# end