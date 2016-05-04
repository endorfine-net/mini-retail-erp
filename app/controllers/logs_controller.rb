class LogsController < ApplicationController
  
  layout "application"
  
  before_filter :check_permissions
  
  def index
    ########## START GET PARAMS
    @page = (params[:page].blank?)? 1 : params[:page]  
    @per_page = (params[:per_page].blank?)? 20 : params[:per_page] 
    @sort = (params[:sort].blank?)? "id desc" : params[:sort]

    @location_id = params[:location_id]
    @user_id = params[:user_id]
    @date_from = Date.parse(params[:date_from]) unless params[:date_from].blank?
    #@date_from ||= Date.today.beginning_of_week
    @date_to = Date.parse(params[:date_to]) unless params[:date_to].blank?
    #@date_to ||= Date.today
    @ip_address = params[:ip_address]
    @action_type = params[:action_type]
    @human_readable_text = params[:human_readable_text]
    @source_location_id = params[:source_location_id]
    @destination_location_id = params[:destination_location_id]
    @search_note = (params[:search_note].blank?)? "" : params[:search_note]
    ########## END GET PARAMS

    ########## Fix search criteria by permissions
    if !has_role?("manager")
      if !@location_id.blank?
        @location_id = current_user.location_id
      end
      if !@user_id.blank?
        @user_id = current_user.id
      end
      if !@ip_address.blank?
        @ip_address = nil
      end
    end
    ########## Fix search criteria by permissions

    ######### Collections for toolbar
    @users_select_list = User.by_alias
    @locations_select_list = Location.by_alias
    ######### Collections for toolbar

    
    @title = "Логове"

    conditions = {}

    conditions = conditions.merge(
        {:location_id => @location_id}
    ) unless @location_id.blank?

    conditions = conditions.merge(
        {:user_id => @user_id}
    ) unless @user_id.blank?

    conditions = conditions.merge(
        {:created_at => (@date_from - 1.day)..(@date_to)}
    ) unless (@date_from.blank? || @date_to.blank?)

    conditions = conditions.merge(
        {:ip_address => @ip_address}
    ) unless @ip_address.blank?

    conditions = conditions.merge(
        {:action_type => @action_type}
    ) unless @action_type.blank?

    conditions = conditions.merge(
        {:source_location_id => @source_location_id}
    ) unless @source_location_id.blank?

    conditions = conditions.merge(
        {:destination_location_id => @destination_location_id}
    ) unless @destination_location_id.blank?


  	@logs = Log.search_human_readable_text(@human_readable_text).search_note(@search_note).paginate(
      :page => @page, 
      :per_page => @per_page, 
      :conditions => conditions,
      :order => order_value(@sort)
    )

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def transfers
    ########## START GET PARAMS
    @page = (params[:page].blank?)? 1 : params[:page]  
    @per_page = (params[:per_page].blank?)? 20 : params[:per_page] 
    @sort = (params[:sort].blank?)? "created_at desc" : params[:sort]
    @location_id = params[:location_id]  
    ########## END GET PARAMS
    
    @title = "Доставки"
    conditions = ["location_id=? OR source_location_id=? OR destination_location_id=?", @location_id, @location_id, @location_id] unless @location_id.blank?
  
    @logs = Log.transfers.paginate(
      :page => @page, 
      :per_page => @per_page, 
      :conditions => conditions,
      :order => order_value(@sort)
    )

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def my_transfers
    ########## START GET PARAMS
    @page = (params[:page].blank?)? 1 : params[:page]  
    @per_page = (params[:per_page].blank?)? 20 : params[:per_page] 
    @sort = (params[:sort].blank?)? "created_at desc" : params[:sort]
    @location_id = current_user.location_id
    ########## END GET PARAMS
    
    @title = "Доставки"

    conditions = ["location_id=? OR source_location_id=? OR destination_location_id=?", @location_id, @location_id, @location_id]
    
    @logs = Log.transfers.paginate(
      :page => @page, 
      :per_page => @per_page, 
      :conditions => conditions,
      :order => order_value(@sort)
    )
    render :action => :transfers
  end
  

  private
  
  def check_permissions
    if !has_permissions?(self.controller_name, self.action_name)
      redirect_to root_path
    end
  end
	
  
end
