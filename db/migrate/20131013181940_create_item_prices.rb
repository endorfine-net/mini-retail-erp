class CreateItemPrices < ActiveRecord::Migration
  def self.up
    create_table :item_prices do |t|
      t.references  :item, :null => false
      t.references  :user, :null => false
      t.integer :discount
      t.integer :price, :null => false
      t.string :note
      t.timestamps
    end
    add_index :item_prices, [:item_id]
  end

  def self.down
    remove_index :item_prices, [:item_id]
    drop_table :item_prices
  end
end
