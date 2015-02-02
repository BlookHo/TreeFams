class AvatarController < ApplicationController

  def upload
    profile_data = current_user_profile_data_for_profile
    profile_data.avatar = params[:filedata]

    if profile_data.save
      render json: {status: "ok", avatar_path: profile_data.avatar_url(:thumb)}
    else
      render json: {status: "error"}
    end
  end


  private

  def current_user_profile_data_for_profile
    profile = Profile.find(params[:profile_id])
    profile_data = profile.profile_datas.where(creator_id: current_user.id).first
    if profile_data.nil?
      profile_data = profile.profile_datas.new(creator_id: current_user.id)
    end
    return profile_data
  end


end
