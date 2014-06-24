class CirclesController < ApplicationController

  before_filter :logged_in?

  def show
    @profile = Profile.find(params[:id])
    @
  end

end
