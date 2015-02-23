require 'rails_helper'

module Api
  RSpec.describe 'Updater' do
    describe '/api/update/location' do
      context 'when updating the location with a valid user but invalid password' do
        let(:user) { create :user }

        before do
          post api_update_location_path,
            user: user.email,
            password: 'hello',
            lat: '40',
            lon: '-70'
        end

        it 'does not create a user location' do
          expect(UserLocation.count).to eq 0
        end
      end

      context 'when updating the location with basic params' do
        let(:user) { create :user }

        before do
          post api_update_location_path,
            user: user.email,
            password: '12345',
            lat: '40',
            lon: '-70'
        end

        it 'creates a user location with no image' do
          expect(UserLocation.count).to eq 1
          user_location = UserLocation.first
          expect(user_location.image).to_not be_present
          expect(user_location.direction).to_not be_present
          expect(user_location.altitude).to_not be_present
          expect(user_location.location).to eq UserLocation.first.location.factory.point(-70, 40)
        end
      end

      context 'when updating the location without image' do
        let(:user) { create :user }

        before do
          post api_update_location_path,
            user: user.email,
            password: '12345',
            lat: '40',
            lon: '-70',
            direction: '120',
            altitude: '100'
        end

        it 'creates a user location with no image' do
          expect(UserLocation.count).to eq 1
          user_location = UserLocation.first
          expect(user_location.image).to_not be_present
          expect(user_location.direction).to eq 120
          expect(user_location.altitude).to eq 100
          expect(user_location.location).to eq UserLocation.first.location.factory.point(-70, 40)
        end
      end

      context 'when updating the location with all params' do
        let(:user) { create :user }

        before do
          post api_update_location_path,
            user: user.email,
            password: '12345',
            lat: '40',
            lon: '-70',
            direction: '120',
            altitude: '100',
            image: Rack::Test::UploadedFile.new("#{File.dirname(__FILE__)}/../../files/flower0.jpg", "image/png")
        end

        it 'creates the user location with all params' do
          expect(UserLocation.count).to eq 1
          user_location = UserLocation.first

          expect(user_location.image).to be_present
          expect(user_location.image.url).to match '/system/user_locations/images/.*/original/flower0.jpg'
          expect(user_location.image.original_filename).to eq 'flower0.jpg'
          expect(user_location.image.content_type).to eq 'image/png'
          expect(user_location.direction).to eq 120
          expect(user_location.altitude).to eq 100
          expect(UserLocation.first.location).to eq UserLocation.first.location.factory.point(-70, 40)
        end
      end
    end
  end
end
