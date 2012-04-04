class Event < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :user_id, :facebook_eid, :name, :image_url, :start_time, :end_time, :venue_facebook_vid, :venue_name, :venue_latitude, :venue_longitude

  belongs_to :user
end
