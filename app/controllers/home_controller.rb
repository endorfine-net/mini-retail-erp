class HomeController < ApplicationController

  def index
    redirect_to :controller => :products, :action => :sales
  end
  

end
