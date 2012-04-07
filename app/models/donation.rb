class Donation < ActiveRecord::Base

  belongs_to :event
  belongs_to :user  

  validates_presence_of :amount, :event_id, :user_id

  def self.create_from_user_and_event_and_stripe_data(user, event, data)
    attr_map = {
      :currency_code => data['currency'],
      :description => data['description'],
      :card_last_4 => data['card']['last4'],
      :card_exp_year => data['card']['exp_year'],
      :card_exp_month => data['card']['exp_month'],
      :card_type => data['card']['type'],
      :card_country => data['card']['country'],
      :card_cvc_check => data['card']['cvc_check'],
      :paid => data['paid'],
      :refunded => data['refunded'],
      :processor_id => data['id'],
      :amount => data['amount'],
      :fee => data['fee'],
      :raw_data => data.to_json,
      :event => event,
      :user => user
    }
    create(attr_map)
  end
end
