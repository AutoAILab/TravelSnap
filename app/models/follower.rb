class FollowRelation < ActiveRecord::Base
  validates_presence_of :user, :follower

  belongs_to :user
  belongs_to :follower, class_name: 'User'
end
