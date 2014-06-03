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
    sign_in(:user, User.find(params[:user_id]))
    redirect_to :main_page
  end

  # Landing page
  def index
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
      if last_step? and step_valid? and current_author.email
        redirect_to :user_registration
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
    if member.valid?
      member.errors.clear
      session[:current_author] = current_author
      return true
    else
      session[:current_author] = current_author
      return false
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
