class Tag < ActiveRecord::Base
  validates  :name, presence: true, length: { maximum: 100 }
  
  belongs_to :user
  has_and_belongs_to_many :notes
  
  before_save :convert_to_upper
  
  protected
  def convert_to_upper
    self.name_upper = self.name.upcase
  end
  
end
