module Meteor
  module V1
    module Stat
      class StatController < MeteorController

        before_filter :authenticate

        def stat_common
          # roll = { status: true }

          ## ЗАПУСК
          all_site_stats = site_stats
          logger.info "In StatController: all_site_stats = #{all_site_stats} "

          # respond_with roll

          if @error
            respond_with @error
          else
            respond_with all_site_stats #.as_json(:only => [:id, :email, :access_token, :profile_id, :connected_users], :methods => [:name])
          end

        end


        def site_stats
          all_profiles = Profile.where(deleted: 0)
          all_profiles_qty = all_profiles.count
          all_profiles_male_qty = all_profiles.where(sex_id: 1).count
          all_profiles_female_qty = all_profiles.where(sex_id: 0).count
          all_users_qty = User.all.count
          all_trees_qty = User.pluck(:connected_users).uniq.length

          # logger.info "In StatController: all_profiles_qty = #{all_profiles_qty},
          # all_profiles_male_qty = #{all_profiles_male_qty},
          # all_profiles_female_qty = #{all_profiles_female_qty},
          # all_users_qty = #{all_users_qty},  all_trees_qty = #{all_trees_qty} "
          { all_profiles_qty: all_profiles_qty,
            all_profiles_male_qty: all_profiles_male_qty,
            all_profiles_female_qty: all_profiles_female_qty,
            all_users_qty: all_users_qty,
            all_trees_qty: all_trees_qty
          }

        end

      end
    end
  end
end

