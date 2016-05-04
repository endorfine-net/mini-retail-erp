class AddDefaultPriceToItemOperations < ActiveRecord::Migration
  def self.up
    add_column :item_operations, :default_price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :item_operations, :default_price
  end
end
