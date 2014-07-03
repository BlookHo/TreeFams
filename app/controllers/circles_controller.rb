class CirclesController < ApplicationController

  before_filter :logged_in?


  def show
    get_current_profile_id
    rebuild_path_params(current_user.profile_id)
    collect_path
    @author = Profile.find(@current_profile_id)
    @circle  = @author.circle(current_user.id)
  end


  def show_search
    @path_author = User.find(params[:tree_id])
    get_current_profile_id
    rebuild_path_params(@path_author.profile_id)
    collect_path
    @author = Profile.find(@current_profile_id)
    @circle  = @author.circle(params[:tree_id])
    @final_reduced_relations_hash = session[:final_reduced_relations_hash]
  end


  private

  def rebuild_path_params(current_user_profile_id)
    incoming_path_profiles = []
    incoming_path_segments = []

    params[:path].split('-').each do |segment|
      incoming_path_profiles << segment.split(',').first
    end

    params[:path].split('-').each do |segment|
      incoming_path_segments << segment
    end

    # remove last element (last element is currently showing profile)
    incoming_path_profiles.pop

    # if current profile is current_user's profile
    # reset path
    # if @current_profile_id.to_i == current_user.profile_id.to_i
    if @current_profile_id.to_i == current_user_profile_id.to_i
      return @path_params = nil
    end

    # if path already include current profile
    # trim path to that profile
    if incoming_path_profiles.include? @current_profile_id
      last_index = incoming_path_profiles.index(@current_profile_id.to_s)
      return @path_params = incoming_path_segments[0..last_index].join('-')
    else
      return @path_params = params[:path]
    end
    # return @path_params = params[:path]
  end


  def get_current_profile_id
    @current_profile_id = params[:path].split('-').last.split(',').first
  end


  def collect_path
    return [] if @path_params.nil?
    result = []
    profiles = collect_path_profiles(collect_path_profiles_ids)
    relations = collect_path_relation_ids
    profiles.each_with_index do |profile, index|
      result << Hashie::Mash.new( {profile_id: profile.id,
                                   relation_id: relations[index],
                                   name: profile.to_name,
                                   link: segment_by_index(index)
                                   })
    end
    return @path = result#.reverse!
  end


  def collect_path_profiles_ids
    return [] if @path_params.nil?
    profile_ids = []
    @path_params.split('-').each do |segment|
      profile_ids << segment.split(',').first
    end
    return profile_ids
  end


  def collect_path_relation_ids
    return [] if @path_params.nil?
    relation_ids = []
    @path_params.split('-').each do |segment|
      relation_ids << segment.split(',').last
    end
    return relation_ids
  end


  def collect_path_profiles(profiles_ids)
    return [] if @path_params.nil?
    profiles = Profile.where(id: profiles_ids).includes(:name)
    sorted_profiles = profiles_ids.collect {|id| profiles.detect {|p| p.id == id.to_i } }
    return sorted_profiles
  end

  def segment_by_index(index)
    params[:path].split('-')[0..index].join('-')
  end



end
