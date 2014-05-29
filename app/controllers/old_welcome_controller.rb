class OldWelcomeController < ApplicationController

  helper_method :current_step,
                :steps,
                :next_step,
                :prev_step,
                :names,
                :current_circle,
                :first_step?,
                :last_step?,
                :errors?,
                :errors,
                :current_step_errors?,
                :current_step_errors,
                :field_with_error?,
                :field_error_for


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
    # Get data from client
    # merge_data(params[:circle])
    # Go to next step if current is valid
    session[:current_step] = next_step  if step_is_valid?
    render :start
  end



  # переход на пред шаг формы
  def previous
    unless first_step?
      session[:current_step] = prev_step
    end
    render :start
  end


  private

  #  Методы валидации
  def step_is_valid?
    # одно обязательое имя - мама, папа, автор
    if is_required_step? and name_present? and name_valid?
       clear_current_step_errors
       return true
    else
      return false
    end
  end


  def name_present?
    if current_circle.send(current_step.to_sym).blank?
      add_error({name: "blank_name", message: "Нужно указать имя"})
      return false
    else
      return true
    end
  end



  # Валидация Одного имени
  def name_valid?
    if validate_name( current_circle.send(current_step.to_sym) )
      return true
    else
      add_error({name: "invalid_name", message: "Вы указали новое имя, пожалуйста, уточните пол"})
      return false
    end
  end


  # Валидация массива имен
  def all_names_valid?
    current_circle.send(current_step.to_sym).each do |name|
       if !validate_name(name)
         add_error({name.parameterize => {name: "invalid_name", message: "Вы указали новое имя, пожалуйста, уточните пол"}})
       end
    end
    return false
  end


  # Если имя существует в базе - ок, нет, пробуем создать
  def validate_name(name)
    if !Name.exists?(name: name)
      Name.new(name: name, only_male: get_sex).save
    else
      return true
    end
  end


  # Метод диспетчер
  # мы одназначнео знаем пол, если ввои брата или сестру
  # пол супригуи / мужа опрееляется в зависимости от пола автора
  def get_sex
    case current_step.to_s
      when "brothers" || "father"
        logger.info "brother father sex"
        return 1
      when "mother" || "sisters"
        logger.info "mother sister sex"
        return 0
      when "author"
        parse_sex
    else
      nil
    end
  end


  def parse_sex
    case params[:circle][:author_sex]
      when "male"
          return 1
      when "female"
          return 0
      else
        return nil
    end
  end



  # есть ли ошибки в поле
  # полю присваивается имя: (введенное в поле имя).parametrize
  def field_with_error?(field_name)
    current_circle.errors[current_step.to_sym][field_name.parameterize.to_sym]
  end
  alias :field_error_for :field_with_error?

  # Form has Any errors
  def errors
    current_circle.errors
  end
  alias :'errors?' :errors


  def current_step_errors
    current_circle.errors.try(:[], current_step.to_sym)
  end
  alias :'current_step_errors?' :current_step_errors


  def add_error(error)
    merge_data(:errors => {current_step => error})
  end


  def clear_current_step_errors
    @current_circle.errors[current_step] = nil if current_step_errors?
    session[:current_circle] = @current_circle
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




end
