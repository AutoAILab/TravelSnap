class CreateUserLocationsTable < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.references :user, index: true
      t.point :location, geographic: true
      t.datetime :captured_at
      t.timestamps
    end
  end
end
