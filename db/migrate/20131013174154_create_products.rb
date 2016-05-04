class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.references  :user, :null => false
      t.references  :status, :null => false, :default => 1
      t.string :alias, :null => false, :default => ""
      t.string :product_code, :null => false
      t.references  :product_type, :null => false
      t.integer :collection_year
      t.integer :collection_season
      t.string :note
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end
    add_index :products, [:user_id]
    add_index :products, [:status_id]
    add_index :products, [:product_type_id]
  end

  def self.down
    remove_index :products, [:status_id]
    remove_index :products, [:product_type_id]
    remove_index :products, [:user_id]
    drop_table :products
  end 
end
