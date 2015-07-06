module Meteor
  module V1
    module Profiles
      class ProfilesDestroyController < MeteorController

          before_filter :authenticate

          def destroy
            current_user = @current_user
            @profile = Profile.where(id: params[:profile_id]).first

            if @profile.user.present? && @profile.tree_circle(current_user.get_connected_users, @profile.id).size > 0
              @error = {errorCode: 10, message: "Вы можете удалить только последний профиль в цепочке который не принадлежит зарегестрированному пользователю."}
            else
               ProfileKey.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)

               tree_row = Tree.where(is_profile_id: params[:profile_id])
               new_relation_id = tree_row[0].relation_id
               # logger.info "In Profiles_contr destroy: Before delete Tree  new_relation_id = #{new_relation_id} "
               # Профиль, от которого растет удаляемый (?)
               base_profile = Profile.find(tree_row[0].profile_id)  #

               Tree.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
               # todo: не удалять ProfileData?
               # ProfileData.where(profile_id: @profile.id).map(&:destroy)
               ProfileData.where(profile_id: @profile.id).each do |pd|
                 pd.destroy
               end
               # @profile.destroy # Не удаляем профили, чтобы иметь возм-ть повторить создание удаленных профилей

               # logger.info "In Profiles_contr destroy: Before create_add_log"
               current_log_type = 2  #  # delete : rollback == add. Тип = удаление нового профиля при rollback
               new_log_number = CommonLog.new_log_id(base_profile.tree_id, current_log_type)

               common_log_data = { user_id:         base_profile.tree_id,
                                   log_type:        current_log_type,
                                   log_id:          new_log_number,
                                   profile_id:      params[:profile_id],
                                   base_profile_id: base_profile.id,
                                   new_relation_id: new_relation_id  }
               # logger.info "In add_new_profile: Before create_add_log   common_log_data = #{common_log_data}"
               CommonLog.create_common_log(common_log_data)

               ##########  UPDATES FEEDS - № 18  # destroy ###################
               update_feed_data = { user_id:           current_user.id,    #
                                    update_id:         18,                  #
                                    agent_user_id:     base_profile.tree_id,   #
                                    read:              false,              #
                                    agent_profile_id:  params[:profile_id],        #
                                    who_made_event:    current_user.id }   #
               logger.info "In Profile controller: Before destroy UpdatesFeed   update_feed_data= #{update_feed_data} "
               UpdatesFeed.create(update_feed_data) #

               # Mark profile as deleted
               @profile.update_attribute('deleted', 1)

            end
            # response = @error ? {status: 403, message: @error} : {status: 200, message: "Профиль удален"}
            # logger.info "=================="
            # logger.info response

            if @error
              respond_with @error
            else
              respond_with(status:200)
            end
          end





      end
    end
  end
end
