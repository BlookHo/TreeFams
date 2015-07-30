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


  # @note: Start call of site stats calc
  def self.site_stats
    logger.info "In WeafamStat site_stats"

    profiles_stat_data = Profile.collect_profile_stats
    # logger.info "In WeafamStat site_stats: profiles_stat_data = #{profiles_stat_data}"
    users_stat_data = User.collect_user_stats
    # logger.info "In WeafamStat site_stats: users_stat_data = #{users_stat_data}"


    all_trees_qty = User.pluck(:connected_users).uniq.length

    # logger.info "In StatController: all_profiles_qty = #{all_profiles_qty}"
    all_stat_data = { profiles: profiles_stat_data[:profiles],
      profiles_male: profiles_stat_data[:profiles_male],
      profiles_female: profiles_stat_data[:profiles_female],
      users: users_stat_data[:users],
      users_male: users_stat_data[:users_male],
      users_female: users_stat_data[:users_female],
      all_trees_qty: all_trees_qty
    }
    logger.info "In WeafamStat site_stats: all_stat_data = #{all_stat_data}"
    all_stat_data
  end





{:profiles=>270, :profiles_male=>149, :profiles_female=>121, :users=>18, :users_male=>15, :users_female=>4, :all_trees_qty=>15}







end
