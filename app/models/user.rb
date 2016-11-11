class User < ApplicationRecord
  has_one :giaovien
  has_one :sinhvien
  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum: 50 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },allow_nil:true
  # Returns a random token.
  def new_token
    SecureRandom.urlsafe_base64
  end
  # Returns the hash digest of the given string.
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = self.new_token
    update_attribute(:remember_digest, self.digest(remember_token))
  end
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
end
end
