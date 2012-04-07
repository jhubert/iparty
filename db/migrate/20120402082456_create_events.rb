class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer   :user_id
      t.string    :facebook_eid
      t.string    :facebook_owner_id
      t.string    :name
      t.string    :image_url
      t.datetime  :start_time
      t.datetime  :end_time
      t.string    :venue_facebook_vid  # fb venue id
      t.string    :venue_name
      t.float     :venue_latitude
      t.float     :venue_longitude
      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :facebook_eid
  end
end
