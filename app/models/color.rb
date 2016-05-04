class Color < ActiveRecord::Base

  has_many :items
  has_many :products, :through => :items
  
  validates_presence_of :alias, :message => "Полето Име е задължително!"
  validates_presence_of :primary, :message => "Полето Основен цвят е задължително!"
  validates_uniqueness_of :code, :on => :create, :message => "Има цвят с такъв КОД"

end
