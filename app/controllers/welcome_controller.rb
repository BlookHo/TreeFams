class WelcomeController < ApplicationController

  helper_method :current_step,
                :current_author,
                :normolized_members_name,
                :steps,
                :next_step,
                :prev_step,
                :first_step?,
                :last_step?


  def login_as_user
    user = User.where(id: params[:user_id]).first
    if user
      flash[:notice] = "Вы вошли как #{user.name}"
      session[:user_id] = user.id
    else
      flash[:alert] = "Пользователь не найден"
    end
    redirect_to :main_page
  end


  # Landing page
  def index
    session[:user_id] = nil
    session[:current_step] = nil
    session[:current_author] = nil
  end

  # Singup form
  def start
  end

  # Form action
  def proceed
    if request.get?
      render :start
    else
      proceed_data
      if last_step? and step_valid?
        redirect_to :save_start_tables
      else
        session[:current_step] = next_step if step_valid?
        render :start
      end
    end
  end

  def previous
    session[:current_step] = prev_step unless first_step?
    redirect_to :start
  end

  def to_step
    if steps.include? params[:step]
      session[:current_step] = params[:step]
    end
    render :start
  end


  private


  def step_valid?
     (first_step? or last_step?) ? validate_member(current_author) : validate_family
  end

  def validate_family
    results = []
    eval("current_author.family.#{normolized_members_name}").each do |member|
      results << validate_member(member)
    end
    !results.include? false
  end


  def validate_member(member)
    if member.valid? and check_email_and_create_user?(member)
      member.errors.clear
      session[:current_author] = current_author
      return true
    else
      session[:current_author] = current_author
      return false
    end
  end


  def check_email_and_create_user?(member)
    # If last step
    if last_step? and member.class.to_s == "Author"
      # check email presence
      if current_author.email.blank?
        current_author.errors.add(:email, "Нужно указать ваш действующий email адрес. На него мы вышлим пароль для доступа к сайту.")
        return false
      else
      # Create user by email
        user = User.create_with_email(current_author.email)
        if user.valid?
          logger.info "User valid! ======"
          session[:user_id] = user.id
          return true
        else
          logger.info "Save user errors! #{user.errors.inspect}"
          current_author.errors.add(:email, user.errors[:email].last)
          return false
        end
      end
    else
      return true
    end
  end




  def proceed_data
    (first_step? or last_step?) ? proceed_author : proceed_family
  end

  def proceed_author
    if first_step?
      current_author.name   = params[:author][:name]
      current_author.sex_id = params[:author][:sex_id]
    elsif last_step?
      # current_author.name = current_author.name
      # current_author.sex_id = current_author.sex_id
      current_author.email = params[:author][:email]
    end
    session[:current_author] = current_author
  end

  def proceed_family
    members = []
    members_data = params[:author][normolized_members_name.to_sym]
    members_data.each do |member|
      members << eval("#{normolized_members_name.singularize.capitalize}").new(name: member[:name], sex_id: member[:sex_id])
    end
    current_author.add_members(members)
    session[:current_author] = current_author
  end


  def normolized_members_name
    if current_step == 'couple' && current_author.male?
      return 'wives'
    elsif current_step == 'couple' && !current_author.male?
      return 'husbands'
    else
      current_step
    end
  end

  def current_author
    @current_author ||= session[:current_author] || Author.new
    @current_author
  end

  def current_step
    @current_step = session[:current_step] || steps.first
  end

  def next_step
      steps[steps.index(current_step)+1]
  end

  def prev_step
    steps[steps.index(current_step)-1]
  end

  def steps
    %w[author
       fathers
       mothers
       have_brothers
       brothers
       have_sisters
       sisters
       have_couple
       couple
       have_children
       have_sons
       sons
       have_daughter
       daughters
       email]
  end

  def first_step?
    steps.first == current_step
  end

  def last_step?
    steps.last == current_step
  end

end
