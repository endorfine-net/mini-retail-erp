#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#User Pictures
FasterCSV.foreach('../export/user_pics.csv', :col_sep =>';') do |row|
  if !row[2].blank?
    user = User.find :first, :conditions => {:id => row[0], :email => row[1]}
    user.avatar = File.new("../pix/users/#{row[0]}/#{row[2]}")
    user.save
  end
end