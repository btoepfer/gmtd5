class Tag < ActiveRecord::Base
  validates  :name, presence: true, length: { maximum: 100 }
  
  belongs_to :user
  has_and_belongs_to_many :notes
  
end
