require 'rails_helper'

RSpec.describe FollowRelation do
  context 'validation' do
    let(:user2) { create :user }
    let(:user1) { create :user }

    it 'creates a valid follow request' do
      follow_request = FollowRelation.new user: user1, follower: user2, status: :pending

      expect(follow_request).to be_valid
    end

    it 'if to and from are the same returns invalid' do
      follow_request = FollowRelation.new user: user1, follower: user1, status: :pending

      expect(follow_request).to_not be_valid
    end

    it 'each relationship should be unique' do
      follow_request1 = FollowRelation.create user: user1, follower: user2, status: :pending
      expect(follow_request1).to be_valid

      follow_request2 = FollowRelation.new user: user1, follower: user2, status: :pending
      expect(follow_request2).to_not be_valid
    end
  end
end
