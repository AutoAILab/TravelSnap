namespace :db do
  task populate: :environment do
    UserLocation.destroy_all
    User.destroy_all
    FollowRelation.destroy_all

    locations = [
      Geocoder.coordinates('new york city'),
      Geocoder.coordinates('central park, new york'),
      Geocoder.coordinates('city college of new york'),
      Geocoder.coordinates('the bronx, new york'),
      Geocoder.coordinates('penn station, new york'),
      Geocoder.coordinates('brooklyn, new york'),
      Geocoder.coordinates('jersey city, new jersey'),
      Geocoder.coordinates('pennsylvania, united states'),
      Geocoder.coordinates('yonkers, ny'),
      Geocoder.coordinates('san franciso, ca'),
      Geocoder.coordinates('santiago, dominican republic'),
      Geocoder.coordinates('beijing, china'),
    ]

    users = []
    5.times do |x|
      users << User.create(
        email: "abc#{x}@example.com",
        password: '123123',
        avatar: Rack::Test::UploadedFile.new("#{File.dirname(__FILE__)}/../../spec/files/flower#{(0..6).to_a.sample}.jpg", "image/jpg")
      )
    end

    users.each do |user|
      puts "creating user with email: #{user.email}"

      5.times do
        lat, lon = locations.sample
        puts "Adding location: #{lat}, lon: #{lon}"
        UserLocation.create user: user,
          location: "POINT(#{lon} #{lat})",
          captured_at: 1.week.ago,
          direction: 100,
          altitude: 150,
          image: Rack::Test::UploadedFile.new("#{File.dirname(__FILE__)}/../../spec/files/rocks#{(0..3).to_a.sample}.jpg", "image/jpg")
      end

      puts

      users.each do |other_user|
        if user != other_user
          FollowRelation.create user: user, follower: other_user, status: :active
        end
      end
    end

  end
end
