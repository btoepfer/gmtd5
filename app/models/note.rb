class Note < ActiveRecord::Base
  validates  :title, presence: true, length: { maximum: 100 }
  
  
  belongs_to :user
  has_and_belongs_to_many :tags
  
  # Vor dem Speichern wird der Inhalt bereinigt um die HTML-Tags 
  # in content_pur gespeichert und
  # es werden aus dem Text die Tags (#...) extrahiert und
  # als solche gespeichert
  before_save :strip_html_tags, :gen_tags
  
  # Hier können wir für eine Notiz die verwandten Notizen speichern
  attr_reader :related_notes
  attr_writer :related_notes
  
  protected
    def strip_html_tags
      self.content_pur = ActionView::Base.full_sanitizer.sanitize(self.content)
    end
    
    # Generierung der Tags aus dem Inhalt bzw. dem Titel
    def gen_tags
      note_tags = []
      # Tags aus dem Text extrahieren und als Tags speichern
      # und der Notiz zuordnen
      tags = get_tags_from_text(self.content) + get_tags_from_text(self.title)
    
      tags.each do |tag|
        begin
          # Bang-Version, damit "RecordNotFound"-Exception geworfen wird
          new_tag = Tag.where("user_id = ? and upper(name) = upper(?)", self.user_id, tag[0]).take!
        rescue ActiveRecord::RecordNotFound
          new_tag = Tag.create(:user_id => self.user_id, :name => tag[0])
        end
        note_tags << new_tag
      end
      self.tags = note_tags.uniq
    end
    
    def get_tags_from_text(text)
      tags = []
      v_text = ""
      # Inhalte innerhalb der <pre>-Tags werden ignoriert,
      # auch über Zeilenumbrüche hinweg (/.../m)
      v_text = text.gsub(/<pre>.*<\/pre>/m, "")
      # non-word-boundary#word-boundary*word-boundary
      tags = v_text.scan(/\B#(\b\w+\b)/) 
    end
    
end
