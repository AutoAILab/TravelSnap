require 'rails_helper'

RSpec.describe User do
  context 'getting the user locations' do
    it 'returns the correct location' do
      user = create :user
      expect(user.locations.count).to eq 0

      user_location = UserLocation.create(
        user: user,
        location: 'POINT(-73.985655 40.748422)',
        captured_at: Time.now,
      )

      expect(user.locations.count).to eq 1
    end
  end

  context 'getting the last known locations' do
    let(:user) { create :user }

    it 'returns the correct location' do
      expect(user.locations.count).to eq 0

      user_location = UserLocation.create(
        user: user,
        location: 'POINT(41 -70)',
        captured_at: 5.days.ago,
      )

      most_recent_date = 2.days.ago

      user_location = UserLocation.create(
        user: user,
        location: 'POINT(42 -71)',
        captured_at: most_recent_date,
      )

      user_location = UserLocation.create(
        user: user,
        location: 'POINT(43 -72)',
        captured_at: 3.days.ago,
      )

      expect(user.locations.count).to eq 3

      last_location = user.last_known_location
      expect(last_location.captured_at).to eq most_recent_date
      expect(last_location.location).to eq last_location.location.factory.point(42, -71)
    end
  end

  context 'when deleting the user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it 'deletes the user location' do
      user_location = create :user_location, user: user, location: "POINT(40.7828647 -73.96535510000001)"

      expect(User.count).to eq 1
      expect(UserLocation.count).to eq 1

      user.destroy

      expect(User.count).to eq 0
      expect(UserLocation.count).to eq 0
    end

    it 'deletes the user relationships where he is the main user' do
      follow_relation = create :follow_relation, user: user, follower: other_user

      expect(User.count).to eq 2
      expect(user.follower_relations.first.user).to eq user
      expect(user.follower_relations.first.follower).to eq other_user
      expect(user.follower_relations.count).to eq 1
      expect(FollowRelation.count).to eq 1

      user.destroy

      expect(User.count).to eq 1
      expect(user.follower_relations.count).to eq 0
      expect(FollowRelation.count).to eq 0
    end

    it 'deletes the user relationships where he is the follower' do
      follow_relation = create :follow_relation, user: other_user, follower: user

      expect(User.count).to eq 2
      expect(user.following_relations.first.user).to eq other_user
      expect(user.following_relations.first.follower).to eq user
      expect(user.following_relations.count).to eq 1
      expect(FollowRelation.count).to eq 1

      other_user.destroy

      expect(User.count).to eq 1
      expect(user.following_relations.count).to eq 0
      expect(FollowRelation.count).to eq 0
    end

    it 'getting the users a user is following only returns active ones' do
      user1 = create :user
      user2 = create :user
      user3 = create :user
      user4 = create :user

      FollowRelation.create user: user1, follower: user2, status: :pending
      FollowRelation.create user: user1, follower: user3, status: :active
      FollowRelation.create user: user1, follower: user4, status: :inactive

      expect(FollowRelation.count).to eq 3

      expect(user1.following).to be_empty
      expect(user2.following).to be_empty
      expect(user3.following).to match_array([user1])
      expect(user4.following).to be_empty
    end

    it 'getting the users that follow a user only returns active ones' do
      user1 = create :user
      user2 = create :user
      user3 = create :user
      user4 = create :user

      FollowRelation.create user: user1, follower: user2, status: :pending
      FollowRelation.create user: user1, follower: user3, status: :active
      FollowRelation.create user: user1, follower: user4, status: :inactive

      expect(user1.followers).to match_array([user3])
      expect(user2.followers).to be_empty
      expect(user3.followers).to be_empty
      expect(user4.followers).to be_empty
    end
  end

  it 'updates the users token' do
    user = create :user
    expect(user.public_link_token).to_not be_present

    user.update_public_token!

    token1 = user.public_link_token
    expect(token1).to be_present

    user.update_public_token!

    token2 = user.public_link_token
    expect(token1).to be_present
    expect(token1).to_not eq token2
  end
end
