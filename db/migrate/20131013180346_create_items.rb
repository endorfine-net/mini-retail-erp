class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :product, :null => false
      t.references :color, :null => false
      t.integer :size
      t.integer :delivery_price
      t.integer :total_delivered
      t.integer :total_in_stock
      t.timestamps
    end
    add_index :items, [:product_id]
    add_index :items, [:color_id]
  end

  def self.down
    remove_index :items, [:product_id]
    remove_index :items, [:color_id]
    drop_table :items
  end
end
