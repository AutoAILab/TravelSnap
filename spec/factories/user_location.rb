FactoryGirl.define do
  factory :user_location do
    user
    captured_at { 2.weeks.ago }
    image { Rack::Test::UploadedFile.new("#{File.dirname(__FILE__)}/../../spec/files/rocks0.jpg", "image/jpg") }
    location { "POINT(40 -72)" }
  end
end
