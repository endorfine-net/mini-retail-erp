class ColorsController < ApplicationController
  
  before_filter :check_permissions
  
  def index
    @colors = Color.find :all    
    respond_to do |format|
      format.html # index.html.erb
    end    
  end

  def new
    @color = Color.new  
  end
  
  def show
      @color = Color.find(params[:id]) 
  end  

  def create
    @color = Color.new(params[:color])    
    if @color.save
      flash[:notice] = "Цвета е създаден!"
      redirect_back_or_default colors_url() 
    else
      render :action => :new
    end
  end
  
  
  def edit
    @color = Color.find(params[:id]) 
    @back = colors_url()
  end

  def update
    @color = Color.find(params[:id])
    if @color.update_attributes(params[:color])
      flash[:notice] = "Цвета е променен!"
      redirect_to colors_url()
    else
      @back = colors_url()
      render :action => :edit
    end
  end  

  
  def destroy
    color = Color.find(params[:id])   
    color.destroy()    
    redirect_to colors_url()   
  end
  
  
  
  private
  
  def check_permissions
    if !has_permissions?(self.controller_name, self.action_name)
      redirect_to root_path
    end
  end
  
end
