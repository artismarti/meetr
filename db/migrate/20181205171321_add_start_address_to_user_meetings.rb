class AddStartAddressToUserMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :user_meetings, :start_address, :string
  end
end
