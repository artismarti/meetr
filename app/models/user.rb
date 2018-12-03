class User < ApplicationRecord
  has_many :user_meetings
  has_many :meetings, through: :user_meetings
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, presence: true
end
