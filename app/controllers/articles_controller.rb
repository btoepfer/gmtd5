class ArticlesController < ApplicationController

  def index
    if params[:s].present?
      @keywords = params[:s]
      @articles = Article.where(["title = ?", @keywords])
    else
      @articles = []
    end
  end
end
