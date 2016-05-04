class CreateRoles < ActiveRecord::Migration
  def self.up
     create_table :roles do |t|
       t.string :alias
     end

      Role.new({:id => 1, :alias =>  "Администратор"}).save!
      Role.new({:id => 2, :alias =>  "Управител"}).save!
      Role.new({:id => 3, :alias =>  "Управител на обект"}).save!
      Role.new({:id => 4, :alias =>  "Склададжия"}).save!
      Role.new({:id => 5, :alias =>  "Продавач"}).save!
  end

  def self.down
    drop_table :roles
  end

end