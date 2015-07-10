module Meteor
  module V1
    module Stat
      class StatController < MeteorController

        before_filter :authenticate

        def stat_common
          # roll = { status: true }

          ## ЗАПУСК
          all_profiles = Profiles.where(deleted: 0)
          all_profiles_qty = all_profiles.count
          all_profiles_male_qty = all_profiles.where(sex_id: 1).count
          all_profiles_female_qty = all_profiles.where(sex_id: 0).count
          logger.info "In StatController: all_profiles_qty = #{all_profiles_qty},
          all_profiles_male_qty = #{all_profiles_male_qty}, all_profiles_female_qty = #{all_profiles_female_qty},  "

          users_qty = Users.all.count


          @current_user.start_similars
          logger.info "In SimilarsController: After start_similars: @error = #{@error}  " if @error
          logger.info "In SimilarsController: After start_similars"

          # respond_with roll

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

