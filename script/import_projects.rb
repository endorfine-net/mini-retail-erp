#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#Projects
FasterCSV.foreach('../export/projects.csv', :col_sep =>';') do |row|
  if row[2].to_i == 1
      stat_id = 1
  elsif row[2].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  project = Project.create(    
    :alias => row[1],
    :status_id => stat_id,    
    :city_id => row[3],
    :location_id => row[4],
    :created_at => row[5],
    :updated_at => row[6],
    :user_id => row[7]
  )  
end
#Project Languages
FasterCSV.foreach('../export/project_languages.csv', :col_sep =>';') do |row|
  project_language = ProjectLanguage.create(    
    :project_id => row[1],
    :language_id => row[2],
    :title => row[3],
    :description => row[4]
  )  
end