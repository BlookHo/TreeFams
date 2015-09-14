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

  # attr_accessible :users, :users_male, :users_female,
  #                 :profiles, :profiles_male, :profiles_female,
  #                 :trees, :invitations,
  #                 :requests, :connections, :refuse_requests,
  #                 :disconnections, :similars_found

  # @note: to generate the CSV data
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |stat|
        csv << stat.attributes.values_at(*column_names)
      end
    end
  end



  def self.create_stats_row
    @weafam_stat = create(collect_site_stats)
    logger.info "In WeafamStat create_stats_row: @weafam_stat = #{@weafam_stat} "
  end


  # @note: Start call of site weafam_stats calc
  def self.collect_site_stats
    # logger.info "In WeafamStat site_stats"

    profiles_stat_data = Profile.collect_profile_stats
    users_stat_data = User.collect_user_stats
    trees = User.pluck(:connected_users).uniq.length
    requests = ConnectionRequest.all.count
    connections = ConnectionRequest.connections_amount
    refuse_requests = ConnectionRequest.connections_refuses
    invitations = Counter.first.invites
    disconnections = Counter.first.disconnects
    similars_found = SimilarsFound.all.count


    all_stat_data = { profiles: profiles_stat_data[:profiles],
      profiles_male: profiles_stat_data[:profiles_male],
      profiles_female: profiles_stat_data[:profiles_female],
      users: users_stat_data[:users],
      users_male: users_stat_data[:users_male],
      users_female: users_stat_data[:users_female],
      trees: trees,
      invitations: invitations,
      requests: requests,
      connections: connections,
      refuse_requests: refuse_requests,
      disconnections: disconnections,
      similars_found: similars_found
    }

    logger.info "In WeafamStat.rb#collect_site_stats: all_stat_data = #{all_stat_data}"
    logger.info ""
    all_stat_data
  end








end
