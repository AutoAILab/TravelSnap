class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    following = current_user.following << current_user

    @users = following.clone.keep_if{ |x| x.last_known_location.present? }
  end
end
