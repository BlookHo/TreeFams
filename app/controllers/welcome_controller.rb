class WelcomeController < ApplicationController

  helper_method :current_step, :steps


  # Landing page
  def index
  end

  # Начало ввода ближнего круга
  def start
  end


  def go_to_step
    steps.include? params[:step] ? @current_step = params[:step] : current_step
    render :start
  end


  private

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[self parents brothers_and_sisters couple children]
  end

  def next_step
    @current_step = steps[steps.index(@current_step)-1]
  end

  def prev_step
    @current_step = steps[steps.index(@current_step)-1]
  end


end
