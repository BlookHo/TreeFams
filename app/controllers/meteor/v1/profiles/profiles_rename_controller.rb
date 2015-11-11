module Meteor
  module V1
    module Profiles
      class ProfilesRenameController < MeteorController
        before_filter :authenticate

        def rename
          profile = Profile.where(id: params[:profileId]).first
          name = Name.where(id: params[:nameId]).first
          if profile && name && profile.rename(name.id)
            respond_with(status:200)
          else
            respond_with(errorCode: 403, message:"Ошибка при переименовании профиля")
          end
        end

      end
    end
  end
end
