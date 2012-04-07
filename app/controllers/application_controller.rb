class ApplicationController < ActionController::Base
  protect_from_forgery

  # returns a Koala object for making authenticated fb api calls
  def fb_graph
    return Koala::Facebook::API.new(current_user && current_user.facebook_access_token)
  end
end
