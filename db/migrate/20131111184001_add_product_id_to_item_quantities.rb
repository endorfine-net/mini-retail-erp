class AddProductIdToItemQuantities < ActiveRecord::Migration
  def self.up
    add_column :item_quantities, :product_id, :integer, :null => false
    add_index :item_quantities, [:product_id]
  end

  def self.down
    remove_index :item_quantities, [:product_id]
    remove_column :item_quantities, :product_id
  end
end
