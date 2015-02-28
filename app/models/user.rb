class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar,
    styles: {
      avatar: '35x35>',
      medium: '200x200#',
      large: '300x300>'
    },
  default_url: "missing_:style.png"

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :locations, class_name: 'UserLocation', dependent: :destroy
  has_many :follower_relations, class_name: 'FollowRelation', dependent: :destroy
  has_many :following_relations, foreign_key: :follower_id, class_name: 'FollowRelation', dependent: :destroy

  def following
    following_relations.active.map(&:user)
  end

  def followers
    follower_relations.active.map(&:follower)
  end

  def pending_requests
    follower_relations.pending
  end

  def pending_followers
    pending_requests.map(&:follower)
  end

  def last_known_location
    locations.order('captured_at DESC').first
  end

  def update_public_token!
    new_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(public_link_token: random_token)
    end

    self.public_link_token = new_token

    save
  end
end
