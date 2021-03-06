
class NotesController < ApplicationController

  LIMITER = " & "
  WILDCARD = ":*" 
  
  # Index bzw. Suchmaske
  def index
    
    # alle tags, die mindestens einer Notiz zugeordnet sind
    # TODO: Sortierung nach "lower(name)"
    @tag_cloud = TagCloud.new(current_user.id)
    
    if params[:s].present?  # Suche nach Schlagworten
      @keywords = params[:s]
            
      # Leerzeichen werden durch "&" ersetzt und an jeden Suchbegriff wird ":*" gehängt.
      search = add_wildcard(@keywords)
        
      # Volltextsuche
      where_clause = ["index_col_title_content @@ to_tsquery(?)", search]
      
      # wir suchen nur in den Notizen des aktuell angemeldeten Users
      @notes = current_user.notes.where(where_clause).order(updated_at: :desc)
      
    elsif params[:t].present? # Suche über einen konkreten Tag
      @selected_tag = params[:t]
      
      # Alle Notizen zu einem konkreten Tag
      @notes = current_user.notes.joins(:tags).where("tags.id = ?", @selected_tag).order(updated_at: :desc)
      
    else # kein Suchbegriff, es werden die ersten 10 Notizen gezeigt.
      @notes = current_user.notes.order(updated_at: :desc).limit(10)
    end
    
    
  end
  
  # Detailanzeige
  def show
    @note = find_note(params[:id])
    if @note then
      #format_text(@note.title)
      @tags = @note.tags
      #format_text(@note.content, @tags)
      
      @note.related_notes = current_user.notes.joins(:tags).where('note_id <> ? and tag_id in (select tag_id from notes_tags where note_id = ?)', @note.id, @note.id).order(id: :desc)
    end
  end
  
  # Notiz bearbeiten
  def edit
    #byebug
    @note = find_note(params[:id])
  end
  
  # Update durchführen
  def update
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
  
  def destroy
      @note = find_note(params[:id])
      title = @note.title
      
      @note.destroy
      
      flash[:notice] = "'#{title}' #{t :deleted}"
      redirect_to notes_path
  end
  
  def autocomplete
    @note_titles = []
    if params[:term].present?  # Suche nach Schlagworten
      @keywords = params[:term]
            
      # Leerzeichen werden durch "&" ersetzt und an jeden Suchbegriff wird ":*" gehängt.
      search = add_wildcard(@keywords)
        
      # Volltextsuche
      where_clause = ["index_col_title_content @@ to_tsquery(?)", search]
      
      # wir suchen nur in den Notizen des aktuell angemeldeten Users
      @notes = current_user.notes.select("id, title, content").where(where_clause).order(updated_at: :desc).limit(20)
    
      render :plain => @notes.to_json, :status => 200
    end 
  end
  
  # Private Methoden
  private
  def find_note(id)
    # Auch wenn wir eine konkrete Notiz anzeigen, müssen wir prüfen, ob diese
    # dem angemeldeten User gehört.
    Note.where("id = ? and user_id = ?", id, current_user.id).take
  end
  
  def note_params
    params.require(:note).permit(:title, :content)
  end
  
  # Formatiert den Text (wird nicht mehr verwendet)
  def format_text(text, tags=[])
    if text then
      # " @some text@ " wird zu " <code>some text</code> " inkl. der Blanks
      text.gsub!(/\B@(.*?)@\B/) { |r| "<code>#{$1}</code>"}
    
      # alle tags werden ersetzt durch "<mark>text</mark>"
      tags.each do |tag|
        text.gsub!(/(##{tag.name})/) { |r| "<mark tag_name=#{$1}>#{$1}</mark>"}
      end
      #logger.debug("2. text: #{text}")
    end 
  end
  
  def add_wildcard(keywords)
    keywords_plus = ""
    if keywords.include?(" ") then
      keywords.split(" ").each do |k|
        keywords_plus = keywords_plus + k + WILDCARD + LIMITER
      end
      keywords_plus.chomp(LIMITER)
    else
      keywords + WILDCARD
    end
  end
  
end
