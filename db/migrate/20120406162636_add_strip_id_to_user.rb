class AddStripIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :has_active_card, :boolean
  end
end
