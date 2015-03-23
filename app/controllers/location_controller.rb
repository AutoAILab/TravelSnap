class LocationController < ApplicationController
  def for_user
    @user = User.find(params[:id])

    if @user.locations.blank?
      flash.now[:notice] = 'Nothing to see here. No location data yet.'
    end

    render 'index'
  end
end
