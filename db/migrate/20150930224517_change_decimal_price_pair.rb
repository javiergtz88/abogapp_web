class ChangeDecimalPricePair < ActiveRecord::Migration
  def change
    change_column :price_pairs, :price, :decimal, :precision => 16, :scale => 2
  end
end
