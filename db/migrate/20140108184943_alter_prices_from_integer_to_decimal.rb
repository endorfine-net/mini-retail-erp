class AlterPricesFromIntegerToDecimal < ActiveRecord::Migration
  def self.up
   change_column :items, :price, :decimal, :precision => 10, :scale => 2
   change_column :items, :old_price, :decimal, :precision => 10, :scale => 2
   change_column :items, :delivery_price, :decimal, :precision => 10, :scale => 2
   change_column :item_operations, :price, :decimal, :precision => 10, :scale => 2
   change_column :logs, :price, :decimal, :precision => 10, :scale => 2
   
  end
  def self.down
   change_column :items, :price, :integer
   change_column :items, :old_price, :integer
   change_column :items, :delivery_price, :integer
   change_column :item_operations, :price, :integer
   change_column :logs, :price, :decimal
  end
end
