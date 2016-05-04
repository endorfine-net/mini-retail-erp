class ProductsController < ApplicationController
  
  layout "application"
  
  before_filter :check_permissions
  
  def index
    redirect_to :controller => :my_store 
  end
  
  # GET /products
  def my_store
    ########## START GET PARAMS
    @page = (params[:page].blank?)? 1 : params[:page]  
    @per_page = (params[:per_page].blank?)? 1 : params[:per_page] 
    @sort = (params[:sort].blank?)? "alias" : params[:sort]
    @product_type_id = params[:product_type_id]
    @location_id = current_user.location_id 
    @status_id = (params[:status_id].blank?)? 1 : params[:status_id]		
		@search_string = (params[:search_string].blank?)? "" : params[:search_string] 
		@open_product_by_code = params[:open_product_by_code]  
    ########## END GET PARAMS
    
    @title = "Продукти в Моят обект"
    if @open_product_by_code && !@open_product_by_code.blank?
        conditions = "product_code = '#{@open_product_by_code}'"   
    else
  		@status_id ||= 1	
      #Create conditions based on user role - param: status_id (1 - online)
      conditions = create_conditions(@status_id) 
      conditions = conditions.merge(
        {:product_type_id => @product_type_id}
      ) unless @product_type_id.blank? 
    end
    
    	
    @location = Location.find(@location_id)
    @locations_select_list = Location.by_alias	
  	@location_products = @location.products.by_product_code.paginate(
      :page => @page, 
      :per_page => @per_page, 
      :conditions => conditions,
      :order => order_value(@sort),
      :count => {:group => 'products.id' }
    )

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def stores
    ########## START GET PARAMS
    @page = (params[:page].blank?)? 1 : params[:page]  
    @per_page = (params[:per_page].blank?)? 1 : params[:per_page] 
    @sort = (params[:sort].blank?)? "alias" : params[:sort]
    @location_id = (params[:location_id].blank?)? current_user.location_id : params[:location_id] 
    @open_product_by_code = params[:open_product_by_code]
