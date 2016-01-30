class ArticlesController < ApplicationController

  def index
    where = []
    like_or_equal = "="
    if params[:s].present?
      @keywords = params[:s]
      like_or_equal = "like" if @keywords.include? '*'
      where_clause = ["user_id = ? and upper(title) #{like_or_equal} ?", current_user.id, @keywords.upcase.gsub('*','%')]
      @articles = Article.where(where_clause)
    else
      @articles = []
    end
  end
end
