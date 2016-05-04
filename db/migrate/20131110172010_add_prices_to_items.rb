class AddPricesToItems < ActiveRecord::Migration
  def self.up
    remove_index :item_prices, [:item_id]
    drop_table :item_prices
    
    add_column :items, :price, :integer, :null => false
    add_column :items, :old_price, :integer, :null => false
  end

  def self.down
    create_table :item_prices do |t|
      t.references  :item, :null => false
      t.references  :user, :null => false
      t.integer :discount
      t.integer :price, :null => false
      t.string :note
      t.timestamps
    end
    add_index :item_prices, [:item_id]
    remove_column :items, :price
    remove_column :items, :old_price
  end
end
