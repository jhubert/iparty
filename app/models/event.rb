class Event < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :user_id, :facebook_eid, :name, :image_url, :start_time, :end_time, :venue_facebook_vid, :venue_name, :venue_latitude, :venue_longitude, :donation_amount, :facebook_owner_id

  validates_presence_of :facebook_eid

  belongs_to :user

  def self.create_from_facebook_graph_and_facebook_eid(koala, eid, attrs = {})
    # TODO: what happens if the event doesn't exist?
    begin
      fb_event_data = koala.get_object(eid)
    rescue
      fb_event_data = nil
    end

    if fb_event_data.present?
      # TODO: what happens if a venue doesn't exist?
      if fb_event_data['venue']['id'].present?
        fb_venue_data = koala.get_object(fb_event_data['venue']['id'])
      elsif fb_event_data['venue']['name'].present?
        fb_venue_data = fb_event_data['venue']
        fb_venue_data['name'] ||= ([fb_venue_data['street'], fb_venue_data['city'], fb_venue_data['country']].join(', '))
      else
        fb_venue_data = {
          'name' => 'Unknown'
        }
      end

      attrs.reverse_merge!({
        :facebook_eid       => fb_event_data['id'],
        :facebook_owner_id  => fb_event_data['owner'] && fb_event_data['owner']['id'],
        :name               => fb_event_data['name'],
        :image_url          => koala.get_picture(fb_event_data['id'],{'type'=>'large'}),
        :start_time         => fb_event_data['start_time'],
        :end_time           => fb_event_data['end_time'],
        :venue_facebook_vid => fb_venue_data['id'],
        :venue_name         => fb_venue_data['name'],
        :venue_latitude     => fb_venue_data['location'] && fb_venue_data['location']['latitude'],
        :venue_longitude    => fb_venue_data['location'] && fb_venue_data['location']['longitude']
      })

      # Merge the data, but don't override the passed in attributes

      return Event.create(attrs)
    else
      return false
    end
  end

  def donate_with_user(user, amount = nil)
    amount ||= donation_amount

    attrs = {
      :customer => user.stripe_customer_id,
      :amount => amount.to_i * 100
    }

    return stripe_charge_with_user(user, attrs)
  end

  def donate_with_user_and_stripe_token(user, stripe_token, amount = nil)
    amount ||= donation_amount

    attrs = {
      :card => stripe_token,
      :amount => amount.to_i * 100
    }

    return stripe_charge_with_user(user, attrs)
  end

  private

  def stripe_charge_with_user(user, attrs = {})
    attrs.reverse_merge!(
      :currency => "usd",
      :description => name,
      :amount => donation_amount.to_i * 100
    )

    begin
      charge = Stripe::Charge.create(attrs)

      return Donation.create_from_user_and_event_and_stripe_data(user, self, charge)
    rescue Stripe::CardError => error
      # Set the has_active_card parameter to false so that they have to add a new card
      customer.update_attribute(:has_active_card, false)

      return Donation.new
    end
  end
end
