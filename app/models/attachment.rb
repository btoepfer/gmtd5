class Attachment < ActiveRecord::Base
  belongs_to :notes

  has_attached_file :doc, 
                    path: ":rails_root/public/system/:class/:attachment/:id/:style/:filename", 
                    url: ":rails_root/public/system/:class/:attachment/:id/:style/:filename", 
                    styles: {medium: "500x500>", thumbnail: "60x60#"},
                    storage: "filesystem"
  validates_attachment :doc, content_type: { content_type: ["image/pjpeg", "image/jpeg", "image/gif", "image/png", "image/x-png", "application/pdf"] }
  validates_attachment_file_name :doc, matches: [/pdf\z/i, /png\z/i, /jpe?g\z/i]
  
  before_post_process :is_image?

  def is_image?
    ["image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif"].include?(self.doc_content_type) 
  end
end

