class User < ApplicationRecord
  has_many :user_meetings
  has_many :meetings, through: :user_meetings
  validate :first_name, presence: true
  validate :last_name, presence: true
  validate :email, presence: true
  validate :password, presence: true
end
