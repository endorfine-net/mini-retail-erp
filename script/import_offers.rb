#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#SAPP
FasterCSV.foreach('../export/sapps.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
      stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  if !row[16].blank?
    bdate = row[16]+"-01-01"
    bdate = bdate.to_date.to_s(:db)
  else
    bdate = ""  
  end
  offer = Offer.create(
    :offer_type_id => 1,
    :old_id => row[0],
    #2:offer.stat,
    :status_id => stat_id,
    :realestate_type_id => row[2],
    :city_id => row[3],
    :location_id => row[4],
    :price => row[5],
    :area => row[6],
    :construction_type_id  => row[7],
    :exposure_id => 0,
    :floor => row[8],
    :floors => row[9],
    :heating_type_id => row[10],
    :user_id => row[11],
    :elevator=> row[14],
    :parking => row[15],
    :build_year => bdate,
    #:build_year => row[16],
    :project_id => row[26],
    :created_at => row[27],
    :updated_at => row[27],
    :num => row[28],
    :old_type => row[29]
  )  
  offer.offer_languages.create(:language_id => 1, :reference_point => row[17], :description => row[23])
  offer.offer_languages.create(:language_id => 2, :reference_point => row[18], :description => row[24])
  offer.offer_languages.create(:language_id => 3, :reference_point => row[19], :description => row[25])    
rescue
	puts "SAPP" + row[1]
end
end
#SENT
FasterCSV.foreach('../export/sents.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 1,
    :old_id => row[0],
    :status_id => stat_id,   
    :realestate_type_id => row[2],   
    :city_id => row[3],   
    :location_id => row[4],   
    :price => row[5],
    :area => row[6],   
    :construction_type_id  => row[7],   
    :heating_type_id => row[8],   
    :user_id => row[9],   
    :garden => row[11],      
    :fan_system => row[12],
    :parking => row[13],   
    :project_id => row[24],   
    :created_at => row[25],
    :updated_at => row[25],   
    :num => row[26],   
    :old_type => row[27]   
   )  
   offer.offer_languages.create(:language_id => 1, :reference_point => row[18], :description => row[21])
   offer.offer_languages.create(:language_id => 2, :reference_point => row[19], :description => row[22])
   offer.offer_languages.create(:language_id => 3, :reference_point => row[20], :description => row[23])    
rescue
end
end
#SGARAGES
FasterCSV.foreach('../export/sgarages.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 1,
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
rescue
end
end
#SHOTEL
FasterCSV.foreach('../export/shotels.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  if !row[17].blank?
    bdate = row[17]+"-01-01"
    bdate = bdate.to_date.to_s(:db)
  else
    bdate = ""  
  end
  
  offer = Offer.create(
    :offer_type_id => 1,
    :old_id => row[0],  
    :status_id => stat_id,     
    :realestate_type_id => row[2],     
    :city_id => row[3],     
    :location_id => row[4],     
    :price => row[5],  
    :area => row[6],     
    :construction_type_id => row[7],   
    :floors => row[8],
    :user_id => row[9],        
    :rzp => row[11],        
    :zp => row[12],          
    :fan_system => row[15],
    :hidro_termo => row[16],
    :build_year => bdate,        
    :project_id => row[24],   
   :created_at => row[25],
   :updated_at => row[25],  
   :num => row[26],     
   :old_type => row[27]
   )   
   offer.offer_languages.create(:language_id => 1, :reference_point => row[18], :description => row[21])
   offer.offer_languages.create(:language_id => 2, :reference_point => row[19], :description => row[22])
   offer.offer_languages.create(:language_id => 3, :reference_point => row[20], :description => row[23])    
rescue
end
end

#SHOUSE
FasterCSV.foreach('../export/shouses.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  if !row[20].blank?
    bdate = row[20]+"-01-01"
    bdate = bdate.to_date.to_s(:db)
  else
    bdate = ""  
  end
  
  offer = Offer.create(
    :offer_type_id => 1,
    :old_id => row[0],
    :status_id => stat_id,   
    :realestate_type_id => row[2],   
    :city_id => row[3],   
    :location_id => row[4],   
    :price => row[5],
    :area => row[6],   
    :construction_type_id  => row[7],   
    :floors => row[8],       
    :user_id => row[9],
    :electricity => row[12],            
    :water => row[13],
    :canalizacia => row[14],            
    :zp => row[15],
    :fan_system => row[16],
    :hidro_termo => row[17],    
    :build_year => bdate,       
    :project_id => row[27],    
    :created_at => row[28],
    :updated_at => row[28],       
    :num => row[29],       
    :old_type => row[30]
   )
   offer.offer_languages.create(:language_id => 1, :reference_point => row[21], :description => row[24])
   offer.offer_languages.create(:language_id => 2, :reference_point => row[22], :description => row[25])
   offer.offer_languages.create(:language_id => 3, :reference_point => row[23], :description => row[26])    
rescue
end
end
#SIND
FasterCSV.foreach('../export/sinds.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  if !row[21].blank?
    bdate = row[21]+"-01-01"
    bdate = bdate.to_date.to_s(:db)
  else
    bdate = ""  
  end  
  offer = Offer.create(
    :offer_type_id => 1,
    :old_id => row[0],
    :status_id => stat_id,   
    :realestate_type_id => row[2],   
    :city_id => row[3],   
    :location_id => row[4],   
    :price => row[5],
    :area => row[6],   
    :construction_type_id  => row[7],   
    :floors => row[8],       
    :user_id => row[9],
    :electricity => row[11],              
    :water => row[12],  
    :rzp => row[14],  
    :canalizacia => row[16],        
    :tir => row[17],        
    :zp => row[19],    
    :hidro_termo => row[20],      
    :build_year => bdate,    
    :project_id => row[27],      
    :created_at => row[28],
    :updated_at => row[28],       
    :num => row[29],       
    :old_type => row[30]
   )
   offer.offer_languages.create(:language_id => 1, :reference_point => "", :description => row[24])
   offer.offer_languages.create(:language_id => 2, :reference_point => row[22], :description => row[25])
   offer.offer_languages.create(:language_id => 3, :reference_point => row[23], :description => row[26])    
rescue
end
end
#SOFFICE
FasterCSV.foreach('../export/soffices.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 1,
    :old_id => row[0],
    :status_id => stat_id,   
    :realestate_type_id => row[2],   
    :city_id => row[3],   
    :location_id => row[4],   
    :price => row[5],
    :area => row[6],   
    :construction_type_id  => row[7],   
    :floor => row[8],
    :heating_type_id => row[9],    
    :user_id => row[10],  
    :cabel => row[14],  
    :parking => row[15],  
    :fan_system => row[17],
    :project_id => row[27],      
    :created_at => row[28],
    :updated_at => row[28],       
    :num => row[29],       
    :old_type => row[30]
   )
   offer.offer_languages.create(:language_id => 1, :reference_point => row[18], :description => row[24])
   offer.offer_languages.create(:language_id => 2, :reference_point => row[19], :description => row[25])
   offer.offer_languages.create(:language_id => 3, :reference_point => row[20], :description => row[26])    
rescue
end
end
#SPARCEL
FasterCSV.foreach('../export/sparcels.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 1,
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
    :project_id => row[23],        
    :created_at => row[24],
    :updated_at => row[24],         
    :num => row[25],    
    :old_type => row[26]
    #14offer.approach,
    #15offer.approach_en,
    #16offer.approach_ru,
   )   
   offer.offer_languages.create(:language_id => 1, :reference_point => row[17], :description => row[20])
   offer.offer_languages.create(:language_id => 2, :reference_point => row[18], :description => row[21])
   offer.offer_languages.create(:language_id => 3, :reference_point => row[19], :description => row[22])    
rescue
end
end

#SSHOP
FasterCSV.foreach('../export/sshops.csv', :col_sep =>';') do |row|
begin
  if row[1].to_i == 1
    stat_id = 1
  elsif row[1].to_i == 0
    stat_id = 3
  else
    stat_id = 3
  end
  offer = Offer.create(
    :offer_type_id => 1,
    :old_id => row[0],
    :status_id => stat_id,   
    :realestate_type_id => row[2],   
    :city_id => row[3],   
    :location_id => row[4],   
    :price => row[5],
    :area => row[6],   
    :construction_type_id  => row[7],  
    :floor => row[8],     
    :user_id => row[9],     
    :wc  => row[15],  
    :project_id => row[22],       
    :created_at => row[23],
    :updated_at => row[23],
    :num => row[24],      
    :old_type => row[25]
   )
   offer.offer_languages.create(:language_id => 1, :reference_point => row[16], :description => row[19])
   offer.offer_languages.create(:language_id => 2, :reference_point => row[17], :description => row[20])
   offer.offer_languages.create(:language_id => 3, :reference_point => row[18], :description => row[21])    
rescue
end
end
