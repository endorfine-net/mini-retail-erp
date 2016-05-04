class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :item_quantity
  belongs_to :request_status

  named_scope :search_note, lambda {|search|
    search.blank? ? {} : {:conditions => "note LIKE '%#{search}%'"}
  }
  named_scope :search_product_code, lambda {|search|
    search.blank? ? {} : {:conditions => "product_code LIKE '%#{search}%'"}
    search.blank? ? {} : {:conditions => "product_code LIKE '%#{search}%'"}
  }
end
