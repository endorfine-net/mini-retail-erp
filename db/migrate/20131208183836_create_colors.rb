class CreateColors < ActiveRecord::Migration
  def self.up
    create_table :colors do |t|
      t.string :alias, :null => false
      t.string :code, :null => false
      t.string :primary, :null => false
      t.string :secondary
    end
  end

  def self.down
    drop_table :colors
  end
end
