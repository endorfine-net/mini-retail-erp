class ItemOperation < ActiveRecord::Base
  belongs_to :item, :dependent => :destroy
  belongs_to :item_operation_type
  belongs_to :payment_type
  belongs_to :user
  belongs_to :location
  has_one :product, :through => :item
  named_scope :sales, :conditions => {:item_operation_type_id => 1}  
  named_scope :sales_and_returns, :conditions => "item_operations.item_operation_type_id IN (1,3)"
  named_scope :by_date, :order => "item_operations.created_at DESC"
end
