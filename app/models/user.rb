class User < ActiveRecord::Base

	acts_as_authentic
	
  has_many :products
  has_many :logs  	
  belongs_to :location
  belongs_to :role
 
  has_attached_file :avatar,
     :styles => {
       :tiny => "26x35#",       
       :thumb => "90x120>",
       :full => "180x240>"},
     :url => "/upload/:class/:id/:style/:basename.:extension"

  named_scope :online, :conditions => {:status_id => 1}
  named_scope :archive, :conditions => {:status_id => 2}
  named_scope :order_by_location, :order => :location_id  
	named_scope :by_alias, :order => :alias
  named_scope :no_jbsol, :conditions => "id <> '1'"

  
  def self.find_by_login_or_email(login_info) 
    #find_by_login(login_info) || find_by_email(login_info) 
    find(:first, :conditions => {:login => login_info, :status_id => 1}) || find(:first, :conditions => {:email => login_info, :status_id => 1})
  end
	
	 
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end 
  
  validates_presence_of :email, :message => "Полето E-mail е задължително!"
  validates_format_of :email, :with => Authlogic::Regex.email
  validates_uniqueness_of :email, :on => :create, :message => "Има добавен брокер с такъв E-mail!"
  validates_length_of :email, :within => 8..100, :too_short =>  "Полето E-mail, трябва да бъде поне %d символа!", :too_long =>  "Полето E-mail, трябва да бъде най-много %d символа!"
  #validates_format_of :email, :allow_nil => true, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :message => "Моля въведете валиден E-mail!" 
  validates_length_of :password, :allow_nil => true, :within => 6..40, :too_short =>  "Паролата, трябва да бъде поне %d символа!", :too_long =>  "Паролата, трябва да бъде най-много %d символа!" 
	
	


end
