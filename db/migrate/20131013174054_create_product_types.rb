class CreateProductTypes < ActiveRecord::Migration
  
  def self.up
     create_table :product_types do |t|
       t.string :alias
     end

      ProductType.new({:id => 1, :alias => "Дамскa колекция"}).save!
      ProductType.new({:id => 2, :alias => "Мъжкa колекция"}).save!
      ProductType.new({:id => 3, :alias => "Чанти"}).save!
      ProductType.new({:id => 4, :alias => "Портмонета"}).save!
      ProductType.new({:id => 5, :alias => "Чорапи"}).save!
      ProductType.new({:id => 6, :alias => "Ръкавици"}).save!
  end

  def self.down
    drop_table :product_types
  end
  
 
end
