#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

class CitiesRegion < ActiveRecord::Base
end
class DistrictsLocation < ActiveRecord::Base
end


FasterCSV.foreach('../export/cities.csv', :col_sep =>';') do |row|
  city = City.find(:first, :conditions => {:alias => row[1]})
  if !city.city_languages.find_by_language_id(1).blank?
    #city.city_languages.find_by_language_id(1).update_attribute(:name, row[2]) 
  else
    city.city_languages.create(:language_id => 1, :name => row[2])	
  end
  if !city.city_languages.find_by_language_id(2).blank?  
    #city.city_languages.find_by_language_id(2).update_attribute(:name, row[3]) 
  else
    city.city_languages.create(:language_id => 2, :name => row[3])      
  end
  if !city.city_languages.find_by_language_id(3).blank?
    #city.city_languages.find_by_language_id(3).update_attribute(:name, row[4])    
  else
    city.city_languages.create(:language_id => 3, :name => row[4])        
  end
end
