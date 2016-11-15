class Task < ApplicationRecord
  validates  :name, presence: true, length: { maximum: 100 }

  
  belongs_to :user
end
