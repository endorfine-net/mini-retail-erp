#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

class CitiesRegion < ActiveRecord::Base
end
class DistrictsLocation < ActiveRecord::Base
end


FasterCSV.foreach('../export/locations.csv', :col_sep =>';') do |row|
  location = Location.find(:first, :conditions => {:city_id => row[1], :alias => row[2]})
  if !location.location_languages.find_by_language_id(1).blank?
    location.location_languages.find_by_language_id(1).update_attribute(:name, row[3]) 
  else
    location.location_languages.create(:language_id => 1, :name => row[3])	
  end
  if !location.location_languages.find_by_language_id(2).blank?  
    location.location_languages.find_by_language_id(2).update_attribute(:name, row[4]) 
  else
    location.location_languages.create(:language_id => 2, :name => row[4])      
  end
  if !location.location_languages.find_by_language_id(3).blank?
    location.location_languages.find_by_language_id(3).update_attribute(:name, row[5])    
  else
    location.location_languages.create(:language_id => 3, :name => row[5])        
  end
end
