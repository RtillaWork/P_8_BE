class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[ show update destroy ]
  before_action :set_message_context, only: %i[index show create update destroy ]
  before_action :is_current_user_a_party, only: %i[index show create update destroy ]

  # GET /messages
  # GET /messages.json
  def index
    if is_current_user_a_party then
      @messages = @conversation.messages.order("created_at asc") #Conversation.find_by(id: params[:conversation_id]).messages.order("created_at asc")
    else
      # No conversation context, then return all current user's messages regardless of params
      @messages = current_user.messages.order("created_at asc")
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params_as_current_user)
    if @message.save
      # @message.conversation.touch
      render :show, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    # NOTE No update route
    # if @message.update(message_params_as_current_user)
    #   render :show, status: :ok, location: @message
    # else
    #   render json: @message.errors, status: :unprocessable_entity
    # end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    # @message.conversation.touch
    @message.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  def set_message_context
    @conversation = if params[:conversation_id].present? then
                      Conversation.find_by(id: params[:conversation_id].to_i)
                    else
                      nil
                    end
    @task = if @conversation.present? then
              @conversation.task
            else
              nil
            end
  end

  def is_current_user_a_party
    # PRIVACY: conversation must related to current_user...
    # ...either as a volunteer Conversation.user_id or...
    # ... as a requestor Conversation.task.user_id.
    if @task.present? && @conversation.present? then
      return (@conversation.user_id == current_user.id) || (@task.user_id == current_user.id)
    else
      false
    end
  end

  def message_params_as_current_user
    if is_current_user_a_party
      message_params.merge(user_id: current_user.id)
    else
      nil
    end
  end

  def params_conversation_id
    if params[:conversation_id].present? then
      params[:conversation_id].to_i
    else
      nil
    end
  end

  # Only allow a list of trusted parameters through.
  def message_params
    # p=params.require(:message).permit(:text, :conversation_id, :user_id)
    params.require(:message).permit(:text, :conversation_id)
  end

  def set_messages_of_conversation
    @messages = Message.find(Conversation: params[:conversation_id])
  end

  def set_messages_of_user
    @message = Message.find(User: params[:user_id])
  end

end
