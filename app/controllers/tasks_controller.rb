class TasksController < ApplicationController
  COLUMN_TITLES = ["<i class='fa fa-square-o'></i>&nbsp;To Do", "<i class='fa fa-pencil-square-o'></i>&nbsp;In Arbeit","<i class='fa fa-check-square-o'></i>&nbsp;Erledigt",]
  
  before_action :authenticate_user!
  
  def index
    @tasks = current_user.tasks.order(status: :asc)
    @column_titles = COLUMN_TITLES
  end
end
