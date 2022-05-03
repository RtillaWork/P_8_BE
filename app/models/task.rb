class Task < ApplicationRecord

  belongs_to :user
  has_many :conversations, dependent: :destroy
  has_many :users, through: :conversations
  has_many :messages, through: :conversation #, dependent: :delete_all

  validates :title, presence: true, length: { in: 1..64, message: "Message shoud be less than 64 characters and cannot be empty" }
  validates :description, presence: true, length: { in: 1..300, message: "Description shoud be less than 300 characters and cannot be empty" }
  # validates :kind, presence: true, inclusion: {in: [ONE_TIME_TASK, MATERIAL_NEED], message: "Please select either One Time Task or Material Need"}
  validates :lat, presence: true, numericality: { greater_than_or_equal_to: MIN_LATITUDE, less_than_or_equal_to: MAX_LATITUDE, message: "Latitude out of range" }
  validates :lng, presence: true, numericality: { greater_than_or_equal_to: MIN_LONGITUDE, less_than_or_equal_to: MAX_LONGITUDE, message: "Longitude out of range" }

  attribute :distance, :float
  attribute :is_within_radius, :boolean
  attribute :is_republishable, :boolean # based on REPUBLISHING_WAITING_PERIOD
  attribute :republishable_start_time
  attribute :active_conversation_ids, array: true, default: [] # NOTE: array is Postgresql only
  attribute :inactive_conversation_ids, array: true, default: [] # NOTE: array is Postgresql only
  attribute :authz_volunteer_ids, array: true, default: [] # NOTE: array is Postgresql only
  attribute :is_fullfilling, :boolean # makes it unpublished, or not displayed

  after_find do |task|
    # NOTE: when task.lat/lng are nil, they default to owner/requestor.lat/lng, rescue default APP LAT, LNG
    task.distance = distance_between(task.lat, task.lng, Current.lat || APP_DEFAULT_LAT, Current.lng || APP_DEFAULT_LNG)
    task.is_within_radius = (task.distance <= (Current.radius || APP_DEFAULT_RADIUS))
  end

  # after_find :ensure_fullfilled_task_is_readonly
  after_find :set_is_republishable_flag
  after_find :set_republishable_start_time

  after_initialize :set_conversations_state
  after_initialize :set_is_being_fullfilled
  # after_initialize :set_delayed_unfullfilled_unpublished_state

  before_create :ensure_default_state
  before_save :ensure_is_fullfilled_changes_state
  before_save :set_unpublished_at
  after_initialize :ensure_being_fullfilled_state

  after_find :set_delayed_unfullfilled_unpublished_state

  # validate :cannot_have_more_active_conversations_than_max_per_task, unless: :active_conversations_count.blank?, on: :update
  validate :cannot_have_more_active_conversations_than_max_per_task #, on: [:update, :save]
  validate :cannot_be_updated_after_fullfilled #, on: [:update, :save]
  # validate :cannot_be_published_after_fullfilled #, on: [:update, :save]
  # validate :cannot_be_published_if_is_fullfilling, unless: :active_conversations_count.blank?, on: [:update, :save]
  # validate :cannot_be_published_if_is_fullfilling, unless: :authz_volunteer_ids.blank?, on: [:update, :save]
  # - validate :cannot_be_republished_before_the_waiting_period, on: [:update, :save] 
  # validate :cannot_mark_fullfilled_unless_authz_user_or_owner, on: :update # NOTE belongs to the controller
  # TODO: validate  task.unpublished_at > task.updated_at || task.unpublished_at is NULL 

  scope :published, -> { where(is_published: true) }
  scope :unpublished, -> { where(is_published: false) }
  scope :fullfilled, -> { where(is_fullfilled: true) }
  scope :unfullfilled, -> { where(is_fullfilled: false) }
  scope :open, -> { where(is_published: true).where(is_fullfilled: false) }
  scope :closed, -> { where(is_published: false).where(is_fullfilled: false) }
  scope :by_distance, -> { to_a.sort_by(&:distance) }
  scope :are_within_radius, -> { to_a.filter { |t| t.is_within_radius } }
  scope :within_radius_by_distance, -> { to_a.filter { |t| t.is_within_radius }.to_a.sort_by(&:distance) }

  private

  def ensure_fullfilled_task_is_readonly
    if self.is_fullfilled then
      self.readonly!
      return false
    else
      return true
    end
  end

  def ensure_default_state
    self.is_fullfilled = false
    self.is_published = true
    self.unpublished_at = nil
    return true
  end

  def ensure_is_fullfilled_changes_state
    if self.is_fullfilled then
      self.is_published = false
      self.unpublished_at = Time.current
      # set all related conversations to inactive
      Conversation.where(id: self.active_conversation_ids).each do |c|
        c.is_active = false
        c.save
      end
      # self.save
    end
    return true
  end

  def ensure_being_fullfilled_state
    if self.is_fullfilling then
      self.is_published = false
      self.unpublished_at = Time.current
      # self.touch
      self.save
    end
    return true
  end

  def set_unpublished_at
    if !self.is_published && self.unpublished_at.blank?
      self.unpublished_at = Time.current
      self.save
    end
    return true
  end

  def set_is_republishable_flag
    if !self.is_published && self.unpublished_at.present? && (Time.current - self.unpublished_at) > REPUBLISHING_WAITING_PERIOD
      self.is_republishable = true
      # self.unpublished_at = null not necessary
      # self.touch
      # self.save
    else
      self.is_republishable = false
    end
    return true
  end

  def set_republishable_start_time
    self.republishable_start_time = if self.is_republishable then
                                      MIN_TIME_IN_MILISEC
                                    else
                                      # Math.abs(REPUBLISHING_WAITING_PERIOD - Time.current + self.unpublished_at) unless sefl.unpublished_at.blank? rescue MIN_TIME_IN_MILISEC
                                      (REPUBLISHING_WAITING_PERIOD - Time.current + self.unpublished_at) unless sefl.unpublished_at.blank? rescue MIN_TIME_IN_MILISEC
                                    end
    return true
  end

  def set_conversations_state
    active_conversations = self.conversations.where(is_active: true)
    self.active_conversation_ids = active_conversations.map { |c| c.id }
    self.authz_volunteer_ids = active_conversations.map { |c| c.user_id }
    self.inactive_conversation_ids = self.conversations.where(is_active: false).map { |c| c.id } # CORRECT BUG, was before map {|c| c.user_id }
    return true
  end

  def set_is_being_fullfilled
    if self.is_published then
      self.is_fullfilling = (self.authz_volunteer_ids.count >= MAX_ACTIVE_CONVERSATIONS_PER_TASK)
    else
      # acts as a latch: stays true until 0 active/authorized conversations/users
      self.is_fullfilling &= (self.authz_volunteer_ids.count >= 1)
    end
    return true
  end

  def set_delayed_unfullfilled_unpublished_state
    # puts "DEBUG DEBUG DEBUG SET DELAYED UNFULLFILLED UNPUBLISHED STATE"
    # puts (Time.current - self.created_at.to_i) # > UNPUBLISH_AFTER_CREATE_DELAY
    #     puts "DEBUG DEBUG DEBUG SET DELAYED UNFULLFILLED UNPUBLISHED STATE"
    # if self.is_published && Math.abs(Time.current - self.created_at) > UNPUBLISH_AFTER_CREATE_DELAY
    if self.is_published && !self.is_fullfilling && (Time.current - self.created_at) > UNPUBLISH_AFTER_CREATE_DELAY
      self.created_at = Time.current
      self.updated_at = Time.current + 1
      self.is_published = false
      self.unpublished_at = Time.current
      self.save
    end
    return true
  end

  # conversation.is_active when non-empty with one message at least
  def cannot_have_more_active_conversations_than_max_per_task
    if self.authz_volunteer_ids.count > MAX_ACTIVE_CONVERSATIONS_PER_TASK #self.task.conversations.where(is_active: true).count > MAX_ACTIVE_CONVERSATIONS_PER_TASK  # 
      errors.add(:task, "Cannot have more than #{MAX_ACTIVE_CONVERSATIONS_PER_TASK} maximum active conversations per request")
    end
  end

  def cannot_be_updated_after_fullfilled
    if self.readonly?
      errors.add(:task, "Cannot be updated after fullfilled: is now read-only.")
    end
  end

  def cannot_be_published_after_fullfilled
    if self.is_fullfilled && self.is_published
      errors.add(:task, "Cannot be published and fullfilled at once")
    end
  end

  def cannot_be_published_if_is_fullfilling
  end

  def cannot_be_republished_before_the_waiting_period
    return if self.is_fullfilled
    unless self.is_republishable && !self.is_published
      errors.add(:task, "Cannot be republished before the wating period. Republishable on: #{self.republishable_start_time }")
    end
  end

  # Latitude/Longitude distance approximation based on Haversine Lat/Lng Distance Calculation
  def distance_between(lata, lnga, latb, lngb)
    d_lat = (latb - lata) * Math::PI / 180
    d_lng = (lngb - lnga) * Math::PI / 180
    a = Math.sin(d_lat / 2) ** 2 + Math.cos(lata * Math::PI / 180) * Math.cos(latb * Math::PI / 180) * Math.sin(d_lng / 2) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    # returns distance in meters
    d = 6371 * c * 1000
  end
end



