# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago', { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


time_now = Time.now.to_s(:db)


colors = Color.create(
[
  {:alias => "Черен", :code => "blk", :primary => "000000"}
])
