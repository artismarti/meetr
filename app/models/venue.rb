class Venue < ApplicationRecord
  has_many :meeting_venues
  has_many :meetings, through: :meeting_venues
end
