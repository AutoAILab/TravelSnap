class UserLocation < ActiveRecord::Base
  validates_presence_of :user, :location

  belongs_to :user

  has_attached_file :image,
    styles: { large: '300x300>' }

  validates_attachment :image,
    matches: [/png\Z/, /jpg\Z/, /jpeg\Z/],
    :content_type => { content_type: /\A(image|application)\/.*\Z/ },
    :size => { :in => 0..10000.kilobytes }
end
