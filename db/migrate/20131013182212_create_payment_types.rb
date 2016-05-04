class CreatePaymentTypes < ActiveRecord::Migration
  
    def self.up
    create_table :payment_types do |t|
      t.string :alias, :null => false
    end
    
    PaymentType.new({:id => 1, :alias => "в брой"}).save!
    PaymentType.new({:id => 2, :alias => "с карта"}).save!
    
  end

  def self.down
    drop_table :payment_types
  end

end
