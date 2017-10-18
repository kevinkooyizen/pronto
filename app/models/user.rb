class User < ApplicationRecord
  has_many :projects
  has_many :authentications, dependent: :destroy
  has_secure_password
  scope :full_name, -> (name){ where("full_name ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?", "%#{name}%", "%#{name}%", "%#{name}%") }
  validates :full_name, presence: true  
  validates :password, presence: true, length: { minimum: 6, maximum: 20 }  
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]{2,}+\z/i
  validates :email, presence: true

  

  def self.create_with_auth_and_hash(authentication, auth_hash)

    user = self.new(
      first_name: auth_hash.info.first_name.scan(/\w+/)[0],
      last_name: auth_hash.info.last_name,
      full_name: auth_hash.info.name,
      provider: auth_hash.provider,
      email: auth_hash.info.email,
      gender: auth_hash.extra.raw_info.gender,
      password: SecureRandom.base64(10),
    )
    
    if auth_hash.extra.raw_info.location.present?
      user.country = auth_hash.extra.raw_info.location.name
    end
    if auth_hash.extra.raw_info.birthday.present?
      user.birthdate = Date.strptime(auth_hash.extra.raw_info.birthday, '%m/%d/%Y')
    end
    user.save
    user.authentications << authentication
    return user
  end

  def fb_token
    x = self.authentications.find_by(provider: 'facebook')
    return x.token unless x.nil?
  end

  def initials
    self.full_name.scan(/(\b[a-zA-Z])[a-zA-Z]* ?/).join
  end

end
