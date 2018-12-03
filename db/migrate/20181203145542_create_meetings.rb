class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.string :title
      t.float :midpoint_latitude
      t.float :midpoint_longitude
      t.datetime :date_time

      t.timestamps
    end
  end
end
