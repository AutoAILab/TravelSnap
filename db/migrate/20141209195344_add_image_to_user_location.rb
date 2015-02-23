class AddImageToUserLocation < ActiveRecord::Migration
  def self.up
    add_attachment :user_locations, :image
  end

  def self.down
    remove_attachment :user_locations, :image
  end
end
