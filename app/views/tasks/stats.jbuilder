# stats about tasks

json.stats do
  json.current_time_stamp @current_time_stamp
  json.current_time @current_time
  json.total_task_count @total_task_count
  json.open_task_count @open_task_count
  json.closed_task_count @closed_task_count
  json.unfullfilled_task_count @unfullfilled_task_count
  json.fullfilled_task_count @fullfilled_task_count
  json.unpublished_task_count @unpublished_task_count
  json.published_task_count @published_task_count
  json.total_profile_task_count @total_profile_task_count
  json.open_profile_task_count @open_profile_task_count

  json.last_created_task do
    if @last_created_task.present? then
      json.partial! "tasks/task", task: @last_created_task
    else
      json.null!
    end
  end

  json.last_updated_task do
    if @last_updated_task.present? then
      json.partial! "tasks/task", task: @last_updated_task
    else
      json.null!
    end
  end
end