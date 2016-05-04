# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
  def format_datetime(datetime)
    return datetime if !datetime.respond_to?(:strftime)
    #datetime = TzTime.zone.utc_to_local(datetime.utc)    
    datetime.strftime("%d.%m.%Y (%H:%M)")
  end
  def adjust_server_time(datetime)
    return datetime if !datetime.respond_to?(:strftime)
    #datetime = TzTime.zone.utc_to_local(datetime.utc)    
    datetime.strftime("%Y-%m-%d %H:%M")
  end   
	def format_datetime_tablesorter(datetime)
    return datetime if !datetime.respond_to?(:strftime)
    #datetime = TzTime.zone.utc_to_local(datetime.utc)    
    datetime.strftime("%d/%m/%Y")
  end 
  def format_date(datetime)
    return datetime if !datetime.respond_to?(:strftime)
    datetime.strftime("%d.%m.%Y")
  end    
  
  ###SORTABLE LINK
  def sort_th(value)
    result = 'class="header headerSortDown"' if params[:sort] == value
    result = 'class="header headerSortUp"' if params[:sort] == value + "_desc"
    return result
  end
 
  def sort_link(text, action, value, locals={})
    key = value
    key += "_desc" if params[:sort] == value
    link_to text, :action => action, :params => locals.merge(:sort => key)
  end
  ########## SITE HELPERS
  def current_url(params={})
    url_for :only_path=>false, :overwrite_params=>params
  end

	
	def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
	
	def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def get_season_name(season_id)
    return (season_id.to_i == 1)? "Пролет-Лято" : "Есен-Зима"
  end
	
	
	def get_warehouse_item_quantity(item_id)
	 item_quantity = ItemQuantity.find(:first, :conditions => {:location_id => warehouse.id, :item_id => item_id})
	 return item_quantity.amount_current
	 rescue
	   0
	end
	
	def get_location_alias(location_id)
   location = Location.find(location_id)
   return location.alias
   rescue
     location_id
  end
  
  def get_human_readable_action_type(action_type_code)
   action_types = {
     "SALE" => "Продажба",
     "EXCHANGE_TAKE" => "Замяна-приемане",
     "EXCHANGE_GIVE" => "Замяна-предаване",
     "REFUND" => "Връщане",
     
     "ITEM_TRANSFER" => "Трансфер",
     "ITEM_ADD" => "Добавяне на артикул",
     "ITEM_UPDATE" => "Корекция на артикул",
     
     "PRODUCT_CREATE" => "Добавяне на продукт",
     "PRODUCT_UPDATE" => "Корекция на продукт",
     "ITEM_REQUEST" => 'Заявка за доставка'
     }
   return (!action_types[action_type_code].blank?)? action_types[action_type_code] : action_type_code
   rescue
     action_type_code
  end
	
	
	def highlightIfLowQuantity(quantity)
	  if quantity <= ITEM_LOW_QUANTITY 	    
      return 'class="productItemLowQuantity"' 
	  end
	end
	
	def highlightIfLowQuantityInStatistics(quantity)
    if quantity <= ITEM_LOW_QUANTITY      
      return 'class="productItemLowQuantity"' 
    else
      return 'class="productItemLowQuantityInStatistics"'
    end
  end
	
	def highlightSale(quantity)
    if quantity > ITEM_SALE_OK      
      return 'class="productItemSalesOK"' 
    end
  end
  
  def highlightSaleInStatistics(quantity)
    if quantity > ITEM_SALE_OK      
      return 'class="productItemSalesOK"'
    else
      return 'class="productItemSalesOKInStatistics"'  
    end
  end
	
  
  ########## EXPORT HELPERS
  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end  
	

end
