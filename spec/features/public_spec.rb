require 'rails_helper'

RSpec.feature 'Public views' do
  scenario 'Going to a users public link when the user has a valid token and data' do
    user = create :user
    user.update_public_token!
    user.reload

    user_location = create :user_location, user: user

    visit public_url(user.public_link_token)

    expect(page).to have_content "Last known location for #{user.email}"
    expect(page).to_not have_content "Logout"
    expect(page).to_not have_content "Profile"
    expect(page).to_not have_content "People"
  end

  scenario 'Going to a users public link when the user has a valid token but no data' do
    user = create :user
    user.update_public_token!
    user.reload

    visit public_url(user.public_link_token)

    expect(page).to have_content "Nothing to see here. No location data yet for #{user.email}."
    expect(page).to_not have_content "Logout"
    expect(page).to_not have_content "Profile"
    expect(page).to_not have_content "People"
  end

  scenario 'Going to an invalid token url' do
    user = create :user

    visit public_url("hello")

    expect(page).to have_content 'Invalid token'
    expect(page).to_not have_content "Last known location for: #{user.email}"
    expect(page).to_not have_content "Logout"
    expect(page).to_not have_content "Profile"
    expect(page).to_not have_content "People"
  end
end
