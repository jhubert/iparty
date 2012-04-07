class AddDonationAmountToEvent < ActiveRecord::Migration
  def change
    add_column :events, :donation_amount, :integer
  end
end
