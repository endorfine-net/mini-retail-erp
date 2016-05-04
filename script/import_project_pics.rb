#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#Project Pictures
FasterCSV.foreach('../export/project_pictures.csv', :col_sep =>';') do |row|
  project_language = ProjectPicture.create(    
    :project_id => row[1],
    :pictype => row[2],
    :pic => File.new("../pix/projects/#{row[0]}/#{row[3]}")
  ) 
end