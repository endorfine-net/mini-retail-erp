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
  city = City.create(:alias => row[1])
  city.city_languages.create(:language_id => 1, :name => row[2])	
  city.city_languages.create(:language_id => 2, :name => row[3])  
  city.city_languages.create(:language_id => 3, :name => row[4])    
end

FasterCSV.foreach('../export/cts.csv', :col_sep =>';') do |row|
  ct = ConstructionType.create(:alias => row[1])
  ct.construction_type_languages.create(:language_id => 1, :name => row[2])	
  ct.construction_type_languages.create(:language_id => 2, :name => row[3])  
  ct.construction_type_languages.create(:language_id => 3, :name => row[4])    
end

FasterCSV.foreach('../export/fts.csv', :col_sep =>';') do |row|
  ft = Furniture.create(:alias => row[1])
  ft.furniture_languages.create(:language_id => 1, :name => row[2])	
  ft.furniture_languages.create(:language_id => 2, :name => row[3])  
  ft.furniture_languages.create(:language_id => 3, :name => row[4])    
end


FasterCSV.foreach('../export/region_cities.csv', :col_sep =>';') do |row|
  cr = CitiesRegion.create(:city_id =>row[2], :region_id => row[1])
end

FasterCSV.foreach('../export/district_locations.csv', :col_sep =>';') do |row|
  dl = DistrictsLocation.create(:district_id =>row[1], :location_id => row[2])
end

FasterCSV.foreach('../export/departments.csv', :col_sep =>';') do |row|
  department = Department.create(:alias => row[1], :email => row[4], :description => row[5])
  department.department_languages.create(:language_id => 1, :name => row[1])	
  department.department_languages.create(:language_id => 2, :name => row[2])  
  department.department_languages.create(:language_id => 3, :name => row[3])    
end

FasterCSV.foreach('../export/offices.csv', :col_sep =>';') do |row|
  office = Office.create(:city_id => row[1], :alias => row[2], :phone1 => row[8], :phone2 => row[9], :phone3 => row[10], :fax => row[11], :mobile => row[12], :email => row[13], :manager_id => row[14], :chief_broker_id => row[15])
  office.office_languages.create(:language_id => 1, :name => row[2], :address => row[5], :description => row[16])	  
  office.office_languages.create(:language_id => 2, :name => row[3], :address => row[6], :description => row[17])  
  office.office_languages.create(:language_id => 3, :name => row[4], :address => row[7], :description => row[18])    
end


FasterCSV.foreach('../export/districts.csv', :col_sep =>';') do |row|
  district = District.create(:city_id => row[1], :alias => row[2])
  district.district_languages.create(:language_id => 1, :name => row[2])	
  district.district_languages.create(:language_id => 2, :name => row[3])  
  district.district_languages.create(:language_id => 3, :name => row[4])    
end


FasterCSV.foreach('../export/locations.csv', :col_sep =>';') do |row|
  location = Location.create(:city_id => row[1], :alias => row[2])
  location.location_languages.create(:language_id => 1, :name => row[3])	
  location.location_languages.create(:language_id => 2, :name => row[4])  
  location.location_languages.create(:language_id => 3, :name => row[5])    
end

FasterCSV.foreach('../export/regions.csv', :col_sep =>';') do |row|
  region = Region.create(:alias => row[1])
  region.region_languages.create(:language_id => 1, :name => row[1])	
  region.region_languages.create(:language_id => 2, :name => row[2])  
  region.region_languages.create(:language_id => 3, :name => row[3])    
end


FasterCSV.foreach('../export/re_types.csv', :col_sep =>';') do |row|
  realestate_type = RealestateType.create(:alias => row[1])
  realestate_type.realestate_type_languages.create(:language_id => 1, :name => row[2])	
  realestate_type.realestate_type_languages.create(:language_id => 2, :name => row[3])  
  realestate_type.realestate_type_languages.create(:language_id => 3, :name => row[4])
  
  realestate_type.realestate_type_params.create(:offer_type_id => 1)
  realestate_type.realestate_type_params.create(:offer_type_id => 2)      
end

FasterCSV.foreach('../export/heatings.csv', :col_sep =>';') do |row|
  heating_type = HeatingType.create(:alias => row[1])
  heating_type.heating_type_languages.create(:language_id => 1, :name => row[2])	
  heating_type.heating_type_languages.create(:language_id => 2, :name => row[3])  
  heating_type.heating_type_languages.create(:language_id => 3, :name => row[4])    
end

FasterCSV.foreach('../export/users.csv', :col_sep =>';') do |row|
  if row[7].blank?
    row[7] = row[8]
  end
  
  if row[18].to_i == 1
    stat_id = 1
  elsif row[18].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  
  user = User.new(
    :login => row[7],
    :crypted_password => row[9],
    :password_salt => "yavlena",
    :persistence_token => row[0],
    :email => row[8], 
    :office_name => row[11], 
    :office_id => row[12].to_i, 
    :department_id => row[13].to_i, 
    :phone => row[14], 
    :ext_phone => row[15], 
    :mobile => row[16], 
    :office_mobile => row[17], 
    :status_id => stat_id, 
    :description => row[28], 
    :imotinet_id => row[27].to_i, 
    :in_company_from => row[25], 
    :in_estates_from => row[26]
  )
  user.save_with_validation(false)
  user.user_languages.create(:language_id => 1, :fname => row[1], :lname => row[4], :position => row[19], :about_me => row[22])	  
  user.user_languages.create(:language_id => 2, :fname => row[2], :lname => row[5], :position => row[20], :about_me => row[23])  
  user.user_languages.create(:language_id => 3, :fname => row[3], :lname => row[6], :position => row[21], :about_me => row[24])    
end      
