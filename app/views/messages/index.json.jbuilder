json.array! @messages do |message|
  json.partial! "messages/message", message: message
  json.locutor_user do
    json.id message.user_id
    json.name message.user.preferred_name
    json.avatar message.user.avatar
    json.last_active message.user.last_active
  end
  json.interlocutor_user do
    json.id message.interlocutor.id
    json.name message.interlocutor.preferred_name
    json.avatar message.interlocutor.avatar
    json.last_active message.interlocutor.last_active
  end
  # json.conversation do
  #   json.id @conversation.id
  #   json.is_active @conversation.is_active
  # end
  json.request do
    json.id @task.id
  end
  # json.url message_url(message, format: :json)
end


