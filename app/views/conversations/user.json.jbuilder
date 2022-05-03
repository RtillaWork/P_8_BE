json.array! @conversations_as_volunteer do |conversation|
  json.extract! conversation, :id, :is_active, :task_id, :user_id, :created_at, :updated_at
  json.role @user_role_as_volunteer # 'VOLUNTEER'

end

json.array! @conversations_as_volunteer do |conversation|
  json.extract! conversation, :id, :is_active, :task_id, :user_id, :created_at, :updated_at
  json.role @user_role_as_requestor # 'REQUESTOR'

end
