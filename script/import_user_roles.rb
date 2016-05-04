#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

FasterCSV.foreach('../export/users.csv', :col_sep =>';') do |row|
  user = User.find(row[0])
  user.role_id = row[10]
  user.update_attribute(:role_id, row[10])
end      
