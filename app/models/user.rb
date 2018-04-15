class User < ApplicationRecord
  # to be downcase before save method
  before_save { email.downcase! }
  
  validates :name,  presence: true, length: { maximum: 50 }

  # this is constant to check email validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
end
