require 'bcrypt'
class Admin < ApplicationRecord
  include BCrypt
  has_many :events
  
  before_save :encrypt_password
  before_save { self.email = email.downcase }
  before_save { self.name = name.strip }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            presence: true,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  def encrypt_password
    if password.present?
      self.password = BCrypt::Password.create(password)
    end
  end

end
