class CreateStatuses < ActiveRecord::Migration
  
  def self.up
     create_table :statuses do |t|
       t.string :alias
     end

      Status.new({:id => 1, :alias => "Активен"}).save!
      Status.new({:id => 2, :alias =>  "Неактивен"}).save!

  end

  def self.down
    drop_table :statuses
  end
  
end
