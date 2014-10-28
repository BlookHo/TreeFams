class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'

  # User home page
  def index
  end


  # Search results courusel
  def search
  end


end
