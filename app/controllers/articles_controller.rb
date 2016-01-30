class ArticlesController < ApplicationController

  def index
    where = []
    like_or_equal = "="
    if params[:s].present?
      @keywords = params[:s]
      
      # Enthält der Suchbegriff ein "*", dann suchen wir mit "like"
      like_or_equal = "like" if @keywords.include? '*'
      
      title_search = @keywords.upcase.gsub('*','%')
      content_search = "%"+title_search+"%"
      
      # upcase, damit Groß-/Kleinschreibung ignoriert wird, "*" wird durch "%" ersetzt
      where_clause = ["user_id = ? and (upper(title) #{like_or_equal} ? or upper(content) like ?)", current_user.id, title_search, content_search]
      
      @articles = Article.where(where_clause)
      
    else
      @articles = []
    end
  end
end
