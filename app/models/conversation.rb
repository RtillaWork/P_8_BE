class Conversation < ApplicationRecord
  include Project8Constants

  belongs_to :task
  validates :task, :presence => true

  belongs_to :user
  validates :user, :presence => true
  # belongs_to :user, through: :task
  has_many :messages, dependent: :delete_all

  validate :five_active_conversations_max_per_task, on: :create
  validate :user_cannot_create_a_conversation_about_own_task, on: :create
  validate :conversation_can_only_be_started_for_published_task, on: :create
  validate :conversation_can_only_be_started_for_unfullfilled_task, on: :create
  validate :user_can_create_only_one_conversation_per_task, on: :create

  before_create :ensure_sane_defaults
  before_save :ensure_is_not_active_is_final
  # after_find :ensure_is_not_active_is_final
  # after_initialize
  # after_find do |conversation|
  #   unless conversation.is_active
  #     conversation.readonly!
  #   end 
  # end

  # attribute :current_user_role, :string
  attribute :volunteer # volunteer= User(conversation/self.user_id)
  attribute :requestor # requestor = User(Task.find(conversation/self.task_id).user_id)  
  # attribute :most_recent_conversation_message # all_messages_asc.last

  after_initialize do |conversation|
    # conversation.freeze unless conversation.is_active
    conversation.volunteer = conversation.user # User.find(conversation.user_id) 
    conversation.requestor = conversation.task.user # User.find(conversation.task.user_id)  # User.find(conversation_task.user_id)

  end

  private

  def user_cannot_create_a_conversation_about_own_task
    errors.add(:conversation, "Cannot create conversation about current_user's own request") if self.user_id == self.task.user_id
  end

  def user_can_create_only_one_conversation_per_task
    if self.task.authz_volunteer_ids.include?(self.user.id) || self.task.inactive_conversation_ids.include?(self.user.id) then
      errors.add(:conversation, "Cannot create more than 1 conversation about a request")
    end
  end

  # def authz_users_and_owner_only_can_update_a_conversation_about_associated_task
  #   errors.add(:conversation, "Cannot update a conversation unless in authorized list for a request") if self.task.authz_volunteer_ids.include?(Current.user.id) || Current.user.id == self.user_id
  # end

  def conversation_can_only_be_started_for_published_task
    errors.add(:conversation, "Cannot create conversation for unpublished request") unless self.task.is_published
  end

  def conversation_can_only_be_started_for_unfullfilled_task
    errors.add(:conversation, "Cannot create conversation for already fullfilled request") if self.task.is_fullfilled
  end

  def ensure_sane_defaults
    self.is_active = true
    return true
  end

  def ensure_is_not_active_is_final
    errors.add(:conversation, "Cannot re-activate conversation after leaving the chat. Please pick a different request to offer help") if self.is_active == false
    return false
  end

  def five_active_conversations_max_per_task
    if self.task.authz_volunteer_ids.count >= MAX_ACTIVE_CONVERSATIONS_PER_TASK then
      errors.add(:conversation, "Maximum of #{MAX_ACTIVE_CONVERSATIONS_PER_TASK} conversation per request")
    end
  end
end

# A conversation is always initiated by a volunteer = User(conversation.user_id),...
#... about a task/request created by a requestor requestor = User((Task(conversation.task_id).user_id)

# before_create validate Task.find(task_id).is_published = true and Task.find(task_id).is_fullfiled = false

# before_create validate Task.find(task_id).active_conversations < MAX_ACTIVE_CONVERSATIONS_PER_TASK
# if validation fails error MAX_ACTIVE_CONVERSATIONS_PER_TASK reached

# if is_active = false and an event is about to change it to true...
# ... validate Task.find(task_id).active_conversations < MAX_ACTIVE_CONVERSATIONS_PER_TASK
# if validation fails error MAX_ACTIVE_CONVERSATIONS_PER_TASK reached cannot reactivate/rejoin chat for now

# Conversation starts as is_active, all_message count == 0

# there must be at least 1 message before the CONVERSATION_MAX_INACTIVITY_PERIOD for the conversation to not be automatically deactivated
# if there is >= 1 messages (DateTime.now - most_recent_conversation_message.created_at = time_lapsed) must be less than CONVERSATION_MAX_INACTIVITY_PERIOD*6 for the conversation to not be automatially deactivated

# if all_message count == 0 and (Datetime.now - conversation/self.created_at = time_lapsed) >= CONVERSATION_MAX_INACTIVITY_PERIOD/2 && time_lapsed < CONVERSATION_MAX_INACTIVITY_PERIOD/2
## then Message(:mrbot_user, conversation/self, "#{MRBOT_USER_NOTICE}: #{CONVERSATION_MAX_INACTIVITY_PERIOD_MESSAGE}. Time remaining: #{CONVERSATION_MAX_INACTIVITY_PERIOD - time_lapsed})
## else
### Message(:mrbot_user, conversation/self, "#{MRBOT_USER_NOTICE}: "Deactivating inactive conversation.")
### conversation/self.is_active = false
## end if

# both requestor and volunteer can deactivate aka leave the conversation anytime
# neither can rejoin the conversation before CONVERSATION_MIN_REACTIVATION_WAITING_PERIOD
# i.e can't rejoin if (DateTime.now - conversation/self.updated_at) < CONVERSATION_MIN_REACTIVATION_WAITING_PERIOD

# if is_active = false, conversation's messages cannot be created/added/updated

