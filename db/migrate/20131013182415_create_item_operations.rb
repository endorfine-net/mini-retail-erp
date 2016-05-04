class CreateItemOperations < ActiveRecord::Migration
  def self.up
    create_table :item_operations do |t|
      t.references  :item, :null => false
      t.references  :user, :null => false
      t.references  :location, :null => false
      t.references  :item_operation_type, :null => false
      t.references  :payment_type, :default => 1
      t.integer :price, :null => false
      t.timestamps
    end
    add_index :item_operations, [:item_id]
    add_index :item_operations, [:user_id]
    add_index :item_operations, [:location_id]
    add_index :item_operations, [:item_operation_type_id]
    add_index :item_operations, [:payment_type_id]
  end

  def self.down
    remove_index :item_operations, [:item_id]
    remove_index :item_operations, [:user_id]
    remove_index :item_operations, [:location_id]
    remove_index :item_operations, [:item_operation_type_id]
    remove_index :item_operations, [:payment_type_id]
    drop_table :item_operations
  end
end
