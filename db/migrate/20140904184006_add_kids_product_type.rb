class AddKidsProductType < ActiveRecord::Migration
  def self.up
    ProductType.new({:id => 7, :alias => "Детска колекция"}).save!
  end

  def self.down
    ProductType.find(:conditions => {:alias => "Детска колекция"}).destroy()
  end
end
