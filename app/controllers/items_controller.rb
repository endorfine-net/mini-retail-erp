class ItemsController < ApplicationController
  layout false
  
  before_filter :check_permissions
  
  # GET /products
  	
  
  def show_sale_dialog
    @item_operation = ItemOperation.new()
    @payment_types = PaymentType.find(:all)
    @item_quantity = ItemQuantity.find(params[:id])
    @product = @item_quantity.item.product
  end
  
  def sale
    #AJAX method
    
    @item_quantity = ItemQuantity.find(params[:item_quantity_id]) #source item quantity
    item = @item_quantity.item
    @product = @item_quantity.item.product
    @exchange_only = params[:exchange_only]
    @item_operation = ItemOperation.new()
    @payment_types = PaymentType.find(:all)
    
    @datetime = Time.parse(params[:datetime]) unless params[:datetime].blank?
    
    if @item_quantity.amount_current > 0
      @item_operation.item_id = @item_quantity.item_id
      @item_operation.user_id = current_user.id
      @item_operation.location_id = @item_quantity.location_id
      @item_operation.item_operation_type_id  = 1 #sale 
      @item_operation.payment_type_id = params[:payment_type]
      location = Location.find(@item_operation.location_id)
      
      if(!@exchange_only.nil? && @exchange_only == "true")
        @item_operation.price = 0
      else
        @item_operation.price = params[:price].to_d
      end

      @item_operation.default_price = item.price
      @item_operation.note = params[:note]
      
      if !@datetime.nil? && has_role?("manager")
         @item_operation.created_at = @item_operation.updated_at = @datetime   
      end
  
      if @item_operation.valid? && @item_operation.save  
        
        @item_quantity.amount_current -= 1
        
          if @item_quantity.valid? && @item_quantity.save  
            
            item.total_in_stock -= 1
            
            if item.valid? && item.save  
              if(!@exchange_only.nil? && @exchange_only == "true")
                log_action({:location_id => @item_operation.location_id, :action_type => "EXCHANGE_GIVE", :affected_entity_type => "item", :affected_entity_id => item.id,
                            :note => @item_operation.note, :price => 0, :quantity => 1, :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}"})
              else
                log_action({:location_id => @item_operation.location_id, :action_type => "SALE",          :affected_entity_type => "item", :affected_entity_id => item.id,
                            :note => @item_operation.note, :price => @item_operation.price, :quantity => 1, :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}"}, :default_price => item.price)
              end 
               @message = "Информацията е запазена успешно"
              render :action => :show_sale_dialog
              return true   
            else
               @error_message = 'Грешка при запазване информацията ' + item.errors.full_messages
              render :action => :show_sale_dialog
              return false 
            end
                 
          else
            @error_message = 'Грешка при запазване информацията ' + @item_quantity.errors.full_messages
            render :action => :show_sale_dialog, :status => 400
            return false
          end
          
        else
          @error_message = 'Грешка при запазване информацията ' + @item_operation.errors.full_messages
          render :action => :show_sale_dialog, :status => 400
          return false
        end
     else
          @error_message = 'Няма наличност от този артикул'
          render :action => :show_sale_dialog, :status => 400
          return false
     end
    
  end
  
  
  def show_exchange_dialog
    @item_operation = ItemOperation.new()
    @item_quantity = ItemQuantity.find(params[:id])
    @product = @item_quantity.item.product
    @operations = ItemOperationType.without_sale
  end
  
  def exchange
    #AJAX method
    
    @operations = ItemOperationType.without_sale
    @item_quantity = ItemQuantity.find(params[:item_quantity_id]) #source item quantity
    item = @item_quantity.item
    @product = @item_quantity.item.product
    @operation_id = params[:operation_id]
    @datetime = Time.parse(params[:datetime]) unless params[:datetime].blank?
    
    @item_operation = ItemOperation.new()
    @item_operation.item_id = @item_quantity.item_id
    @item_operation.user_id = current_user.id
    @item_operation.location_id = @item_quantity.location_id
    @item_operation.item_operation_type_id  = params[:operation_id].to_i

    #Check if there is operation_id and it is 2 or 3
    if @item_operation.item_operation_type_id.nil? || !([2,3].include?(@item_operation.item_operation_type_id))
      @error_message = 'Грешка при запазване информацията ' + @item_quantity.errors.full_messages
      render :action => :show_exchange_dialog, :status => 400
      return false
    end

    if(params[:operation_id].to_i == 3)
      @item_operation.price = (params[:price].to_d * (-1)) 
    else
      @item_operation.price = 0
    end

    @item_operation.default_price = item.price
    @item_operation.note = params[:note]
    
    if !@datetime.nil? && has_role?("manager")
         @item_operation.created_at = @item_operation.updated_at = @datetime   
      end

    if @item_operation.valid? && @item_operation.save  
      
      @item_quantity.amount_current += 1
      
        if @item_quantity.valid? && @item_quantity.save  
          
          item.total_in_stock += 1
          
          if item.valid? && item.save   
                
              if(@item_operation.item_operation_type_id == 3)
                log_action({:location_id => @item_operation.location_id, :action_type => "REFUND", :affected_entity_type => "item", :affected_entity_id => item.id, :note => @item_operation.note,
                            :price => @item_operation.price, :quantity => 1, :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}", :default_price => @item_operation.default_price })
              else
                log_action({:location_id => @item_operation.location_id, :action_type => "EXCHANGE_TAKE", :affected_entity_type => "item", :affected_entity_id => item.id,
                            :note => @item_operation.note, :price => @item_operation.price, :quantity => 1, :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}"})
              end
                 
            @message = "Информацията е запазена успешно"
            render :action => :show_exchange_dialog
            return true   
          else
             @error_message = 'Грешка при запазване информацията ' + item.errors.full_messages
            render :action => :show_exchange_dialog, :status => 400
            return false 
          end
               
        else
          @error_message = 'Грешка при запазване информацията ' + @item_quantity.errors.full_messages
          render :action => :show_exchange_dialog, :status => 400
          return false
        end
        
      else
        @error_message = 'Грешка при запазване информацията ' + @item_operation.errors.full_messages
        render :action => :show_exchange_dialog, :status => 400
        return false
      end
    
  end
  
  
  def show_add_dialog
    @product = Product.find(params[:id])
    @colors = Color.find(:all)
    @locations = Location.by_alias
    @amount = ""
  end
  
  
  def add
    #AJAX method
      @product = Product.find(params[:product_id])
      @colors = Color.find(:all)
      
      @amount = params[:amount]
      
      @locations = Location.by_alias
      @location_id = has_role?("manager")? params[:location_id] : warehouse.id #target location id
      @datetime = Time.parse(params[:datetime]) unless params[:datetime].blank?
      
      item_params = {}
      item_params[:product_id] = params[:product_id]
      item_params[:color_id] = params[:color_id]
      item_params[:size] = params[:size]
      item_params[:price] = params[:price]
      item_params[:old_price] = params[:price]
      item_params[:delivery_price] = params[:delivery_price]
      
      item_params[:total_in_stock] = params[:amount]
      item_params[:total_delivered] = params[:amount]
  
      
      item = Item.find(:first, :conditions => {:product_id => item_params[:product_id], :color_id => item_params[:color_id], :size => item_params[:size]})
      if !item.nil?
        if item.total_delivered.nil?
          item.total_delivered = params[:amount].to_i
        else
          item.total_delivered += params[:amount].to_i
        end
        if item.total_in_stock.nil?
          item.total_in_stock = params[:amount].to_i
        else
          item.total_in_stock += params[:amount].to_i
        end
        
        if !item_params[:price].blank?
          item.old_price = item.price
          item.price = item_params[:price]
        end
        
        if !item_params[:delivery_price].blank?
          item.delivery_price = item_params[:delivery_price]
        end
              
      else
        item = Item.new(item_params)
        if !@datetime.nil? && has_role?("manager")
          item.created_at = item.updated_at = @datetime   
        end
      end 
     
      if item.valid? && item.save  
        
        item_quantity = ItemQuantity.find(:first, :conditions => {:item_id => item.id, :location_id => @location_id})
        
        if !item_quantity.nil?
          if item_quantity.amount_delivered.nil?
            item_quantity.amount_delivered = params[:amount].to_i
          else
            item_quantity.amount_delivered += params[:amount].to_i
          end
          if item_quantity.amount_current.nil?
            item_quantity.amount_current = params[:amount].to_i
          else
            item_quantity.amount_current += params[:amount].to_i
          end       
        else 
          item_quantity = ItemQuantity.new({:item_id => item.id, :product_id => params[:product_id], :location_id => @location_id, :is_delivered => true, :amount_delivered => params[:amount], :amount_current => params[:amount].to_i}) 
        end
        
        if !@datetime.nil? && has_role?("manager")
          item_quantity.created_at = item_quantity.updated_at = @datetime   
        end
        
        if !item_quantity.valid? || !item_quantity.save                    
          @error_message = 'Грешка при запазване количествата ' + item_quantity.errors.full_messages
          @item = item 
          render :action => :show_add_dialog
          return false
        end
  
          @message = 'Информацията е запазена успешно'  
          log_action({:location_id => @location_id, :action_type => "ITEM_ADD", :affected_entity_type => "item", :affected_entity_id => item.id, :quantity => params[:amount], :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}"})         
          @item = item 
          render :action => :show_add_dialog
          return true
          
        else
          @error_message = 'Грешка при запазване на артикул:' + item.errors.full_messages
          @item = item 
          render :action => :show_add_dialog
          return false
        end      
  end
  
  def show_edit_dialog
    @item_quantity = ItemQuantity.find(params[:id])
    @product = @item_quantity.item.product
  end
  
   def edit
    #AJAX method
      
      @item_quantity = ItemQuantity.find(params[:item_quantity_id])
      @product = @item_quantity.item.product
      item = @item_quantity.item
      @datetime = Time.parse(params[:datetime]) unless params[:datetime].blank?
      
      new_item_quantity_amount_current = params[:amount_current].to_i
      new_item_quantity_amount_delivered = params[:amount_delivered].to_i
      
      new_item_delivery_price = params[:delivery_price].to_d
      new_item_price = params[:price].to_d
      
      if new_item_quantity_amount_current > new_item_quantity_amount_delivered
        @error_message = "'Наличност' не може да е по-голяма от 'Доставени'"
        render :action => :show_edit_dialog
        return false
      end
         
      if @item_quantity.amount_current != new_item_quantity_amount_current
          item.total_in_stock += (new_item_quantity_amount_current - @item_quantity.amount_current)         
          @item_quantity.amount_current = new_item_quantity_amount_current
      end
      
      if @item_quantity.amount_delivered != new_item_quantity_amount_delivered 
          item.total_delivered += (new_item_quantity_amount_delivered - @item_quantity.amount_delivered)
          @item_quantity.amount_delivered = new_item_quantity_amount_delivered
      end
      
      if item.price != new_item_price
        #item.old_price = item.price  #Set last prise to item.old_price
        item.price = new_item_price
      end
      
      item.delivery_price = new_item_delivery_price  
      
      if !@datetime.nil? && has_role?("manager")
        item.created_at = item.updated_at = @datetime   
      end

      if item.valid? && item.save  
        if !@datetime.nil? && has_role?("manager")
          @item_quantity.created_at = @item_quantity.updated_at = @datetime   
        end
          if @item_quantity.valid? && @item_quantity.save  
             @message = "Промените са запазени успешно"
             log_action({:location_id => warehouse.id, :action_type => "ITEM_UPDATE", :affected_entity_type => "item", :affected_entity_id => item.id, :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}. Стойности: продажна цена: #{item.price}лв, наличност: #{@item_quantity.amount_current}, доставени: #{@item_quantity.amount_delivered}."})         
             render :action => :show_edit_dialog
             return true      
          else
             @error_message = "Грешка при запазване на промените"
             render :action => :show_edit_dialog, :status => 400
             return false
          end
      else
         @error_message = "Грешка при запазване на промените"
         render :action => :show_edit_dialog, :status => 400
         return false
      end      
  end

  def show_multi_edit_dialog
    @item = Item.find(params[:id])
    @product = @item.product
  end

  def edit_multiple_items
        #AJAX method
      
      @item = Item.find(params[:item_id])
      @product = @item.product
      
      new_item_price = params[:price].to_d
      @item.price = new_item_price

      @scope_type = params[:scope_type]
       
      case @scope_type
        when "self"
          items = Item.find(
            :all, 
            :conditions => {
              :id => @item.id
            })
        when "same_product"
          items = @product.items
        when "same_product_with_same_color"
          items = Item.find(
            :all, 
            :conditions => {
              :product_id => @product.id, 
              :color_id => @item.color_id
            })
        when "same_product_with_same_size"
          items = Item.find(
            :all, 
            :conditions => {
              :product_id => @product.id, 
              :size => @item.size
            })     
      end 

      items.each do |item|
          item.price = new_item_price
          if item.valid? && item.save   
              @message = "Промените са запазени успешно"
              log_action({:location_id => warehouse.id, :action_type => "ITEM_UPDATE", :affected_entity_type => "item", :affected_entity_id => item.id, :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}. Продажна цена: #{item.price}лв."})         
          else
              @error_message = "Грешка при запазване на промените"
              return false
          end
      end #end of items.each
      render :action => :show_multi_edit_dialog
  end

  def show_request_dialog
    @item_quantity = ItemQuantity.find(params[:id])
    @product = @item_quantity.item.product
    @locations = Location.by_alias.find(:all, :conditions => ["id <> #{@item_quantity.location_id}"])
    if !has_role?("manager")
      @location_id =  current_user.location_id
      @is_disabled = "disabled"
      @is_disabled_class = "disabledFormElement"
    else
      @is_disabled = false
      @is_disabled_class = ""
    end
  end

  def show_deliver_dialog
    @item_quantity = ItemQuantity.find(params[:id])
    @product = @item_quantity.item.product
    @locations = Location.by_alias.find(:all, :conditions => ["id <> #{@item_quantity.location_id}"])
  end
  
  def deliver
    #AJAX method
    @item_quantity = ItemQuantity.find(params[:item_quantity_id]) #source item quantity
    @product = @item_quantity.item.product      
    @locations = Location.by_alias
    @location_id = params[:location_id] #target location id
    @datetime = Time.parse(params[:datetime]) unless params[:datetime].blank?
    
    if params[:amount].to_i > 0      
      
      item = @item_quantity.item
      target_item_quantity = ItemQuantity.find(:first, :conditions => {:item_id => item.id, :location_id => params[:location_id]})
      
      target_location = Location.find(params[:location_id])
      
      if !target_item_quantity.nil?
        target_item_quantity.amount_delivered += params[:amount].to_i
        target_item_quantity.amount_current += params[:amount].to_i
      else 
        target_item_quantity = ItemQuantity.new({:product_id => item.product_id, :item_id => item.id, :location_id => @location_id, :is_delivered => true, :amount_delivered => params[:amount].to_i, :amount_current => params[:amount].to_i}) 
      end
      
      
      if target_item_quantity.valid? && target_item_quantity.save  
        @item_quantity.amount_delivered -= params[:amount].to_i
        @item_quantity.amount_current -= params[:amount].to_i
        
        if @item_quantity.valid? && @item_quantity.save            
          @message = "Информацията е запазена успешно"
          log_action({:datetime => @datetime, :location_id => @item_quantity.location_id, :source_location_id => @item_quantity.location, :destination_location_id => target_location.id, :action_type => "ITEM_TRANSFER", :affected_entity_type => "item", :affected_entity_id => item.id, :quantity => params[:amount], :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}"})         
          render :action => :show_deliver_dialog
          return true   
        else
           @error_message = 'Грешка при запазване информацията ' + target_item_quantity.errors.full_messages
          render :action => :show_deliver_dialog, :status => 400
          return false 
        end
             
      else
        @error_message = 'Грешка при запазване информацията ' + target_item_quantity.errors.full_messages
        render :action => :show_deliver_dialog, :status => 400
        return false
      end
    
    else
      @error_message = "Няма наличност от този артикул"
      render :action => :show_deliver_dialog, :status => 400
      return false
    end

  end
  
 
 
  private
  
  def check_permissions
    if !has_permissions?(self.controller_name, self.action_name)
      redirect_to root_path
    end
  end
	
  
end
