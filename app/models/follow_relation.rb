class FollowRelation < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  enum status: [:pending, :active, :inactive]

  validates_presence_of :user, :follower
  validates_uniqueness_of :follower, scope: :user

  validates_each :user, :follower do |record, attr, value|
    record.errors.add(attr, 'user and follower must be different') if record.user == record.follower
  end
end
