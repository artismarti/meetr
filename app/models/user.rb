class User < ApplicationRecord
  has_many :user_meetings, :dependent => :delete_all
  has_many :meetings, through: :user_meetings
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, presence: true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
