class User < ApplicationRecord
  # to be downcase before save method
  before_save { email.downcase! }
  
  validates :name,  presence: true, length: { maximum: 50 }

  # this is the constant by regular expression to check email validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
            
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