#    if (!params[:location_id].blank? && )
#      @page = nil
#      @sort = nil
#    end
    ########## END GET PARAMS
    
    @title = "Всички Продукти"
    
    
    if @open_product_by_code && !@open_product_by_code.blank?
        conditions = "product_code = '#{@open_product_by_code}'"   
     else
       @status_id ||= 1  
      #Create conditions based on user role - param: status_id (1 - online)
      conditions = create_conditions(@status_id) 
    end
      
      @locations_select_list = Location.by_alias
      
      @location = Location.find(@location_id)
      @location_products = @location.products.by_product_code.paginate(
            :page => @page, 
            :per_page => @per_page, 
            :conditions => conditions,
            :order => order_value(@sort),
            :count => {:group => 'products.id' }
     )
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def inventory
    ########## START GET PARAMS
    @page = (params[:page].blank?)? 1 : params[:page]  
    @per_page = (params[:per_page].blank?)? 1 : params[:per_page] 
    @sort = (params[:sort].blank?)? "updated_at desc" : params[:sort]
    @product_type_id = params[:product_type_id]
    @location_id = current_user.location_id
    @status_id = (params[:status_id].blank?)? 1 : params[:status_id]
    @open_product_by_code = params[:open_product_by_code]     
    @search_string = (params[:search_string].blank?)? "" : params[:search_string]   
    ########## END GET PARAMS
    
    @title = "Инвентар"
    
    @product_types = ProductType.find(:all)
    @locations_select_list = Location.by_alias
    
     if @open_product_by_code && !@open_product_by_code.blank?
        conditions = "product_code = '#{@open_product_by_code}'"   
     else
        @status_id ||= 1  
        #Create conditions based on user role - param: status_id (1 - online)
        conditions = create_conditions(@status_id) 
        conditions = conditions.merge(
          {:product_type_id => @product_type_id}
        ) unless @product_type_id.blank? 
       
     end

    @products = Product.online.paginate(
        :page => @page, 
        :per_page => @per_page, 
        :conditions => conditions,
        :order => order_value(@sort)
      )

    respond_to do |format|
      format.html # index.html.erb
    end
  end
	
	
	  
  def statistics
    ########## START GET PARAMS
    @page = (params[:page].blank?)? 1 : params[:page]  
    @per_page = (params[:per_page].blank?)? 1 : params[:per_page] 
    @sort = (params[:sort].blank?)? "updated_at desc" : params[:sort]
    @product_type_id = params[:product_type_id]
    @location_id = current_user.location_id
    @status_id = (params[:status_id].blank?)? 1 : params[:status_id]
    @open_product_by_code = params[:open_product_by_code]     
    @search_string = (params[:search_string].blank?)? "" : params[:search_string]
    @date_from = Date.parse(params[:date_from]) unless params[:date_from].blank?
    @date_from ||= Date.today.beginning_of_week
    @date_to = Date.parse(params[:date_to]) unless params[:date_to].blank?
    @date_to ||= Date.today
    @collection_year = params[:collection_year]
    @collection_season = params[:collection_season]
    @search_alias = (params[:search_alias].blank?)? "" : params[:search_alias]
    @search_note = (params[:search_note].blank?)? "" : params[:search_note]
    ########## END GET PARAMS
    
    @title = "Статистика (продукти)"
    
    @product_types = ProductType.find(:all)
    @locations_select_list = Location.by_alias
    @collection_years = ((Date.today.year-10)..(Date.today.year)).sort.reverse
    
     if @open_product_by_code && !@open_product_by_code.blank?
        conditions = "product_code = '#{@open_product_by_code}'"   
     else
        @status_id ||= 1  
        #Create conditions based on user role - param: status_id (1 - online)
        conditions = create_conditions(@status_id) 
        conditions = conditions.merge(
          {:product_type_id => @product_type_id}
        ) unless @product_type_id.blank?
        
        conditions = conditions.merge(
          {:collection_year => @collection_year}
        ) unless @collection_year.blank?
        
        conditions = conditions.merge(
          {:collection_season => @collection_season}
        ) unless @collection_season.blank?  
       
     end

    
    @products = Product.online.search_alias(@search_alias).search_note(@search_note).paginate(
        :page => @page, 
        :per_page => @per_page, 
        :conditions => conditions,
        :order => order_value(@sort)
      )
    

    respond_to do |format|
      format.html # index.html.erb
    end
  end

	
	def delete_photo
     product = Product.find(params[:id])
     product.photo = nil
     product.save false
     redirect_to edit_product_url(:id=>product.id, :sort_direction => params[:sort_direction], :sort_column => params[:sort_column], :last_page => params[:last_page], :search_string => params[:search_string], :type => params[:type])
  end
  

  def new
    @product = Product.new()
    @collection_years = ((Date.today.year-10)..(Date.today.year)).sort.reverse
    @product_types = ProductType.find(:all)
		@last_method = "index"
    respond_to do |format|
      format.html
    end
  end

  def edit
    @product = Product.find(params[:id]) 
    @collection_years = ((Date.today.year-10)..(Date.today.year)).sort.reverse
    @product_types = ProductType.find(:all)
    
		@sort_direction = params[:sort_direction]
		@sort_column = params[:sort_column]
		@last_page = params[:last_page] 
		@search_string = params[:search_string]
		@page = params[:page]
    @sort = params[:sort]
		@last_method = params[:last_method]		
    @status_id = params[:status_id]
    @location_id = params[:location_id] 
    
    respond_to do |format|
      format.html
    end
        	
  end
  
  
  # POST /product
  def create   
		@product = Product.new(params[:product])		
		#for tableSorter Pager
		@sort_direction = params[:sort_direction]
		@sort_column = params[:sort_column]
		@last_page = params[:last_page] 
		@search_string = params[:search_string]
		@last_method = params[:last_method]		
		@product.user_id = current_user.id
		
    if @product.save
      flash[:notice] = "Продукта е създаден успешно"
      log_action({:location_id => current_user.location_id, :action_type => "PRODUCT_CREATE", :affected_entity_type => "product", :affected_entity_id => @product.id, :note => @product.note, :human_readable_text => "#{@product.product_code}. Стойности: име: #{@product.alias}, статус: #{Status.find(@product.status_id).alias}, код: #{@product.product_code}, колекция: #{@product.collection_year} / #{@product.collection_season}, тип: #{ProductType.find(@product.product_type_id).alias}."})         
      redirect_to :action => :inventory, :sort_direction => params[:sort_direction], :sort_column => params[:sort_column], :last_page => params[:last_page], :search_string => params[:search_string], :type => params[:type]
    else
      @product_types = ProductType.find(:all)
      @collection_years = ((Date.today.year-10)..(Date.today.year)).sort.reverse
      @last_method = "index"
      render :action => :new
    end
  end
  

  # PUT /products/1
  def update
    @product = Product.find(params[:id])

    #BACK PARAMS
    @status_id = params[:status_id]
    @city_id = params[:city_id]
    @product_type_id = params[:product_type_id]    
    @user_id = params[:user_id]
    @page = params[:page]
		@sort = params[:sort]
		@last_method = params[:last_method]		
		@product_type_id = params[:product_type_id]
		@location_id = params[:location_id]
	
		#for tableSorter Pager
		@sort_direction = params[:sort_direction]
		@sort_column = params[:sort_column]
		@last_page = params[:last_page] 
		@search_string = params[:search_string]
   
    if @product.update_attributes(params[:product])
      flash[:notice] = 'Продукта е променен успешно'
      log_action({:location_id => current_user.location_id, :action_type => "PRODUCT_UPDATE", :affected_entity_type => "product", :affected_entity_id => @product.id, :note => @product.note, :human_readable_text => "#{@product.product_code}. Стойности: име: #{@product.alias}, статус: #{Status.find(@product.status_id).alias}, код: #{@product.product_code}, колекция: #{@product.collection_year} / #{@product.collection_season}, тип: #{ProductType.find(@product.product_type_id).alias}."}) 
      redirect_to :action => :inventory, :sort_direction => @sort_direction, :sort_column => @sort_column, :last_page => @last_page, :search_string => @search_string, :page => @page, :sort => @sort, :last_method => @last_method, :product_type_id => @product_type_id, :status_id => @status_id, :location_id => @location_id
     else
      @product_types = ProductType.find(:all)
      @collection_years = ((Date.today.year-10)..(Date.today.year)).sort.reverse           
      render :action => :edit 
    end

  end
  
  def sales
    ########## START GET PARAMS
    if has_role?("manager")
      @location_id = params[:location_id]
    else
      @location_id = current_user.location_id
    end 
       
    @date_from = Date.parse(params[:date_from]) unless params[:date_from].blank?
    @date_from ||= Date.today.beginning_of_week
    @date_to = Date.parse(params[:date_to]) unless params[:date_to].blank?
    @date_to ||= Date.today + 1.day
    
    ########## END GET PARAMS
    
    @title = "Продажби и Връщания на стока"
    
    @locations_select_list = Location.by_alias
    
    conditions = {}
  
    conditions = conditions.merge(
      {:location_id => @location_id}
    ) unless @location_id.blank?
    
    #(DATE(created_at) BETWEEN '#{@date_from}' AND '#{@date_to}')
    conditions = conditions.merge(
      {:created_at => (@date_from - 1.day)..(@date_to)}
    ) unless (@date_from.blank? || @date_to.blank?)

      
      @results = ItemOperation.sales_and_returns.by_date.find(
        :all, 
        :conditions => conditions
      )

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
		@product = Product.find(params[:id])
  end
	
  
  def destroy
    @product = Product.find(params[:id])
		
    #BACK PARAMS
    @status_id = params[:status_id]
    @city_id = params[:city_id]
    @product_type_id = params[:product_type_id]    
    @user_id = params[:user_id]
    @page = params[:page]
		@sort = params[:sort]
		@last_method = params[:last_method]		
		@product_type_id = params[:product_type_id]
		@location_id = params[:location_id] 
		
		#for tableSorter Pager
		@sort_direction = params[:sort_direction]
		@sort_column = params[:sort_column]
		@last_page = params[:last_page] 
		@search_string = params[:search_string]

 
    @product.update_attribute(:status_id, 2)    
    redirect_to :action => @last_method, :sort_direction => @sort_direction, :sort_column => @sort_column, :last_page => @last_page, :search_string => @search_string, :page => @page, :sort => @sort, :last_method => @last_method, :product_type_id => @product_type_id, :status_id => @status_id, :location_id => @location_id  
  end
  

  private
  
  def check_permissions
    if !has_permissions?(self.controller_name, self.action_name)
      redirect_to root_path
    end
  end
	
  
end
