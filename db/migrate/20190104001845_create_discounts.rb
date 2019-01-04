class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :discount_type
      t.integer :discount_amount

      t.timestamps
    end
  end
end
