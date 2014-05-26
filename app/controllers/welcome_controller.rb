class WelcomeController < ApplicationController

  helper_method :current_step,
                :current_author,
                :steps,
                :next_step,
                :prev_step,
                :first_step?,
                :last_step?

  # Small fix for development enveronment
  before_filter do
    Member if Rails.env == 'development'
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
    proceed_data
    session[:current_step] = next_step if step_valid?
    render :start
  end

  def previous
    session[:current_step] = prev_step unless first_step?
    render :start
  end


  private

  def step_valid?
     first_step? ? validate_member(current_author) : validate_family
  end

  # def validate_author
  #   if current_author.valid?
  #     current_author.errors.clear
  #     session[:current_author] = current_author
  #     return true
  #   else
  #     session[:current_author] = current_author
  #     return false
  #   end
  # end

  def validate_family
    eval("current_author.family.#{current_step}").each do |member|
      validate_member(member)
    end
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
    current_author.name = params[:author][:name]
    session[:current_author] = current_author
  end

  def proceed_family
    members = params[:author][current_step.to_sym]
    members.each do |member|
      current_author.add_member( eval "#{current_step.singularize.capitalize}.new(name: member[:name])" )
    end
    session[:current_author] = current_author
  end

  def current_author
    @current_author ||= session[:current_author] || Author.new
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
       daughter
       email]
  end

  def first_step?
    steps.first == current_step
  end

  def last_step?
    steps.last == current_step
  end

end
