class AddNoteToItemOperations < ActiveRecord::Migration
  def self.up
    add_column :item_operations, :note, :string 
  end

  def self.down
    remove_column :item_operations, :note
  end
end
