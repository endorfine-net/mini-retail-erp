#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rails_generator'
require 'rails_generator/scripts/generate'
require 'rubygems'
require 'fastercsv'

FasterCSV.foreach('../export/nomenklatura_rentbg.csv', :col_sep =>';') do |row|
  RentbgCity.create(
    :city_id => row[0],
    :name => row[1]
  )
end
FasterCSV.foreach('../export/nomenklatura_rentbg_tip_stroitelstvo.csv', :col_sep =>';') do |row|
  RentbgConstType.create(
    :const_type_id => row[0],
    :name => row[1]
  )
end
FasterCSV.foreach('../export/nomenklatura_rentbg_categories.csv', :col_sep =>';') do |row|
  RentbgRetype.create(
    :retype_id => row[0],
    :name => row[1]
  )
end
