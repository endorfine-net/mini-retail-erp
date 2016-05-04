class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.references :user, :null => false
      t.references :location, :null => false
      t.references :request_status, :null => false
      t.references :item_quantity, :null => false
      t.integer :source_location_id, :null => false
      t.integer :destination_location_id, :null => false
      t.string  :product_code, :null => false
      t.integer :quantity, :null => false
      t.string  :note
      t.timestamps
    end

    add_index :requests, [:user_id]
    add_index :requests, [:location_id]
    add_index :requests, [:request_status_id]
    add_index :requests, [:item_quantity_id]

  end

  def self.down
    remove_index :requests, [:user_id]
    remove_index :requests, [:location_id]
    remove_index :requests, [:request_status_id]
    remove_index :requests, [:item_quantity_id]
    drop_table :requests
  end
end
