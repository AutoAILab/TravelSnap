class CreateFollowRelation < ActiveRecord::Migration
  def change
    create_table :follow_relations do |t|
      t.integer :user_id
      t.integer :follower_id
      t.integer :status
      t.timestamps
    end

    add_index :follow_relations, :user_id
    add_index :follow_relations, :follower_id
    add_index :follow_relations, :status
  end
end
