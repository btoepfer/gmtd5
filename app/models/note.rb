class Note < ActiveRecord::Base
  validates  :title, presence: true, length: { maximum: 100 }
  
  
  belongs_to :user
  
  before_save :strip_html_tags
  
  protected
    def strip_html_tags
      self.content_pur = ActionView::Base.full_sanitizer.sanitize(self.content)
    end
  
end
