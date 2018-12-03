class UserMeeting < ApplicationRecord
  belongs_to :user
  belongs_to :meeting

  before_save :default_values
  def default_values
    self.start_latitude ||= 0.00000
    self.start_longitude ||= 0.00000
  end
end
