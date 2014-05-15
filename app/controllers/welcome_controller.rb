class WelcomeController < ApplicationController

  helper_method :current_step, :steps, :next_step, :names
  before_filter :collect_names, except: :index

  # Landing page
  def index
    session[:current_step] = nil
  end


  # Форма ближнего круга
  def start
  end


  # Обработка формы
  def proceed
    session[:current_step] = next_step
    render :start
  end


  # Переход на шаг формы
  def go_to_step
    steps.include? params[:step] ? (session[:current_step] = params[:step]) : current_step
    render :start
  end



  private


  def current_step
    if session[:current_step]
      @current_step = session[:current_step]
    else
      @current_step = steps.first
    end
  end


  def next_step
    steps[steps.index(current_step)+1]
  end


  def prev_step
    steps[steps.index(current_step)-1]
  end

  def steps
    %w[self mother father have_brothers brothers have_sisters sisters have_couple couple have_children have_sons sons have_daughter daughter email]
  end


  def collect_names
    @names = []
    @names_male = []
    @names_female = []
    Name.all.each do |name|
      @names << name.name
      name.only_male ? @names_male << name.name : @names_female << name.name
    end
  end



end
