class WelcomeController < ApplicationController

  helper_method :current_step,
                :steps,
                :next_step,
                :prev_step,
                :names,
                :current_circle,
                :'first_step?',
                :'last_step?',
                :'errors?',
                :errors

  before_filter :collect_names, except: :index

  # Landing page
  def index
    session[:current_step] = nil
    session[:current_circle] = nil
  end

  # Форма регистрации
  def start
  end

  # Обработка формы
  def proceed
    # validate_step
    merge_data(params[:circle])
    if step_is_valid?
      session[:current_step] = next_step
    end
    render :start
  end

  # Переход на шаг формы
  def go_to_step
    steps.include? params[:step] ? (session[:current_step] = params[:step]) : current_step
    render :start
  end


  private

  # validation methods
  def step_is_valid?
    if is_required_step? and name_present? and name_valid?
       clear_errors
       return true
    else
      return false
    end
  end

  def name_present?
    if current_circle.send(current_step.to_sym).blank?
      add_error(name: "blank_name", message: "Нужно указать имя")
      return false
    else
      return true
    end
  end

  def name_valid?
    name = Name.where(name: current_circle.send(current_step.to_sym)).first
    if !name
      logger.info "= Parse sex: ============ #{parse_sex}"
      new_name = Name.new(name: current_circle.send(current_step.to_sym), only_male: parse_sex)
      if new_name.save
        return true
      else
        add_error(name: "invalid_name", message: "Вы указали новое имя, пожалуйста, уточните пол")
        return false
      end
    else
      return true
    end
  end


  def parse_sex
    if params[:circle][:author_sex] == "male"
        return true
    elsif params[:circle][:author_sex] == "female"
      return false
    else
      return nil
    end
  end


  def errors?
    current_circle.errors
  end
  alias :errors :'errors?'


  def add_error(error)
    merge_data({errors: error})
  end


  def clear_errors
    logger.info "==== Errors: #{current_circle.errors}"
    @current_circle.errors = nil
  end

  # Current welcome form data
  def current_circle
    if session[:current_circle]
      @current_circle = Hashie::Mash.new session[:current_circle]
    else
      @current_circle = Hashie::Mash.new
    end
  end

  def merge_data(data)
    session[:current_circle] = current_circle.merge data
  end

  # Form steps methods
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
    %w[author mother father have_brothers brothers have_sisters sisters have_couple couple have_children have_sons sons have_daughter daughter email]
  end

  def required_steps
    %w[author mother father]
  end

  def is_required_step?
    required_steps.include? current_step
  end

  def first_step?
    steps.first == current_step
  end

  def last_step?
    steps.last == current_step
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
