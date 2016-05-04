class AddDefaultPriceToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :default_price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :logs, :default_price
  end
end
