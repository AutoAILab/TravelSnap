class RemoveUserLocationImageTable < ActiveRecord::Migration
  def up
    drop_table :user_location_images
  end

  def down
    create_table :user_location_images do |t|
      t.references :user_location, index: true
    end

    add_attachment :user_location_images, :image
  end
end
