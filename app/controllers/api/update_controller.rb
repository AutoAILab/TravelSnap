module Api
  class UpdateController < ApplicationController
    skip_before_filter :verify_authenticity_token
    skip_before_filter :authenticate_user!

    def location
      email = params[:user]
      password = params[:password]
      lat = params[:lat]
      lon = params[:lon]
      direction = params[:direction]
      altitude = params[:altitude]
      image = params[:image]

      user = User.find_by email: email

      if user.valid_password? password
        user_location = UserLocation.create user: user,
          location: "POINT(#{lon} #{lat})",
          captured_at: Time.now, image: image,
          direction: direction,
          altitude: altitude

        if user.errors.count > 0
          Rails.logger.debug '*' * 80
          Rails.logger.debug 'Error creating user on UpdateController.'
          Rails.logger.debug user.errors.messages
        end

        if user_location.errors.count > 0
          Rails.logger.debug '*' * 80
          Rails.logger.debug 'Error creating user location on UpdateController.'
          Rails.logger.debug user_location.errors.messages
        end
      else
          Rails.logger.debug '*' * 80
          Rails.logger.debug "Invalid password. Won't update database."
      end

      render nothing: true
    end
  end
end
