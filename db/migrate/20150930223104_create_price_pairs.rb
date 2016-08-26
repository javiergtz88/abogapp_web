class CreatePricePairs < ActiveRecord::Migration
  def change
    create_table :price_pairs do |t|
      t.integer  "amount"
      t.decimal  "price"

      t.timestamps
    end
  end
end
