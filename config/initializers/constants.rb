module Project8Constants
  # NOTE Multiple constants used all over the application.
  # NOTE Must be in all CAPS. To CONSTANT in models declare it with attr_accessor or attr_reader
  # Coordinates related, in User, Task and global state/session
  INFINITY_RADIUS = 30000000.0 # in meters
  MAX_RADIUS = INFINITY_RADIUS
  APP_DEFAULT_LAT = 0.1
  APP_DEFAULT_LNG = 0.1
  APP_DEFAULT_RADIUS = INFINITY_RADIUS
  MIN_LATITUDE = -90.0
  MAX_LATITUDE = 90.0
  MIN_LONGITUDE = -180.0
  MAX_LONGITUDE = 180.0
  # to fix a PG error ERROR:  operator does not exist: timestamp without time zone >= integer
  MIN_TIME_IN_MILISEC = 0 # (Time.new(1970,1,1,0,0,0).to_f).round

  # Task/Request related
  MAX_ACTIVE_CONVERSATIONS_PER_TASK = 5
  LOCK_COUNT = MAX_ACTIVE_CONVERSATIONS_PER_TASK
  REPUBLISHING_WAITING_PERIOD = 24.hours # 24.seconds # 24.hours
  UNPUBLISH_AFTER_CREATE_DELAY = 24.hours # 180.seconds # 24 hours
  ONE_TIME_TASK = 'OTT' #'one_time_task' # 1
  MATERIAL_NEED = 'MN' #'material need' # 2
  # Conversation/offer of help related
  USER_ROLE_AS_VOLUNTEER = 'VOLUNTEER'
  USER_ROLE_AS_REQUESTOR = 'REQUESTOR'
  USER_ROLE_AS_OTHER = 'OTHER'
  USER_ROLE_AS_UNDEFINED = 'UNDEFINED' # This is supposed to be a validation/state error
  CONVERSATION_MAX_INACTIVITY_PERIOD = 12.hours
  CONVERSATION_MIN_REACTIVATION_WAITING_PERIOD = 1.hour
  # Message related
  MESSAGE_MAX_SIZE = 280 #characters
  MRBOT_USER_NOTICE = "THIS SYSTEM NOTICE FROM MR BOT"
  CONVERSATION_MAX_INACTIVITY_PERIOD_MESSAGE = "THIS CONVERSATION HAS 0 MESSAGES AND IS ABOUT TO GET DEACTIVATED"
  MESSAGE_REMOVAL_MESSAGE = "THIS MESSAGE HAS BEEN REMOVED BY USER" # for f-e message removal feature, updates message with this
end



