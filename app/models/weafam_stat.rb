class WeafamStat < ActiveRecord::Base

  # TO BE TESTED
  validates_presence_of :users, :users_male, :users_female,
                        :profiles, :profiles_male, :profiles_female,
                        :trees, :invitations,
                        :requests, :connections, :refuse_requests,
                        :disconnections, :similars_found,
                        :message => "Должно присутствовать в WeafamStat"
  validates_numericality_of :users, :users_male, :users_female,
                            :profiles, :profiles_male, :profiles_female,
                            :trees, :invitations,
                            :requests, :connections, :refuse_requests,
                            :disconnections, :similars_found,
                            :only_integer => true,
                            :message => "ID автора сообщения или получателя сообщения должны быть целым числом в WeafamStat"
  validates_numericality_of :users, :users_male, :users_female,
                            :profiles, :profiles_male, :profiles_female,
                            :trees, :invitations,
                            :requests, :connections, :refuse_requests,
                            :disconnections, :similars_found,
                            :greater_than_or_equal_to => 0,
                            :message => "ID автора сообщения или получателя сообщения должны быть больше или равно 0 в WeafamStat"



  def self.site_stats

    profiles_stat = colect_profiles

    all_profiles = Profile.where(deleted: 0)
    profiles = all_profiles.count
    profiles_male = all_profiles.where(sex_id: 1).count
    profiles_female = all_profiles.where(sex_id: 0).count

    all_users_qty = User.all.count

    all_trees_qty = User.pluck(:connected_users).uniq.length

    # logger.info "In StatController: all_profiles_qty = #{all_profiles_qty},
    # all_profiles_male_qty = #{all_profiles_male_qty},
    # all_profiles_female_qty = #{all_profiles_female_qty},
    # all_users_qty = #{all_users_qty},  all_trees_qty = #{all_trees_qty} "
    { profiles: profiles,
      profiles_male: profiles_male,
      profiles_female: profiles_female,
      all_users_qty: all_users_qty,
      all_trees_qty: all_trees_qty
    }

  end






end
