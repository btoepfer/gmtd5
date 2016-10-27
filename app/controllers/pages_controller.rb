class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:inside]

  def start
  end
  
  def terms
  end
  
  def tasks
  end
  
  def show_task
    render component: 'Task', props: { title: "Servertask", content: "Serverinhalt", dueDate: "25.10.2016" }, tag: 'span', class: 'todo'
  end
  
  def inside
  end
  
end
