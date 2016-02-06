class NotesController < ApplicationController

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
      
      @notes = Note.where(where_clause).order(created_at: :desc).limit(10)
      
    else
      @notes = []
    end
  end
  
  def show
    notes = []
    # Auch wenn wir eine konkrete Notiz anzeigen, müssen wir prüfen, ob diese
    # dem angemeldeten User gehört.
    notes = Note.where("id = ? and user_id = ?", params[:id].to_i, current_user.id)
    @note = notes[0]
  end
end
