class Item < ActiveRecord::Base
  belongs_to :product, :dependent => :destroy
  belongs_to :color
  has_many :locations, :through => :item_quantities
  has_many :items_quantities, :dependent => :destroy
  has_many :items_operations, :dependent => :destroy
  
  named_scope :by_color, :order => 'color_id, size'
  
  validates_numericality_of :price,  :allow_nil => true, :only_integer => false, :message => "Моля въведете число за ЦЕНА"
  validates_numericality_of :delivery_price,  :allow_nil => true, :only_integer => false, :message => "Моля въведете число за ЦЕНА"

  
end
