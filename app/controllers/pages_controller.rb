class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:inside]

  def start
  end
  
  def terms
  end
  
  def show_task
  end
  
  def inside
  end
  
end
