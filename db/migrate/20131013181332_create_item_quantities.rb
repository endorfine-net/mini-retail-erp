class CreateItemQuantities < ActiveRecord::Migration
  def self.up
    create_table :item_quantities do |t|
      t.references  :item, :null => false
      t.references  :location, :null => false
      t.boolean :is_delivered
      t.integer :amount_delivered
      t.integer :amount_current
      t.timestamps
    end
    add_index :item_quantities, [:item_id]
    add_index :item_quantities, [:location_id]
  end

  def self.down
    remove_index :item_quantities, [:item_id]
    remove_index :item_quantities, [:location_id]
    drop_table :item_quantities
  end
end
