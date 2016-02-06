class NotesController < ApplicationController

  # Index bzw. Suchmaske
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
  
  # Detailanzeige
  def show
    @note = find_note(params[:id])
  end
  
  # Notiz bearbeiten
  def edit
    @note = find_note(params[:id])
  end
  
  # Update durchführen
  def update
    @note = find_note(params[:id])
    if @note.update(note_params)
      flash[:notice] = "Note '#{@note.title}' has been successfully updated."
      redirect_to @note
    end 
  end
  
  # Neue Notiz anlegen
  def new
    @note = Note.new
    @note.user_id = current_user.id
  end
  
  # Insert durchführen
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    if @note.save(note_params)
      flash[:notice] = "Note '#{@note.title}' has been successfully created."
      redirect_to @note
    end 
  end
  
  # Private Methoden
  private
  def find_note(id)
    # Auch wenn wir eine konkrete Notiz anzeigen, müssen wir prüfen, ob diese
    # dem angemeldeten User gehört.
    note = Note.where("id = ? and user_id = ?", id, current_user.id).take
  end
  
  def note_params
    params.require(:note).permit(:title, :content)
  end
end
