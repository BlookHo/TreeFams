class CirclesController < ApplicationController

  before_filter :logged_in?

  def show
    @author = Profile.find(params[:id])
    @circle  = @author.circle(current_user.id)
  end

end
