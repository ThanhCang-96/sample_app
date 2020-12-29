class User < ApplicationRecord
  before_save{email.downcase!}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true,
    length: {maximum: Settings.user.name.max_lenght}
  validates :email, presence: true,
    length: {maximum: Settings.user.mail.max_lenght},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.user.pass.min_lenght}
  has_secure_password

  def self.digest string
    if cost = ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
