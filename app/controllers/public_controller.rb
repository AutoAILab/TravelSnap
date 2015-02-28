class PublicController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    get_user
  end

  def locations
    get_user
  end

  def get_user
    @user = User.find_by public_link_token: params[:token]
    @users = Array(@user)

    if not @user
      flash.now[:alert] = 'Invalid token'
    end
  end
end
