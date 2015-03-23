require 'rails_helper'

RSpec.feature 'Menu' do
  scenario 'Navigating we can see the correct classes set for menu' do
    user1 = create :user
    user2 = create :user

    using_session :user1 do
      sign_in_with user1

      expect(page).to_not have_css 'li.followers_link.active'
      expect(page).to_not have_css 'li.following_link.active'
      expect(page).to_not have_css 'li.about_link.active'
      expect(page).to_not have_css 'li.profile_link.active'

      click_on 'Followers'
      expect(page).to have_css 'li.followers_link.active'
      expect(page).to_not have_css 'li.following_link.active'
      expect(page).to_not have_css 'li.about_link.active'
      expect(page).to_not have_css 'li.profile_link.active'

      click_on 'Following'
      expect(page).to_not have_css 'li.followers_link.active'
      expect(page).to have_css 'li.following_link.active'
      expect(page).to_not have_css 'li.about_link.active'
      expect(page).to_not have_css 'li.profile_link.active'

      click_on 'About'
      expect(page).to_not have_css 'li.followers_link.active'
      expect(page).to_not have_css 'li.following_link.active'
      expect(page).to have_css 'li.about_link.active'
      expect(page).to_not have_css 'li.profile_link.active'

      click_on 'Profile'
      expect(page).to_not have_css 'li.followers_link.active'
      expect(page).to_not have_css 'li.following_link.active'
      expect(page).to_not have_css 'li.about_link.active'
      expect(page).to have_css 'li.profile_link.active'
    end
  end
end
