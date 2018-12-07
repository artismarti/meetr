class MeetingVenue < ApplicationRecord
  belongs_to :venue
  belongs_to :meeting
end
