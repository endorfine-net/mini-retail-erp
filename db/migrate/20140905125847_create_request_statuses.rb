class CreateRequestStatuses < ActiveRecord::Migration
  def self.up
    create_table :request_statuses do |t|
      t.string :alias
    end

    RequestStatus.new({:id => 1, :alias =>  "Нова"}).save!
    RequestStatus.new({:id => 2, :alias =>  "В прогрес"}).save!
    RequestStatus.new({:id => 3, :alias =>  "Доставена"}).save!
    RequestStatus.new({:id => 4, :alias =>  "Отказана"}).save!
    RequestStatus.new({:id => 5, :alias =>  "Потвърдена"}).save!


  end

  def self.down
    drop_table :request_statuses
  end
end
