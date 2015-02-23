require 'rails_helper'

RSpec.feature 'Following' do
  scenario 'Sending a follow resquest with a user in the system and it is accepted' do
    user1 = create :user
    user2 = create :user

    using_session :user1 do
      sign_in_with user1

      click_on 'Following'
      fill_in 'Email address', with: user2.email
      click_on 'Send Request'

      expect(page).to have_content "You've sent a request to follow #{user2.email}"
    end

    using_session :user2 do
      sign_in_with user2

      click_on 'Followers'

      within('#followers') do
        expect(page).to have_content user1.email
      end

      click_on 'Accept'
      click_on 'Followers'

      within('#followers') do
        expect(page).to have_content user1.email
      end

      click_on 'Following'

      within('#following') do
        expect(page).to_not have_content user1.email
      end
    end

    using_session :user1 do
      click_on 'Followers'

      within('#followers') do
        expect(page).to_not have_content user1.email
        expect(page).to_not have_content user2.email
      end

      click_on 'Following'

      within('#following') do
        expect(page).to_not have_content user1.email
        expect(page).to have_content user2.email
      end
    end

    using_session :user1 do
      expect(FollowRelation.count).to eq 1
      fill_in 'Email address', with: user2.email
      click_on 'Send Request'

      expect(page).to_not have_content "You have sent a request to follow #{user2.email}"
      expect(page).to have_content "Unable to send request to #{user2.email}"
      expect(FollowRelation.count).to eq 1
    end
  end

  scenario 'Sending a follow resquest with a user in the system and it is denied' do
    user1 = create :user
    user2 = create :user

    using_session :user1 do
      sign_in_with user1

      click_on 'Following'

      fill_in 'Email address', with: user2.email
      click_on 'Send Request'

      expect(page).to have_content "You've sent a request to follow #{user2.email}"
    end

    using_session :user2 do
      sign_in_with user2

      click_on 'Followers'

      within('#followers') do
        expect(page).to have_content user1.email
      end

      click_on 'Deny'

      within('#followers') do
        expect(page).to_not have_content user1.email
      end

      within('#followers') do
        expect(page).to_not have_content user1.email
      end
    end
  end

  scenario 'Sending a follow resquest for a user not in the system' do
    user1 = create :user

    using_session :user1 do
      sign_in_with user1

      click_on 'Following'
      fill_in 'Email address', with: 'hello@example.com'
      click_on 'Send Request'

      expect(page).to have_content "This user is not in the system"
    end
  end

  scenario 'When one of my followed users doesnt have location data' do
    user1 = create :user
    user2 = create :user

    create :follow_relation, user: user1, follower: user2, status: :active

    using_session :user1 do
      sign_in_with user2

      click_on 'Following'

      expect(page).to have_content user1.email
      expect(page).to_not have_link user1.email
    end
  end

  scenario 'When one of my followed users has location data' do
    user1 = create :user
    user2 = create :user

    create :follow_relation, user: user1, follower: user2, status: :active

    create :user_location, user: user1, location: "POINT(40 -71)"

    using_session :user1 do
      sign_in_with user2

      click_on 'Following'

      expect(page).to have_link user1.email
    end
  end
end
