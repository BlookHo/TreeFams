class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'


  # All profiles in user's tree
  def index
  end


  
  def show
  end


  def search
  end


end
