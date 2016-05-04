#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#Projects
FasterCSV.foreach('./export/news.csv', :col_sep =>';') do |row|
  if row[1] == "bg"
      lang_id = 1
  else
    lang_id = 2
  end    
  post = Post.create(    
    :language_id => lang_id,
    :status_id => 1,    
    :user_id => row[5],
    :type_id => 1,
    :title => row[2],
    :body => row[3],
    :author => row[4],    
    :created_at => row[6],
    :updated_at => row[6]
  )  
end
