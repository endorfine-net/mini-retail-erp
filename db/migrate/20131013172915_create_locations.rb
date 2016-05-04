class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.references  :status,  :null => false, :default => 1
      t.string :alias, :null => false
      t.string :short_name, :null => false
      t.string :address
      t.integer :location_type, :null => false, :default => 2
      t.string :notes
      t.timestamps
    end
    add_index :locations, [:status_id]
  end

  def self.down
    remove_index :locations, [:status_id]
    drop_table :locations
  end
end
