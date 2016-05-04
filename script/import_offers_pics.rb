#!/usr/bin/env ruby

RAILS_ENV = ARGV[1] || 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'rubygems'
require 'fastercsv'

#Offer Pictures
FasterCSV.foreach('../export/offer_pics.csv', :col_sep =>';') do |row|
  offer = Offer.find :first, :conditions => {:old_id => row[1], :old_type => row[2]}
  begin
    offer.offer_pictures.create(
      :pictype => row[3],
      :pic => File.new("/www/yavlena/www/current/pix/offers/#{row[0]}/#{row[4]}")
    ) if !offer.blank? #&& offer.offer_pictures.blank?
  rescue
    puts row[0] + "/" + row[1] + "/" + row[2] + "/" + row[3] + "/" + row[4]
  end
end
