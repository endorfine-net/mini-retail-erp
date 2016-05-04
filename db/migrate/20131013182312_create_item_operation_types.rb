class CreateItemOperationTypes < ActiveRecord::Migration
  def self.up
    create_table :item_operation_types do |t|
      t.string :alias, :null => false
    end
    ItemOperationType.new({:id => 1, :alias => "Продажба"}).save!
    ItemOperationType.new({:id => 2, :alias => "Замяна"}).save!
    ItemOperationType.new({:id => 3, :alias => "Връщане"}).save!
  end

  def self.down
    drop_table :item_operation_types
  end
end
