class Project < ApplicationRecord
  before_create :capitalize
  belongs_to :user
  mount_uploader :images, ImageUploader

  def capitalize
    self.attributes.each do |key, value|
      if !value.nil? && value.is_a?(String)
        value.capitalize!
      end
    end
  end
end
