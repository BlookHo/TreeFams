module Meteor
  module V1
    module Profiles
      class ProfilesRenameController < MeteorController
        before_filter :authenticate

        def rename
          profile = Profile.where(id: params[:profileId]).first
          name = Name.where(id: params[:nameId]).first
          if profile && name && profile.rename(name.id)
            puts "In met/v1/../ProfilesRenameController: After rename: start_search_methods "

            ::SearchResults.start_search_methods_in_thread(current_user)

            respond_with(status:200)
          else
            respond_with(errorCode: 403, message:"Ошибка при переименовании профиля")
          end
        end

      end
    end
  end
end
