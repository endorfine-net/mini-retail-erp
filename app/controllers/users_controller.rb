class UsersController < ApplicationController
  #layout "bonsai"
  
  before_filter :check_permissions
  before_filter :user_collections
  
  def index
    #for tableSorter Pager
    @sort_direction = params[:sort_direction]
    @sort_column = params[:sort_column]
    @last_page = params[:last_page] 
    @search_string = params[:search_string]   
    @type = params[:type]
    if @type == "active"
      @users = User.online.by_alias.find :all
    elsif @type == "archive"
      @users = User.archive.by_alias.find :all
    else
      @users = User.online.by_alias.find :all 
      @type = "active"     
    end

    respond_to do |format|
      format.html # index.html.erb
    end    
  end

  def new
    @user = User.new  
  end
  
  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = @current_user    
    end
  end  

  def create
    params[:user][:password_last_set_on] = Time.now.to_s(:db)
    @user = User.new(params[:user])
    #for tableSorter Pager
    @sort_direction = params[:sort_direction]
    @sort_column = params[:sort_column]
    @last_page = params[:last_page] 
    @search_string = params[:search_string]
    @type = params[:type]
    
    if @user.save
      flash[:notice] = "Потребителя е създаден!"
      redirect_back_or_default users_url(:sort_direction => params[:sort_direction], :sort_column => params[:sort_column], :last_page => params[:last_page], :search_string => params[:search_string], :type => params[:type]) 
    else
      render :action => :new
    end
  end
  
  
  def edit
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = @current_user    
    end
    #for tableSorter Pager
    @sort_direction = params[:sort_direction]
    @sort_column = params[:sort_column]
    @last_page = params[:last_page] 
    @search_string = params[:search_string]
    @type = params[:type]  
    @back = users_url(:sort_direction => params[:sort_direction], :sort_column => params[:sort_column], :last_page => params[:last_page], :search_string => params[:search_string], :type => params[:type])
  end

  def update
    #for tableSorter Pager
    @sort_direction = params[:sort_direction]
    @sort_column = params[:sort_column]
    @last_page = params[:last_page] 
    @search_string = params[:search_string]
    @type = params[:type]
    
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = @current_user    
    end
    if !params[:user][:password].blank? 
       params[:user][:password_last_set_on] = Time.now.to_s(:db)
    end 
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Потребителя е променен!"
      if has_role?("admin")
        redirect_to users_url(:sort_direction => params[:sort_direction], :sort_column => params[:sort_column], :last_page => params[:last_page], :search_string => params[:search_string], :type => params[:type])
      else
        redirect_to home_url
      end
    else
      if has_role?("admin")
        @back = users_url(:sort_direction => params[:sort_direction], :sort_column => params[:sort_column], :last_page => params[:last_page], :search_string => params[:search_string], :type => params[:type])
      else
        @back = home_url
      end      
      render :action => :edit
    end
  end  

  
  def destroy
    user = User.find(params[:id])
    #for tableSorter Pager
    @sort_direction = params[:sort_direction]
    @sort_column = params[:sort_column]
    @last_page = params[:last_page] 
    @search_string = params[:search_string]
    @type = params[:type]
      if user.status_id == 1
        status = 2
      else  
        status = 1
      end    
      user.update_attribute(:status_id, status)
        
    redirect_to users_url(:sort_direction => params[:sort_direction], :sort_column => params[:sort_column], :last_page => params[:last_page], :search_string => params[:search_string], :type => params[:type])   
  end
  
  def user_collections
    @locations = Location.find :all
  end
  
    private
  
  def check_permissions
    if !has_permissions?(self.controller_name, self.action_name)
      redirect_to root_path
    end
  end
  
end
