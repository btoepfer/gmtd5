
class NotesController < ApplicationController

  # Index bzw. Suchmaske
  def index
    where = []
  
    if params[:s].present?  # Suche nach Schlagworten
      @keywords = params[:s]
            
      search = "%"+@keywords.upcase+"%"
      
      # upcase, damit Groß-/Kleinschreibung ignoriert wird
      where_clause = ["(upper(title) like ? or upper(content_pur) like ?)", search, search]
      
      # wir suchen nur in den Notizen des aktuell angemeldeten Users
      @notes = current_user.notes.where(where_clause).order(id: :desc).limit(10)
      
    elsif params[:t].present? # Suche über einen konkreten Tag
      @selected_tag = params[:t]
      
      # Alle Notizen zu einem konkreten Tag
      @notes = current_user.tags.find(id: @selected_tag).notes.order(id: :desc)
      
    else # kein Suchbegriff, es werden die ersten 10 Notizen gezeigt.
      @notes = current_user.notes.order(id: :desc).limit(10)
    end
    
    
  end
  
  # Detailanzeige
  def show
    @note = find_note(params[:id])
    if @note then
      #format_text(@note.title)
      format_text(@note.content)
      @tags = @note.tags
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
    note_tags = []
    @note = find_note(params[:id])
    
    if @note.update(note_params)
      
      # Tags aus dem Text extrahieren und als Tags speichern
      # und der Notiz zuordnen
      tags = get_tags_from_text(@note.content_pur) + get_tags_from_text(@note.title)
      
      tags.each do |tag|
        begin
          # Bang-Version, damit "RecordNotFound"-Exception geworfen wird
          new_tag = Tag.where("user_id = ? and upper(name) = upper(?)", current_user.id, tag[0]).take!
        rescue ActiveRecord::RecordNotFound
          new_tag = Tag.create(:user_id => current_user.id, :name => tag[0])
        end
        note_tags << new_tag
      end
      
      # Nur eindeutige Einträge
      @note.tags = note_tags.uniq
      
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
  
  def get_tags_from_text(text)
    tags = []
    # non-word-boundary#word-boundary*word-boundary
    tags = text.scan(/\B#(\b\w+\b)/) 
    #tags.each {|t| t[0].upcase!}
  end
  
  # Formatiert den Text
  def format_text(text)
    if text then
      # " @some text@ " wird zu " <code>some text</code> " inkl. der Blanks
      text.gsub!(/\B@(.*?)@\B/) { |r| "<code>#{$1}</code>"}
      
      #logger.debug("1. text: #{text}")
      # "#text" wird zu "<mark>text</mark>" inkl. der Blanks
      text.gsub!(/\B#(\b\w+\b)/) { |r| "<mark tag_name=#{$1}>##{$1}</mark>"}
      #logger.debug("2. text: #{text}")
    end 
  end
  
end
