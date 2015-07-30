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




  def self.create_stats_row

    stats_params = collect_site_stats
    @weafam_stat = create(stats_params)
    logger.info "In WeafamStat create_stats_row: @weafam_stat = #{@weafam_stat} "

  end

   # {:profiles=>270, :profiles_male=>149, :profiles_female=>121, :users=>18, :users_male=>14, :users_female=>4, :trees=>15}
   #
   # ["profiles", 270], ["profiles_female", 121], ["profiles_male", 149], ["trees", 15],
   # ["users", 18], ["users_female", 4], ["users_male", 14]]



#   def stats_params(all_stat_data)
#     {users: all_stat_data[:users],
#     users_male: all_stat_data[:users_male],
#     users_female: all_stat_data[:users_female],
#     profiles: all_stat_data[:profiles],
#     profiles_male: all_stat_data[:profiles_male],
#     profiles_female: all_stat_data[:profiles_female],
#     trees: all_stat_data[:trees],
#     invitations: all_stat_data[:invitations],
#     requests: all_stat_data[:requests],
#     connections: all_stat_data[:connections],
#     refuse_requests: all_stat_data[:refuse_requests],
#     disconnections: all_stat_data[:disconnections],
#     similars_found: all_stat_data[:similars_found] }
# end
#

  # @note: Start call of site weafam_stats calc
  def self.collect_site_stats
    logger.info "In WeafamStat site_stats"

    profiles_stat_data = Profile.collect_profile_stats
    # logger.info "In WeafamStat site_stats: profiles_stat_data = #{profiles_stat_data}"
    users_stat_data = User.collect_user_stats
    # logger.info "In WeafamStat site_stats: users_stat_data = #{users_stat_data}"
    trees = User.pluck(:connected_users).uniq.length
    # logger.info "In StatController: trees = #{trees}"


    all_stat_data = { profiles: profiles_stat_data[:profiles],
      profiles_male: profiles_stat_data[:profiles_male],
      profiles_female: profiles_stat_data[:profiles_female],
      users: users_stat_data[:users],
      users_male: users_stat_data[:users_male],
      users_female: users_stat_data[:users_female],
      trees: trees
    }

    # t.integer :invitations    , default: 0
    # t.integer :requests       , default: 0
    # t.integer :connections    , default: 0
    # t.integer :refuse_requests, default: 0
    # t.integer :disconnections , default: 0
    # t.integer :similars_found , default: 0



    logger.info "In WeafamStat site_stats: all_stat_data = #{all_stat_data}"
    logger.info ""
    all_stat_data
  end


{:profiles=>270, :profiles_male=>149, :profiles_female=>121, :users=>18, :users_male=>14, :users_female=>4, :trees=>15}







end
