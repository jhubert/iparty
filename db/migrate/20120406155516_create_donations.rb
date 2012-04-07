class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :event
      t.references :user
      t.string   :currency_code
      t.string   :description
      t.string   :card_last_4
      t.string   :card_exp_year
      t.string   :card_exp_month
      t.string   :card_type
      t.string   :card_country
      t.string   :card_cvc_check
      t.boolean  :paid,           :default => false
      t.boolean  :refunded,       :default => false
      t.string   :processor_id
      t.string   :amount
      t.string   :fee
      t.text     :raw_data
      t.timestamps
    end
  end
end