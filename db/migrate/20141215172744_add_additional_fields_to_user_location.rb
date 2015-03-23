class AddAdditionalFieldsToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :direction, :float
    add_column :user_locations, :altitude, :float
  end
end
