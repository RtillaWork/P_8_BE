json.array! @conversations_as_volunteer do |conversation|
  json.extract! conversation, :id, :is_active, :task_id, :user_id, :created_at, :updated_at #, :current_user_role 
  json.role @user_role_as_volunteer # 'VOLUNTEER'

  json.requestor do
    json.id conversation.task.user.id
    json.preferred_name conversation.task.user.preferred_name
    json.avatar conversation.task.user.avatar
    json.last_loggedin conversation.task.user.last_loggedin
  end

  json.task do
    json.kind conversation.task.kind
    json.title conversation.task.title
  end
  # json.url conversation_url(conversation, format: :json)
end


json.array! @conversations_as_requestor do |conversation|
  json.extract! conversation, :id, :is_active, :task_id, :user_id, :created_at, :updated_at #, :current_user_role 
  json.role @user_role_as_requestor # 'REQUESTOR'

  json.volunteers do
    json.array! conversation.task.authz_volunteer_ids do |id|
      volunteer = User.find(id)
      json.volunteer do
        json.id volunteer.id
        json.preferred_name volunteer.preferred_name
        json.avatar volunteer.avatar
        json.last_loggedin volunteer.last_loggedin
      end
    end
  end

  json.task do
    json.kind conversation.task.kind
    json.title conversation.task.title
  end

end
