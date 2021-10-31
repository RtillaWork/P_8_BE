
json.partial! "conversations/conversation", conversation: @conversation

json.role @user_role

json.requestor do
  json.id @task.user.id
  json.preferred_name @task.user.preferred_name
  json.avatar @task.user.avatar
  json.last_loggedin @task.user.last_loggedin
end

json.task do
  json.kind @task.kind
  json.title @task.title
  # json.active_conversations_count @task.active_conversations_count
  json.authz_volunteer_count @task.authz_volunteer_ids.count
  json.is_fullfiled @task.is_fullfilled
  json.created_at @task.created_at
  json.updated_at @task.updated_at
end

json.messages do
  if @conversation.messages.present?
    json.most_recent json.partial! "messages/message", message: @conversation.messages.last
  # json.most_recent_sent_at @conversation.messages.last.created_at
  else
    json.null!
  end  
end
# json.url conversation_url(@conversation, format: :json)
