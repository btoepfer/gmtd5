class Note < ActiveRecord::Base
  validates  :title, presence: true, length: { maximum: 100 }
  
  
  belongs_to :user
end
