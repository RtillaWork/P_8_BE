class Message < ApplicationRecord
  include Project8Constants

  belongs_to :conversation
  belongs_to :user
  # belongs_to :task, through: :conversation
# end

validates :text, presence: true, length: {in: 1..MESSAGE_MAX_SIZE, message: "Message shoud be less than #{MESSAGE_MAX_SIZE} characters and cannot be empty"}

attribute :interlocutor

after_initialize do |message|
  # self.locutor = message.user
  locutor = message.user
  requestor = message.conversation.task.user
  volunteer = message.conversation.user
  message.interlocutor =  if locutor == volunteer 
    requestor
    else 
      volunteer 
    end
end

after_save do |message|
  message.conversation.touch
end


end


# TODO after migration add logic for last_seen_at

# Messages are almost read only. They cannot be deleted by user, but are deleted with parent conversation on delete
# A messages is "removed" by updating its content with MESSAGE_REMOVAL_MESSAGE
# before_delete...

# A message belongs to a conversation message.conversation # message_conversation = Conversation.find(message/self.conversation_id)
# A message is about a task message.conversation.task message_task = Task.find(message_conversation.task_id)

# A message can belong to either the volunteer or the requestor 
# ... message_volunteer = User(Conversation(message/self.conversation_id).user_id)
# ... or message_volunteer = User(message_conversation.user_id)
# ... message_requestor = User(Task(Conversation(message/self.conversation_id).task_id).user_id) // message.user.id and one through message->conversation->task->user_id
# ... or message_requestor = User(message_task.user_id)
# attribute :locutor

# a message has a locutor and interlocutor.
# The message locutor is message_locutor = User.find(message/self.user_id)
# The message interlocutor is the other user i.e is message_volunteer if != message_locutor or message_requestor if != message_locutor
# message validate that it can only be created/updated by a requestor or a volunteer or by MRBOT system user (user 0)...
# ... i.e message.user_id must belong to [volunteer.id, requestor.id, MRBOT.id]


# a message can only be (listed/indexed?? TODO NOTE) created/updated if message_conversation.is_active = true

# after_find do |message|
#   # self.locutor = message.user
#   locutor = message.user
#   requestor = message.conversation.task.user
#   volunteer = message.conversation.user
#   message.interlocutor =  if locutor == volunteer 
#     requestor
#     else 
#       volunteer 
#     end
# end
