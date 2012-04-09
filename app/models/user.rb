class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :gender, :first_name, :last_name, :facebook_access_token, :facebook_uid

  has_many :events, :dependent => :destroy

  has_many :donations

  after_create :setup_stripe_customer

  def full_name
    [first_name, last_name].join(' ')
  end

  def has_card_on_file?
    has_active_card?
  end

  # returns a Koala object for making authenticated fb api calls
  def koala
    return Koala::Facebook::API.new(facebook_access_token)
  end

  def create_event_from_facebook_eid(eid)
    Event.create_from_facebook_graph_and_facebook_eid(koala, eid, :user_id => id)
  end

  def update_stripe_customer(custom_attrs = {})
    attrs = {
      :email => email,
      :description => full_name,
      :token => nil
    }
    attrs.merge!(custom_attrs)

    customer = Stripe::Customer.retrieve(customer_id)
    customer.email = attrs[:email]
    customer.description = attrs[:description]
    customer.token = attrs[:token]

    if customer.save 
      update_attribute(:has_active_card, true) if attrs[:token].present?
      return true
    else
      return false
    end
  end

  class << self
    def find_for_facebook_oauth(omniauth_hash, signed_in_resource=nil)
      data = omniauth_hash.extra.raw_info
      logger.debug data
      if user = User.where(:email => data.email).first
        user
      else # Create a user with a stub password.
        User.create!(
          :email => data.email,
          :password => Devise.friendly_token[0,20],
          :first_name => data.first_name,
          :last_name => data.last_name,
          :gender => data.gender,
          :facebook_access_token => omniauth_hash.credentials.token,
          :facebook_uid => omniauth_hash.uid
        )
      end
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"]
        end
      end
    end
  end

  private

  def setup_stripe_customer(custom_attrs = {})
    attrs = {
      :email => email,
      :description => full_name
    }
    attrs.merge!(custom_attrs)

    customer = Stripe::Customer.create(attrs)

    update_attribute(:stripe_customer_id, customer.id) if customer
  end
end
