#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#User Pictures
FasterCSV.foreach('../export/users_pos.csv', :col_sep =>';') do |row|
  if !row[1].blank?
    user = User.find :first, :conditions => {:id => row[0]}
    user.position = row[1]
    user.save
  end
end