class ConversationsController < ApplicationController
  include Project8Constants

  before_action :authenticate_user!
  before_action :set_conversation, only: %i[ show update destroy ]
  before_action :set_task, only: %i[create update] # show update destroy]
  before_action :set_current_attributes_params #, only: %i[index user]

  # GET /conversations
  # GET /conversations.json
  def index
    @conversations_as_volunteer = current_user.conversations #.where(is_active: true)
    @conversations_as_requestor = Conversation.where(task_id: current_user.task_ids) #Conversation.find_by(task_id: current_user.task_ids)  
    @user_role_as_volunteer = USER_ROLE_AS_VOLUNTEER
    @user_role_as_requestor = USER_ROLE_AS_REQUESTOR
    @user_role_as_undefined = USER_ROLE_AS_UNDEFINED
  end

  # GET /conversations/user
  # GET conversations associated with current_user, both as volunteer and requestor
  def user
    @conversations_as_volunteer = current_user.conversations
    @conversations_as_requestor = Conversation.where(task_id: current_user.task_ids)
    @user_role_as_volunteer = USER_ROLE_AS_VOLUNTEER
    @user_role_as_requestor = USER_ROLE_AS_REQUESTOR
    @user_role_as_undefined = USER_ROLE_AS_UNDEFINED
  end

  # GET /conversations/dump
  def dump
    # @conversations = Conversation.all
    # @conversations = current_user.conversations
    # @requestors = @conversations.task.user
    # @conversations_as_volunteer = current_user.conversations.map{|c| c.presence.to_h.merge({user_role: USER_AS_VOLUNTEER})}
    @conversations_as_volunteer = current_user.conversations
    # @conversations_as_requestor = Conversation.find_by(task_id: current_user.task_ids).map{|c| c.merge({user_role: USER_AS_REQUESTOR})}
    @conversations_as_requestor = Conversation.where(task_id: current_user.task_ids)
    # @conversations_as_requestor = Array.wrap(Conversation.find_by(task: current_user.tasks))
    # @conversations = @conversations_as_volunteer.concat(@conversations_as_requestor)
    @user_role_as_volunteer = USER_ROLE_AS_VOLUNTEER
    @user_role_as_requestor = USER_ROLE_AS_REQUESTOR
    @user_role_as_undefined = USER_ROLE_AS_UNDEFINED
  end

  # GET /conversations/changes
  # using last logged in timestamp vs most recent conversation timestamp, notification
  def changes
    @conversations_as_volunteer = current_user.conversations
                                              .where('updated_at > ?', params_since[:since])
                                              .or
                                              .where('updated_at > ?', params_since[:since])
    @conversations_as_requestor = Conversation.where(task_id: current_user.task_ids)
                                              .where('updated_at > ?', params_since[:since])
                                              .or
                                              .where('updated_at > ?', params_since[:since])
    @user_role_as_volunteer = USER_ROLE_AS_VOLUNTEER
    @user_role_as_requestor = USER_ROLE_AS_REQUESTOR
    @user_role_as_undefined = USER_ROLE_AS_UNDEFINED
    @since_timestamp = params_since[:since]
  end

  # GET /conversations/stats
  def stats
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @conversation = set_conversation
    @task = @conversation.task unless @task.present?
    # @messages = @conversation.messages.order('created_by asc')
    @user_role_as_volunteer = USER_ROLE_AS_VOLUNTEER
    @user_role_as_requestor = USER_ROLE_AS_REQUESTOR
    @user_role_as_undefined = USER_ROLE_AS_UNDEFINED
    @user_role = if current_user == @conversation.user
                   USER_ROLE_AS_VOLUNTEER
                 elsif current_user == @conversation.task.user
                   USER_ROLE_AS_REQUESTOR
                 else
                   USER_ROLE_AS_UNDEFINED
                 end
  end

  # POST /conversations
  # POST /conversations.json
  # A conversation is created by the current_user...
  # ... (logged in user, from userProfile.id on the front end)
  # ... about a task_id. Thus conversation_params must bring back current_user instead of user_id for create
  def create
    @conversation = Conversation.new(params_as_current_user)
    # @requestor = @task.user
    if @conversation.save
      @conversation.task.touch
      @conversation.messages
                   .create(user: current_user, text: "AUTOMATED MESSAGE: user #{current_user.preferred_name} started a conversation about your request id #{@conversation.task_id}, #{@conversation.task.title}")
      render :show, status: :created, location: @conversation
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    if @conversation.is_active && current_user_is_authorized_to_update && !@conversation.readonly? && @conversation.update(conversation_update_params)
      @conversation.task.touch
      render :show, status: :ok, location: @conversation
    elsif !current_user_is_authorized_to_update || @conversation.readonly?
      render json: @conversation.errors, status: :unauthorized
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def current_user_is_authorized_to_update
    if @conversation.user_id == current_user.id || @conversation.task.user_id == current_user.id then
      true
    else
      false
    end
  end

  def set_task
    if conversation_params[:task_id].blank?
      @task = @conversation.task
    else
      @task = Task.find_by(id: conversation_params[:task_id].to_i)
      # puts @task.inspect
    end
  end

  def conversations_about_task
    Task.find(params[:task_id].to_i).conversations unless params[:task_id].blank?
  end

  def set_conversation_task
    Task.find(params[:task_id].to_i) unless params[:task_id].blank? #else nil end
  end

  # Only allow a list of trusted parameters through.
  def conversation_params
    params.require(:conversation).permit(:is_active, :task_id, :user_id)
  end

  def conversation_update_params
    params.require(:conversation).permit(:is_active)
  end

  # Only allow a list of trusted parameters through; adding :since for last update
  def params_since
    params.require(:conversation).permit(:is_active, :task_id, :user_id, :since)
  end

  # A conversation is created by the current_user...
  # ... (logged in user, from userProfile.id on the f_e)
  # ... about a task_id
  # Only allow a list of trusted parameters through / create conversation case.
  def params_as_current_user
    params.require(:conversation).permit(:is_active, :task_id)
          .merge(user_id: current_user.id)
  end

  def set_current_attributes_params
    Current.set_user = current_user
  end

end
