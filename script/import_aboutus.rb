#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#Projects
FasterCSV.foreach('./export/about_us.csv', :col_sep =>';') do |row|
  post = Post.create(    
    :language_id => row[1],
    :status_id => 1,
    :type_id => 2,
    :title => row[2],
    :body => row[3]
  )  
end
