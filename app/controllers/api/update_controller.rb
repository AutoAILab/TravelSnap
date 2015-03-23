require 'active_support/all'
require 'mini_exiftool'
require 'tempfile'

module Api
  class UpdateController < ApplicationController
    skip_before_filter :verify_authenticity_token
    skip_before_filter :authenticate_user!

def dms_to_decimal(coordinate)
		decimal = 0.0
		if coordinate =~ /^(\d+)\s+deg\s+(\d+)\'\s+([\d\.]+)\"\s+(\S)\s*$/
		deg = $1.to_f
		min = $2.to_f
		sec = $3.to_f
		direction = $4
		decimal = deg + (min*60.0 + sec)/3600.0
		if direction == 'S' or direction == 'W'
		decimal = -decimal
		end
		end
		decimal
end




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
 
       # imageLocal = "/tmp/RackMultipart20150308*"
       imageLocal = params[:image].tempfile.path # changing
       puts "......1"
        puts imageLocal
        begin
          puts "......2"
          photo = MiniExiftool.new imageLocal
        rescue MiniExiftool::Error => e
          puts "......2_error"
          $stderr.puts e.message
          exit -1
        end
				 lat = dms_to_decimal(photo['GPSLatitude'])
				 lon = dms_to_decimal(photo['GPSLongitude'])
				 altitude = photo['GPSAltitude']
				 direction =photo['Orientation']
				# time = photo['DateTimeOriginal']
        puts "......3"

        user_location = UserLocation.create user: user,
          location: "POINT(#{lon} #{lat})",
        # captured_at: Time.now, image: image,
        #  captured_at: time, image: image,
        	captured_at: photo.date_time_original, image: image,
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
