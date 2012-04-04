class EventsController < ApplicationController
  def index
    # get events *created* by the logged-in user
    # TODO: figure out a way to get all events where logged-in user is admin
    fb_query = "SELECT eid,name,creator FROM event 
                WHERE eid IN (SELECT eid FROM event_member WHERE uid=me()) 
                AND creator=me()"
    @events = fb_graph.fql_query(fb_query)
  end

  def create
    if request.post?
      facebook_eid = params['facebook_eid']
      # TODO: what happens if the event doesn't exist?
      fb_event_data = fb_graph.get_object(facebook_eid) 
      # TODO: what happens if a venue doesn't exist?
      fb_venue_data = fb_graph.get_object(fb_event_data['venue']['id'])
      event = Event.create!(
        :user_id => current_user.id,
        :facebook_eid => facebook_eid,
        :name => fb_event_data['name'],
        :image_url => fb_event_data['pic'],
        :start_time => fb_event_data['start_time'],
        :end_time => fb_event_data['end_time'],
        :venue_facebook_vid => fb_venue_data['id'],
        :venue_name => fb_venue_data['name'],
        :venue_latitude => fb_venue_data['location']['latitude'],
        :venue_longitude => fb_venue_data['location']['longitude']
      )
      redirect_to event_path(event)
    end
  end

  def show
    @event = Event.find(params[:id])
  end

end
