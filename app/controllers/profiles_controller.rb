class ProfilesController < ApplicationController

  before_filter :logged_in?

  def show
  end


  def new
  end


  def edit
    @profile = Profile.where(params[:is]).first
  end


  def create
  end


  def update
  end


  def destroy
  end
end
