class ItemQuantity < ActiveRecord::Base
  belongs_to :item, :dependent => :destroy
  belongs_to :location, :dependent => :destroy
  belongs_to :product, :dependent => :destroy
  has_many :requests
  
  named_scope :order_by_item_size_and_item_color, :select => "item_quantities.*", :joins => "inner join items on items.id = item_quantities.item_id", :order => "items.color_id, items.size"
  
  validates_numericality_of :amount_delivered, :allow_nil => false, :only_integer => true, :message => "Моля въведете цяло число за КОЛИЧЕСТВО"
end
