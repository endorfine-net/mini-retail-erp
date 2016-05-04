# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  layout "application"
  #before_filter :set_gettext_locale
  before_filter :require_user
  
  helper_method :current_user_session, :current_user, :current_action, :current_host, :current_host_prefix, :current_host_img_prefix,
                :statuses, :roles, :warehouse,
                :has_permissions?, :has_role?,
                :is_on_localhost?,
                :log_action
  
  def log_action(*args)
    #Ex: log_action({:location_id => 1, :source_location_id => 2, :destination_location_id => 3, :action_type => "CREATE", :affected_entity_type => "products", :affected_entity_id => 2, :note => @item_operation.note, :price => 45, :quantity => 1, :human_readable_text => "Иван Петров извърши продажба на WHX123, черни, 39 ном за 45лв"})
    params = args.first
    @datetime = params[:datetime] unless params[:datetime].blank?
    log = Log.new()
    if !@datetime.nil? && has_role?("manager")
      log.created_at = log.updated_at = @datetime   
    end
    log.user_id = current_user.id
    log.location_id = params[:location_id]
    log.action_type = params[:action_type]
    log.affected_entity_type = params[:affected_entity_type]
    log.affected_entity_id = params[:affected_entity_id]
    log.price = params[:price] unless params[:price].blank?
    log.default_price = params[:default_price] unless params[:default_price].blank?
    log.quantity = params[:quantity] unless params[:quantity].blank? 
    log.source_location_id = params[:source_location_id] unless params[:source_location_id].blank?
    log.destination_location_id = params[:destination_location_id] unless params[:destination_location_id].blank?
    log.ip_address = current_user.current_login_ip
    log.note = params[:note] unless params[:note].blank?
    log.human_readable_text = params[:human_readable_text]
    log.save
  end
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
	
  def order_value(value)
    if value.include? "_desc"
      key = value.gsub(/_desc/, ' DESC')
    else
      key = value
    end
  rescue
    key = "id"
  end

	
	def current_host
		request.host_with_port
	end
  def current_host_prefix
		"http://" + current_host
	end
	def is_on_localhost?
		current_host.include? "localhost"
	end
	def current_host_img_prefix
		is_on_localhost? ? 	"http://www.jbsol.com" : current_host_prefix
	end
	
	def statuses
	  Status.find(:all)
	end
	
	def roles
    Role.find(:all)
  end
  
  def warehouse
    Location.find(:first, :conditions =>{:location_type => 1})
  end
	
	
  private
  
  def has_role?(role)
    role_name = role
    return case role
            when "admin"
              current_user.role_id == 1
            when "manager"
              [1,2].include?(current_user.role_id)
            when "location_manager"
              [1,3].include?(current_user.role_id)
            when "storageman"
              [1,4].include?(current_user.role_id)
            when "salesman"  
              [1,5].include?(current_user.role_id)
            else
              return false
            end    
  end
  
  def has_permissions?(controller_name, action_name, location_id=nil)
    
    if !location_id.nil? && (location_id.to_i != current_user.location_id) && !has_role?("admin") && !has_role?("manager") 
        return false
    end
    
    role_name = case current_user.role_id
                when 1
                  "admin"
                when 2
                  "manager"
                when 3
                  "location_manager"
                when 4
                  "storageman"
                when 5
                  "salesman"  
                else
                  return false
                end
                
    return (!ROLES[role_name][controller_name].nil?) && ((ROLES[role_name][controller_name].include?("all")) || (ROLES[role_name][controller_name].include?(action_name))) 
        
  end
  
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end 
	  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
      
  def current_action
    @current_action  = self.action_name
  end
        
  def create_conditions(status)
      conditions = { :status_id => status }
  end
  
  def current_lang
    @current_lang = FastGettext.locale
  end
  
  def lang_id
    @lang_id = 1
  end    
  
  def current_action
    @current_action  = self.action_name
  end
 
begin  
  def set_gettext_locale
    FastGettext.default_text_domain = 'yavlena'
    FastGettext.available_locales = ['bg']
    FastGettext.default_locale = 'bg'
    FastGettext.locale = 'bg'
    super
  end

  public
  def set_locale
    FastGettext.locale = params[:locale]
    if !request.env["HTTP_REFERER"].blank? && request.env["HTTP_REFERER"].include?("about_us")
      redirect_to about_us_url
    elsif !request.env["HTTP_REFERER"].blank? && request.env["HTTP_REFERER"].include?("news")
      redirect_to news_url
    elsif !request.env["HTTP_REFERER"].blank?
      redirect_to :back
    else
      redirect_to root_url
    end
  end
end
  
end
