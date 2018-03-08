# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#

class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true
  before_validation :create_session_token
  attr_reader :password

  has_many :cats,
    class_name: :Cat,
    primary_key: :id,
    foreign_key: :user_id

  has_many :cat_rental_requests,
    class_name: :CatRentalRequest,
    foreign_key: :user_id,
    primary_key: :id

  def reset_session_token!
    self.session_token = SecureRandom.base64(16)
    self.save!
  end

  def create_session_token
    self.session_token ||= SecureRandom.base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = self.find_by(user_name: user_name)
    if user && user.is_password?(password)
      user
    end
  end

end
