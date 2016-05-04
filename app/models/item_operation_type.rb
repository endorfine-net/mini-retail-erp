class ItemOperationType < ActiveRecord::Base

has_many :item_operations
  
named_scope :without_sale, :conditions => "id <> 1"

end