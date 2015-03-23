class AddUserImageTable < ActiveRecord::Migration
  def up
    create_table :user_location_images do |t|
      t.references :user_location, index: true
    end

    add_attachment :user_location_images, :image
  end

  def down
    drop_table :user_location_images
  end
end
