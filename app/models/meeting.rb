class Meeting < ApplicationRecord
  has_many :user_meetings
  has_many :users, through: :user_meetings
  validate :date_time, presence: true

  before_save :default_values
  def default_values
    self.midpoint_latitude ||= 0.00000
    self.midpoint_longitude ||= 0.00000
  end
end
