class AddSelectedToMeetingVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :meeting_venues, :selected, :boolean
  end
end
