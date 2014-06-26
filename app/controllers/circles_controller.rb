class CirclesController < ApplicationController

  before_filter :logged_in?

  def show
    @author = Profile.find(get_current_profile_id)
    @circle  = @author.circle(current_user.id)
    @path = collect_path
  end


  private

  def get_current_profile_id
    params[:path].split('-').last.split(',').first
  end


  def collect_path
    result = []
    profiles = collect_path_profiles(collect_path_profiles_ids)
    relations = collect_path_relation_ids
    profiles.each_with_index do |profile, index|
      result << Hashie::Mash.new( {profile_id: profile.id, relation_id: relations[index], name: profile.to_name})
    end
    return result.reverse!
  end


  def collect_path_profiles_ids
    profile_ids = []
    params[:path].split('-').each do |segment|
      profile_ids << segment.split(',').first
    end
    return profile_ids
  end


  def collect_path_relation_ids
    relation_ids = []
    params[:path].split('-').each do |segment|
      relation_ids << segment.split(',').last
    end
    return relation_ids
  end


  def collect_path_profiles(profiles_ids)
    Profile.where(id: profiles_ids).includes(:name)
  end

end
