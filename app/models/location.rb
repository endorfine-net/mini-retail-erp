class Location < ActiveRecord::Base
  has_many :users
  has_many :item_quantities
  has_many :item_operations
  has_many :products, :through => :item_quantities
  has_many :items, :through => :item_quantities
  
  validates_presence_of :alias,  :message => "Моля въведете служебно име!" 
  validates_uniqueness_of :alias, :message => "Има въведено такова служебно име!"
  named_scope :by_alias, :order => "alias"  
  
end