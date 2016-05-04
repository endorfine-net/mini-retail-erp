class Log < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  
  named_scope :transfers, :conditions => {:action_type => "ITEM_TRANSFER"}
  named_scope :search_note, lambda {|search|
    search.blank? ? {} : {:conditions => "note LIKE '%#{search}%'"}
  }
  named_scope :search_human_readable_text, lambda {|search|
    search.blank? ? {} : {:conditions => "human_readable_text LIKE '%#{search}%'"}
  }
end
