class Project < ApplicationRecord
  before_create :capitalize
  belongs_to :user
  mount_uploaders :images, ImageUploader
  validates :name, presence: true  
  scope :tname, -> (name){ where("name ILIKE ?", "%#{name}%" ) }
  scope :description, -> (description){ where("description ILIKE ?", "%#{description}%" ) }

  def capitalize
    self.attributes.each do |key, value|
      if value.present? && value.is_a?(String)
        value.capitalize!
      end
    end
  end
end
