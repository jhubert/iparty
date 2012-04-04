class AddFbInfoToUsers < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      add_column :users, :facebook_uid, :string
      add_column :users, :facebook_access_token, :string
      add_index :users, :facebook_access_token, :unique => true
    end
  end
end
