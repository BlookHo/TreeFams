class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'


  def index
  end


  def search
  end


end
