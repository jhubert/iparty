class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :fbid
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :venue_fbid
      t.string :venue_name
      t.float :venue_latitude
      t.float :venue_longitude

      t.timestamps
    end
  end
end
