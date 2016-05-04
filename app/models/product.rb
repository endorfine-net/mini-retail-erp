class Product < ActiveRecord::Base
  
  belongs_to :user
  has_one  :status
  belongs_to  :product_type
  has_many :items, :dependent => :destroy
  has_many :item_quantities
  has_many :items_operations, :through => :items
  has_many :colors, :through => :items
  has_many :locations, :through => :item_quantities
  
  named_scope :by_product_code, :order => "product_code", :group => :id
  named_scope :online, :conditions => "status_id = 1"
  named_scope :search_alias, lambda {|search|
    search.blank? ? {} : {:conditions => "alias LIKE '%#{search}%'"}
  }
  named_scope :search_note, lambda {|search|
    search.blank? ? {} : {:conditions => "note LIKE '%#{search}%'"}
  }
  

  validates_presence_of :alias, :message => "Полето Име е задължително!"
  validates_uniqueness_of :product_code, :on => :create, :message => "Има продукт с такъв КОД"

   has_attached_file :photo,
    :styles => {
      :tiny => "35x35#",
      :thumb => "150x150>",
      :full =>  "600x600>"
    },
    :url => "/upload/:class/:id/:style/:basename.:extension" 
  
  validates_attachment_presence :photo, :message => ": Качете снимка"
  validates_attachment_content_type :photo, :content_type => 'image/jpeg', :message => ": Качете снимка в JPEG формат"
  validates_attachment_size :photo, :less_than=>1.megabyte , :message => ": Качете снимка с максимална големина до 1 Мb"

end
