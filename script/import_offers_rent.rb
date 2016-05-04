#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#RAPP
FasterCSV.foreach('../export/rapps.csv', :col_sep =>';') do |row|
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 2,
    :old_id => row[0],
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :floor => row[7],  
    :heating_type_id => row[8],
    :furniture_id => row[9],  
    :user_id => row[10],  
    :elevator=> row[13],  
    :parking => row[14],
    :security => row[15],  
    :project_id => row[22],
    :created_at => row[23],
    :updated_at => row[23],
    :num => row[24],
    :old_type => row[25]
  )  
  offer.offer_languages.create(:language_id => 1, :reference_point => row[16], :description => row[19])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[17], :description => row[20])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[18], :description => row[21])    
end

#RENT
FasterCSV.foreach('../export/rents.csv', :col_sep =>';') do |row|
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 2,
    :old_id => row[0],
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :heating_type_id => row[7],  
    :user_id => row[8],
    :garden => row[11],
    :wc => row[12], 
    :equip => row[13],
    :project_id => row[26],  
    :created_at => row[27],
    :updated_at => row[27],
    :num => row[28],  
    :old_type => row[29]  
    #17offer.status.gsub(/\n/, ' ').gsub(/\r/, ' '),
    #18offer.status_en.gsub(/\n/, ' ').gsub(/\r/, ' '),
    #19"",
  )
  offer.offer_languages.create(:language_id => 1, :reference_point => row[20], :description => row[23])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[21], :description => row[24])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[22], :description => row[25])    
end

#RGARAGE
FasterCSV.foreach('../export/rgarages.csv', :col_sep =>';') do |row|
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 2,
    :old_id => row[0],
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :user_id => row[7],  
    :electricity => row[9],  
    :water => row[10],
    :security => row[12],    
    :project_id => row[19],  
    :created_at => row[20],
    :updated_at => row[20],
    :num => row[21],  
    :old_type => row[22]  
  )
  offer.offer_languages.create(:language_id => 1, :reference_point => row[13], :description => row[16])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[14], :description => row[17])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[15], :description => row[18])    
end

#RHOUSE
FasterCSV.foreach('../export/rhouses.csv', :col_sep =>';') do |row|
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  if !row[18].blank?
    bdate = row[18]+"-01-01"
    bdate = bdate.to_date.to_s(:db)
  else
    bdate = ""  
  end
  
  offer = Offer.create(
    :offer_type_id => 2,
    :old_id => row[0],
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :heating_type_id => row[7],  
    :furniture_id => row[8],
    :construction_type_id => row[9],
    :floors => row[10], 
    :user_id => row[11],
    :zp => row[14],
    :fan_system => row[15],
    :build_year => bdate,    
    :project_id => row[25],  
    :created_at => row[26],
    :updated_at => row[26],
    :num => row[27],  
    :old_type => row[28]  
  )
  offer.offer_languages.create(:language_id => 1, :reference_point => row[19], :description => row[22])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[20], :description => row[23])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[21], :description => row[24])    
end

#ROFFICE
FasterCSV.foreach('../export/roffices.csv', :col_sep =>';') do |row|
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 2,
    :old_id => row[0],
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :floor => row[7],   
    :heating_type_id => row[8],  
    :user_id => row[9],
    :elevator => row[13],  
    :cabel => row[14],  
    :security => row[15],  
    :fan_system => row[16],
    :project_id => row[23],  
    :created_at => row[24],
    :updated_at => row[24],
    :num => row[25],  
    :old_type => row[26]  
  )
  offer.offer_languages.create(:language_id => 1, :reference_point => row[17], :description => row[20])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[18], :description => row[21])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[19], :description => row[22])    
end

#RSHOP
FasterCSV.foreach('../export/rshops.csv', :col_sep =>';') do |row|
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 2,
    :old_id => row[0],
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :heating_type_id => row[7], 
    :floor => row[8],   
    :user_id => row[9],
    :face => row[13],
    :wc => row[15],    
    :project_id => row[22],  
    :created_at => row[23],
    :updated_at => row[23],
    :num => row[24],  
    :old_type => row[25]  
  )
  offer.offer_languages.create(:language_id => 1, :reference_point => row[16], :description => row[19])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[17], :description => row[20])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[18], :description => row[21])    
end

#RSTORES
FasterCSV.foreach('../export/rstores.csv', :col_sep =>';') do |row|
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 2,
    :old_id => row[0],
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :heating_type_id => row[7],   
    :floor => row[8],
    :user_id => row[9],
    :electricity => row[12],   
    :elevator => row[13],   
    :security => row[14],
    :water => row[16], 
    :wc => row[17], 
    :tir => row[19], 
    :project_id => row[26], 
    :created_at => row[27],
    :updated_at => row[27],
    :num => row[28],
    :old_type => row[29]   
  )
  offer.offer_languages.create(:language_id => 1, :reference_point => row[20], :description => row[23])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[21], :description => row[24])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[22], :description => row[25])    
end

