class CreateLogs < ActiveRecord::Migration
  def self.up
    
    create_table :logs do |t|
      t.references :user, :null => false
      t.references :location, :null => false
      t.integer :source_location_id
      t.integer :destination_location_id
      t.string :action_type, :null => false
      t.string :affected_entity_type
      t.integer :affected_entity_id
      t.integer :quantity
      t.integer :price
      t.integer :destination_id
      t.string :ip_address, :null => false
      t.string :human_readable_text, :null => false
      t.string :note
      t.timestamps
      
    end
    
    add_index :logs, [:user_id]
    add_index :logs, [:location_id]
    
  end

  def self.down
    remove_index :logs, [:user_id]
    remove_index :logs, [:location_id]
    drop_table :logs
  end
end
