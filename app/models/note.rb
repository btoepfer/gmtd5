class Note < ActiveRecord::Base
  validates  :title, presence: true, length: { maximum: 100 }
  validates  :content, :presence => true
  
  
  belongs_to :user
end
