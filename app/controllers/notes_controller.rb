
class NotesController < ApplicationController

  # Index bzw. Suchmaske
  def index
    where = []
    like_or_equal = "="
    if params[:s].present?
      @keywords = params[:s]
      
      # Enthält der Suchbegriff ein "*", dann suchen wir mit "like"
      like_or_equal = "like" # if @keywords.include? '*'
      
      title_search = "%"+@keywords.upcase.gsub('*','%')+"%"
      content_search = "%"+title_search+"%"
      
      # upcase, damit Groß-/Kleinschreibung ignoriert wird, "*" wird durch "%" ersetzt
      where_clause = ["user_id = ? and (upper(title) #{like_or_equal} ? or upper(content_pur) like ?)", current_user.id, title_search, content_search]
      
      @notes = Note.where(where_clause).order(created_at: :desc).limit(10)
      
    else
      @notes = Note.where("user_id = ?", current_user.id).order(created_at: :desc).limit(10)
    end
  end
  
  # Detailanzeige
  def show
    @note = find_note(params[:id])
    if @note then
      format_text(@note.title)
      format_text(@note.content)
    end
    # Bei der Rückgabe als HTML sollten wir diese Ersetzung in der View machen.
    #respond_to do |format|
     # format.html 
    #  format.json  {
    #    if @note then
    #      format_text(@note.title)
     #     format_text(@note.content)
     #   end
     # }
    #end
  end
  
  # Notiz bearbeiten
  def edit
    #byebug
    @note = find_note(params[:id])
  end
  
  # Update durchführen
  def update
    #byebug
    @note = find_note(params[:id])
    
    if @note.update(note_params)
      flash[:notice] = "'#{@note.title}' #{t :updated}"
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
      flash[:notice] = "'#{@note.title}' #{t :created}"
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
  
  # Formatiert den Text
  def format_text(text)
    v_rc = ""
    if text then
      # " @some text@ " wird zu " <code>some text</code> " inkl. der Blanks
      text.gsub!(/ @(.[^@]*)@ /) { |r| " <code>#{$1}</code> "}
      #logger.debug("1. text: #{text}")
      # "#text" wird zu "<mark>text</mark>" inkl. der Blanks
      text.gsub!(/[&nbsp;, " "]\#(\b\w+\b)/) { |r| "<mark tag_name=#{$1}>##{$1}</mark>"}
      #logger.debug("2. text: #{text}")
    end 
  end
  
end
