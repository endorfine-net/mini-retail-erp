class RequestsController < ApplicationController

  layout "application", :only => [:index]

  before_filter :check_permissions

  def index
    ########## START GET PARAMS
    @page = (params[:page].blank?) ? 1 : params[:page]
    @per_page = (params[:per_page].blank?) ? 20 : params[:per_page]
    @sort = (params[:sort].blank?) ? 'id DESC' : params[:sort]

    @location_id = params[:location_id]
    @user_id = params[:user_id]
    @request_status_id = params[:request_status_id]
    @date_from = Date.parse(params[:date_from]) unless params[:date_from].blank?
    @date_to = Date.parse(params[:date_to]) unless params[:date_to].blank?
    @source_location_id = params[:source_location_id]
    @destination_location_id = params[:destination_location_id]
    @sproduct_code = (params[:product_code].blank?) ? "" : params[:product_code]
    @search_note = (params[:search_note].blank?) ? "" : params[:search_note]
    ########## END GET PARAMS

    ######### Collections for toolbar
    @users_select_list = User.by_alias
    @locations_select_list = Location.by_alias
    @request_statuses_select_list = RequestStatus.find(:all)
    ######### Collections for toolbar

    @title = "Заявки за доставка"

    conditions = {}

    if !has_role?("manager")
      @location_id = current_user.location_id unless @location_id.blank?
      @user_id = current_user.id unless @user_id.blank?
    end
    conditions = conditions.merge(
        {:location_id => @location_id}
    ) unless @location_id.blank?

    conditions = conditions.merge(
        {:user_id => @user_id}
    ) unless @user_id.blank?


    conditions = conditions.merge(
        {:request_status_id => @request_status_id}
    ) unless @request_status_id.blank?

    conditions = conditions.merge(
        {:created_at => (@date_from - 1.day)..(@date_to)}
    ) unless (@date_from.blank? || @date_to.blank?)

    conditions = conditions.merge(
        {:source_location_id => @source_location_id}
    ) unless @source_location_id.blank?

    conditions = conditions.merge(
        {:destination_location_id => @destination_location_id}
    ) unless @destination_location_id.blank?


    @requests = Request.search_note(@search_note).search_product_code(@product_code).paginate(
        :page => @page,
        :per_page => @per_page,
        :conditions => conditions,
        :order => order_value(@sort)
    )

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def create
    #AJAX method
    @item_quantity = ItemQuantity.find(params[:item_quantity_id]) #source item quantity
    @product = @item_quantity.item.product
    @locations = Location.by_alias
    @location_id = params[:location_id] #target location id
    @datetime = Time.parse(params[:datetime]) unless params[:datetime].blank?
    @note = params[:note]

    if params[:quantity].to_i > 0

      item = @item_quantity.item
      target_location = Location.find(params[:location_id])
      request = Request.new({
                                :user_id => current_user.id,
                                :location_id => current_user.location_id,
                                :request_status_id => 1, #Нова заявка
                                :source_location_id => @item_quantity.location_id,
                                :destination_location_id => @location_id,
                                :item_quantity_id => @item_quantity.id,
                                :product_code => @product.product_code,
                                :quantity => params[:quantity].to_i,
                                :note => @note
                            })

      if request.valid? && request.save
        @message = "Информацията е запазена успешно"
        log_action({:location_id => request.location_id, :source_location_id => request.source_location_id, :destination_location_id => target_location.id, :action_type => "ITEM_REQUEST", :affected_entity_type => "item", :affected_entity_id => item.id, :quantity => request.quantity, :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}, Статус: #{request.request_status.alias}", :note => @note})
        render "items/show_request_dialog"
        return true
      else
        @error_message = 'Грешка при запазване информацията ' + request.errors.full_messages
        render "items/show_request_dialog"
        return false
      end


    else
      @error_message = "Няма наличност от този артикул"
      render "items/show_request_dialog"
      return false
    end

  end

  def show_update_dialog
    @request = Request.find(params[:id])
    @product = @request.item_quantity.item.product
    allowed_request_statuses = []
    if has_role?("location_manager")
      allowed_request_statuses = [5]
    end
    if has_role?("storageman")
      allowed_request_statuses = [2, 3, 4]
    end
    if has_role?("manager")
      allowed_request_statuses = [2, 3, 4, 5]
    end
    @request_statuses_select_list = RequestStatus.find_all_by_id(allowed_request_statuses)
  end

  def update
    #AJAX method
    @request = Request.find(params[:id])
    @request_status_id = params[:request_status_id]
    @item_quantity = ItemQuantity.find(@request.item_quantity_id) #source item quantity
    @product = @item_quantity.item.product

    allowed_request_statuses = []
    if has_role?("location_manager")
      allowed_request_statuses = [5]
    end
    if has_role?("storageman")
      allowed_request_statuses = [2, 3, 4]
    end
    if has_role?("manager")
      allowed_request_statuses = [2, 3, 4, 5]
    end
    @request_statuses_select_list = RequestStatus.find_all_by_id(allowed_request_statuses)

    if @request.request_status_id != 5 # Необновяваме заявки със настоящ статус Потвърдена

      if @request_status_id.to_i == 5 #Нов статус - Потвърдена

        if @item_quantity.amount_current - @request.quantity >= 0

          item = @item_quantity.item
          target_item_quantity = ItemQuantity.find(:first, :conditions => {:item_id => item.id, :location_id => @request.destination_location_id})

          target_location = Location.find(@request.destination_location_id)

          if !target_item_quantity.nil?
            target_item_quantity.amount_delivered += @request.quantity
            target_item_quantity.amount_current += @request.quantity
          else
            target_item_quantity = ItemQuantity.new({:product_id => item.product_id, :item_id => item.id, :location_id => @request.destination_location_id, :is_delivered => true, :amount_delivered => @request.quantity, :amount_current => @request.quantity})
          end


          if target_item_quantity.valid? && target_item_quantity.save
            @item_quantity.amount_delivered -= @request.quantity
            @item_quantity.amount_current -= @request.quantity

            if @item_quantity.valid? && @item_quantity.save

              @request.update_attribute(:request_status_id, @request_status_id)

              log_action({
                             :location_id => @item_quantity.location_id,
                             :source_location_id => @item_quantity.location,
                             :destination_location_id => target_location.id,
                             :action_type => "ITEM_REQUEST",
                             :affected_entity_type => "item",
                             :affected_entity_id => item.id,
                             :quantity => @request.quantity,
                             :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}, Статус: #{@request.request_status.alias}",
                             :note => @request.note
                         })

              log_action({
                             :location_id => @item_quantity.location_id,
                             :source_location_id => @item_quantity.location,
                             :destination_location_id => target_location.id,
                             :action_type => "ITEM_TRANSFER",
                             :affected_entity_type => "item",
                             :affected_entity_id => item.id,
                             :quantity => @request.quantity,
                             :human_readable_text => "#{@product.product_code}, #{item.color.alias}, No.#{item.size}",
                             :note => @request.note
                         })
              @message = "Информацията е запазена успешно"
              render "requests/show_update_dialog"
              return true

            else
              @error_message = 'Грешка при запазване информацията ' + target_item_quantity.errors.full_messages
              render "requests/show_update_dialog", :status => 400
              return false
            end

          else
            @error_message = 'Грешка при запазване информацията ' + target_item_quantity.errors.full_messages
            render "requests/show_update_dialog", :status => 400
            return false
          end

        else
          @error_message = "Няма наличност от този артикул"
          render "requests/show_update_dialog", :status => 400
          return false
        end

      else #Статуси, различни от Потвърдена
        @request.update_attribute(:request_status_id, @request_status_id)
        @message = "Информацията е запазена успешно"
        log_action({
                       :location_id => current_user.location_id,
                       :source_location_id => @request.source_location_id,
                       :destination_location_id => @request.destination_location_id,
                       :action_type => "ITEM_REQUEST",
                       :affected_entity_type => "item",
                       :affected_entity_id => @item_quantity.item.id,
                       :quantity => @request.quantity,
                       :human_readable_text => "#{@product.product_code}, #{@item_quantity.item.color.alias}, No.#{@item_quantity.item.size}, Статус: #{@request.request_status.alias}",
                       :note => @request.note
                   })
        render "requests/show_update_dialog"
        return true
      end

    else #Заявена промяна на заявка, която е вече потвърдена
      @error_message = "Тази заявка вече е била потвърдена"
      render "requests/show_update_dialog", :status => 400
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
