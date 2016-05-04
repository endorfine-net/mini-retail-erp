class CreateSystem < ActiveRecord::Migration
  def self.up
    create_table :system do |t|
      t.string :param
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :system
  end
end
