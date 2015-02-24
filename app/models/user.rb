class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
end