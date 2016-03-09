
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
      #format_text(@note.title)
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
    note_tags = []
    @note = find_note(params[:id])
    
    if @note.update(note_params)
      
      # Tags aus dem Text extrahieren und als Tags speichern
      # und der Notiz zuordnen
      tags = get_tags_from_text(@note.content_pur)
      tags.each do |tag|
        begin
          new_tag = Tag.create(:user_id => current_user.id, :name => tag[0])
        rescue ActiveRecord::RecordNotUnique
          new_tag = Tag.find_by_name(tag[0])
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
    tags.each {|t| t[0].upcase!}
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
