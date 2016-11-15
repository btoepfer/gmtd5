class TasksController < ApplicationController
  COLUMN_TITLES = ["<i class='fa fa-square-o'></i>&nbsp;To Do", "<i class='fa fa-pencil-square-o'></i>&nbsp;In Arbeit","<i class='fa fa-check-square-o'></i>&nbsp;Erledigt",]
  
  before_action :authenticate_user!
  
  def index
    @tasks = current_user.tasks.order(status: :asc)
    @column_titles = COLUMN_TITLES
  end
  
  def update_status
    @task = Task.find(params[:id])
    @task.status = params[:status]
    @task.save!
    head :ok
  end
  
end
