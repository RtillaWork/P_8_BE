
json.array! @tasks do |task|
  json.extract! task, :id, :title, :description, :kind, :is_published, :is_fullfilled, :lat, :lng, :user_id, :created_at, :updated_at, :unpublished_at,:republishable_start_time ,:is_fullfilling , :is_republishable
  json.distance task.distance
  json.query_radius @query_radius
  json.query_lat @query_lat
  json.query_lng @query_lng
  json.query_since @query_since
  json.is_within_radius task.is_within_radius
  json.active_conversations task.authz_volunteer_ids.count
  json.inactive_conversations task.inactive_conversation_ids.count
  json.authz_volunteer_ids task.authz_volunteer_ids
  json.active_conversation_ids task.active_conversation_ids

  current_user_role = if task.user_id == current_user.id then
    # USER_ROLE_AS_REQUESTOR 
    'REQUESTOR'
  elsif task.authz_volunteer_ids.include?(current_user.id) then
    # USER_ROLE_AS_VOLUNTEER 
    'VOLUNTEER'
  else
    # USER_ROLE_AS_OTHER  
    'OTHER'
  end
  json.role current_user_role 
end