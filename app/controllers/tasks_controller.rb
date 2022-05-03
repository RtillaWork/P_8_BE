class TasksController < ApplicationController
  include Project8Constants

  before_action :authenticate_user!
  before_action :set_task, only: %i[ show update destroy] #conversation ]
  before_action :set_current_attributes_params, only: %i[index user]

  # GET /tasks
  # GET /tasks.json
  def index
    # NOTE this relies on created_at and updated_at being independely modified...
    # ...i.e does not include the case where both change at the same time for the same operation

    # all the open created tasks after our timestamp
    @created = Task.all.open.where.not(user: current_user).where("created_at >= ?", since)
                   .within_radius_by_distance
    # all the tasks updated since this timestamp including 
    @updated = Task.all.where.not(user: current_user).where("updated_at >= ? AND updated_at > created_at", since)
                   .within_radius_by_distance
    @query_since = since
  end

  # GET /tasks/dump?lat=&lng=&radius=
  # GET /tasks/dump.json
  def dump
    @tasks = Task.all.order('created_at asc')
    @query_radius = Current.radius
    @query_lat = Current.lat
    @query_lng = Current.lng
    @query_since = since
  end

  # GET /tasks/user?user_id=
  # GET /tasks/user.json
  def user
    # return current_user's all tasks
    @tasks = Task.all.where(user: current_user).order('updated_at asc') #.by_distance
  end

  # GET /tasks/changes?since=
  # GET /tasks/changes.json
  def changes
    # NOTE this relies on created_at and updated_at being independely modified...
    # ...i.e does not include the case where both change at the same time for teh same operation

    # all the open created tasks after our timestamp
    @created = Task.all.open.where.not(user: current_user).where("created_at >= ?", since)
                   .within_radius_by_distance
    # all the tasks updated since this timestamp including 
    @updated = Task.all.where.not(user: current_user).where("updated_at >= ?", since)
                   .within_radius_by_distance

    @query_since = since
  end

  # GET /tasks/stats
  # GET /tasks/stats.json
  def stats
    @current_time_stamp = Time.current.to_f
    @current_time = Time.current
    @total_task_count = Task.all.count
    @unfullfilled_task_count = Task.all.unfullfilled.count
    @fullfilled_task_count = Task.all.fullfilled.count
    @unpublished_task_count = Task.all.unpublished.count
    @published_task_count = Task.all.published.count
    @open_task_count = Task.all.open.count
    @closed_task_count = Task.all.closed.count
    @total_profile_task_count = Task.where(user: current_user).count
    @open_profile_task_count = Task.all.open.where(user: current_user).count

    @last_created_task = Task.all.order("created_at asc").last || Task.none
    @last_updated_task = Task.all.where('updated_at > created_at').order("updated_at asc").last || Task.none

  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    if @task.user_id == current_user.id then
      @current_user_role = USER_ROLE_AS_REQUESTOR
      @current_conversation_id = nil # Conversation.none
    elsif @task.authz_volunteer_ids.include?(current_user.id) then
      @current_user_role = USER_ROLE_AS_VOLUNTEER
      @current_conversation_id = current_user.conversations.find_by(task: @task).id
    else
      @current_user_role = USER_ROLE_AS_OTHER
      @current_conversation_id = nil # Conversation.none
    end
  end

  # POST /tasks
  # POST /tasks.json
  # A task is created by the current_user...
  # ... (logged in user, from userProfile.id on the f_e)
  # ...  Thus conversation_params must bring back current_user instead of user_id for create
  def create
    # @task = Task.new(params_for_creating_as_current_user)
    @task = Task.new(params_for_creating_as_current_user_with_coords)
    if @task.save
      render :show, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if !@task.is_fullfilled && @task.update(params_user_for_updating)
      render :show, status: :ok, location: @task
    else
      render json: @task.errors, status: :unauthorized
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    # NOTE: Only requestor/owner can delete their own task
    if @task.user_id == current_user.id && @task.is_fullfilled
      @task.destroy
    else
      render json: @task.errors, status: :unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find_by(id: params[:id])
    # puts @task.inspect
  end

  def current_user_is_authorized_to_update
    if @task.user_id == current_user.id || @task.authz_volunteer_ids.include?(current_user.id)
      true
    else
      false
    end
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :kind, :is_published, :is_fullfilled, :lat, :lng, :radius, :user_id, :since)
  end

  def params_user_id
    if params[:user_id].present? #&& params[:user_id].is_a?(Numeric)
      params[:user_id].to_i
    else
      nil
    end
  end

  def params_user
    User.find_by(id: params_user_id)
  end

  def params_coords
    if params[:lat].present? && params[:lng].present? # && params[:lat].is_a?(Numeric) && params[:lng].is_a?(Numeric)
      { lat: params[:lat].to_f, lng: params[:lng].to_f }
    else
      nil
    end
  end

  def params_coords_rescue_with_defaults
    if params[:lat].present? && params[:lng].present? # && params[:lat].is_a?(Numeric) && params[:lng].is_a?(Numeric)
      { lat: params[:lat].to_f, lng: params[:lng].to_f }
    else
      { lat: current_user.default_lat.to_f, lng: current_user.default_lng.to_f }
    end
  end

  def params_radius
    if params[:radius].present? # && params[:radius].is_a?(Numeric)
      params[:radius].to_f
    else
      MAX_RADIUS
    end
  end

  # A task is created by the current_user...
  # ... (logged in user, from userProfile.id on the f_e)
  # ...  Thus conversation_params must bring back current_user instead of user_id for create
  # Only allow a list of trusted parameters through / create conversation case.
  def params_for_creating_as_current_user
    # task_params.permit(:title, :description, :kind, :is_published, :is_fullfilled, :lat, :lng)
    params.require(:task).permit(:title, :description, :kind, :is_published, :is_fullfilled, :lat, :lng)
          .merge(user_id: current_user.id)
  end

  def params_for_creating_as_current_user_with_coords
    params_for_creating_as_current_user.merge(params_coords_rescue_with_defaults)
  end

  def params_for_updating_as_requestor
    params.require(:task).permit(:is_published, :is_fullfilled)
    # .merge(user_id: current_user.id)
  end

  def params_for_updating_as_volunteer
    params.require(:task).permit(:is_fullfilled)
    # .merge(user_id: params_user_id)
  end

  def params_user_for_updating
    if @task.user_id == current_user.id then
      params_for_updating_as_requestor
    elsif @task.authz_volunteer_ids.include?(current_user.id) # if current user is in the list of authorized fullfillers
      params_for_updating_as_volunteer
    else
      @task.errors.add(:task, "Arbitrary user is not on active chats and is not authorized to mark task as fullfilled")
      {}
      # render json: @task.errors, status: :unprocessable_entity  # or :unauthorized?
    end
  end

  def since
    # :timestamp is expected to be in miliseconds from JS Date.now(), has to be converted to fractional seconds
    if params[:since].present? # && params[:lat].is_a?(Numeric) && params[:lng].is_a?(Numeric)
      Time.at((params[:since].to_f) / 1000)
    else
      Time.at(MIN_TIME_IN_MILISEC)
    end
  end

  def set_current_attributes_params
    # params.present? && params[:task].present? && params[:task][:lat].present? && params[:task][:lng].present?
    Current.params_coords = params_coords #  {lat: 1.1, lng: 1.2}
    Current.radius = params_radius
  end
end
