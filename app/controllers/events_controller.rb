class EventsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json

  def index
    @events = current_user.events

    respond_with @events
  end

  def new
    load_unused_facebook_events
  end  

  def create
    facebook_eid = params['facebook_eid']

    event = current_user.create_event_from_facebook_eid(facebook_eid)

    if !event.new_record?
      redirect_to event_path(event)
    else
      redirect_to :new, :error => 'Unable to find that Facebook Event. Please try again.'
    end
  end

  def update_donation_amount
    event = Event.find(params[:id])

    event.update_attribute(:donation_amount, params[:donation_amount])

    redirect_to event_path(event), :notice => 'Donation amount updated'
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def load_unused_facebook_events
    # get events *created* by the logged-in user
    # TODO: figure out a way to get all events where logged-in user is admin
    fb_query = "SELECT eid,name,creator FROM event 
                WHERE eid IN (SELECT eid FROM event_member WHERE uid=me()) 
                AND creator=me()"

    @facebook_events = fb_graph.fql_query(fb_query)

    # create an array of the existing event ids
    existing_events = current_user.events.collect(&:facebook_eid)

    # remove existing event from the facebook event list
    @facebook_events.reject! { |e| existing_events.include?(e['eid'].to_s) }
  end
end
