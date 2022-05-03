json.array! @conversations_as_volunteer do |conversation|
  json.extract! conversation, :id, :is_active, :task_id, :user_id, :created_at, :updated_at #, :current_user_role 

end

json.array! @conversations_as_requestor do |conversation|
  json.extract! conversation, :id, :is_active, :task_id, :user_id, :created_at, :updated_at #, :current_user_role 

end

 