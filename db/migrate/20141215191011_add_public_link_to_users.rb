class AddPublicLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_link_token, :string
  end
end
