class GuestController < ApplicationController
  before_filter :authenticate_user!

  def index
    @events = current_user.koala.get_connections('me', 'events')
  end

  def party
    @event = Event.find_by_facebook_eid(params[:id])
    @event = Event.create_from_facebook_graph_and_facebook_eid(current_user.koala, params[:id]) unless @event.present?
  end

  def payment
    @event = Event.find_by_facebook_eid(params[:id])
  end

  # TODO: Clean this up!
  # 
  # Does the user have a customer_id already?
  # Have new card details been submitted
  #  - Are we allowed to save the card details?
  #    - save them
  #  - Charge it
  # Does the user already have a card on file?
  #  - charge it
  # D
  def charge
    @event = Event.find_by_facebook_eid(params[:id])

    if params[:stripe_card_token].present?
      if params[:save_card_details].present?
        logger.debug "Adding card details"
        current_user.update_customer(:token => params[:strip_card_token])
      else
        logger.debug "Create donation from stripe token"
        @donation = @event.donate_with_user_and_stripe_token(current_user, params[:stripe_card_token], params[:amount])
      end
    end

    if @donation.nil? && current_user.has_card_on_file?
      logger.debug "Charging from card on file"
      @donation = @event.donate_with_user(current_user, params[:amount])
    end

    if @donation && @donation.valid?
      logger.debug "########## Donation confirmed"
      redirect_to guest_thanks_path(@event.facebook_eid)
    else
      logger.debug "########## No donation made at all"
      redirect_to guest_payment_path(@event.facebook_eid, :amount => params[:amount])
    end    
  end

  def thanks
    @event = Event.find_by_facebook_eid(params[:id])
  end
end
