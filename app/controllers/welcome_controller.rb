class WelcomeController < ApplicationController

  helper_method :current_step,
                :current_author,
                :steps,
                :next_step,
                :prev_step,
                :first_step?,
                :last_step?

  # Small fix for development environment
  before_filter do
    Member if Rails.env =~ /development/
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
      session[:current_step] = next_step if step_valid?
      render :start
    end
  end

  def previous
    session[:current_step] = prev_step unless first_step?
    redirect_to :start
  end

  def to_step
    logger.info "=========== step debug"
    logger.info steps.include? params[:step]
    if steps.include? params[:step]
      session[:current_step] = params[:step]
    end
    render :start
  end


  private

  def step_valid?
     first_step? ? validate_member(current_author) : validate_family
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
    first_step? ? proceed_author : proceed_family
  end

  def proceed_author
    current_author.name   = params[:author][:name]
    current_author.sex_id = params[:author][:sex_id]
    session[:current_author] = current_author
  end

  def proceed_family
    members = params[:author][normolized_members_name.to_sym]
    members.each do |member|
      current_author.add_member( eval("#{normolized_members_name.singularize.capitalize}").new(name: member[:name], sex_id: member[:sex_id]) )
    end
    session[:current_author] = current_author
  end


  def normolized_members_name
    if current_step == 'couple' && current_author.male?
      return 'wives'
    elsif current_step == 'couple' && !current_author.male?
      return 'wives'
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
