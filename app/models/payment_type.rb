class PaymentType < ActiveRecord::Base
  has_many :item_operations
end