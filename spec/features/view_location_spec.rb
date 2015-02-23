require 'rails_helper'

RSpec.feature 'View Map' do
  scenario 'Visiting the home page with no location data' do
    user = create :user
    sign_in_with user

    visit root_path
    expect(page).to have_content 'Nothing to see here. No location data yet.'
  end

  scenario 'Viewing last known location for a user with location data' do
    user1 = create :user
    user2 = create :user

    follow_relation = create :follow_relation, user: user1, follower: user2, status: :active

    user_location = UserLocation.create(
      user: user1,
      location: 'POINT(43 -72)',
      captured_at: 3.days.ago,
    )

    using_session :user2 do
      sign_in_with user2
      click_on 'Following'

      within('#following') do
        click_on user1.email
      end
    end
  end

  scenario 'Trying to view the last known location for a user with no known location data' do
    user1 = create :user
    user2 = create :user

    follow_relation = create :follow_relation, user: user1, follower: user2, status: :active

    sign_in_with user2

    visit location_url user1
    expect(page).to have_content 'Nothing to see here. No location data yet.'
  end
end
