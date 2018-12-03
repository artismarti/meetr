class CreateUserMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_meetings do |t|
      t.references :user, foreign_key: true
      t.references :meeting, foreign_key: true
      t.float :start_latitude
      t.float :start_longitude
      t.string :user_status

      t.timestamps
    end
  end
end
