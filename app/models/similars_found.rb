class SimilarsFound < ActiveRecord::Base

  # TESTED
  validates_presence_of :user_id, :first_profile_id, :second_profile_id, :message => "Должно присутствовать в SimilarsFound"
  validates_numericality_of :user_id, :first_profile_id, :second_profile_id, :only_integer => true, :message => "ID автора сообщения или получателя сообщения должны быть целым числом в SimilarsFound"
  validates_numericality_of :user_id, :first_profile_id, :second_profile_id, :greater_than => 0, :message => "ID автора сообщения или получателя сообщения должны быть больше 0 в SimilarsFound"
  validate :two_fields_are_not_equal  # :first_profile_id, :second_profile_id

  # custom validation
  def two_fields_are_not_equal
    self.errors.add(:similars_founds, 'Профили в одном ряду не должны быть равны в SimilarsFound.') if self.first_profile_id == self.second_profile_id
  end

  scope :at_user_id, -> (current_user_id) { where(user_id: current_user_id) }
  scope :sims_pair_exists, -> (first_profile_id, second_profile_id) {
                          where(" (first_profile_id = #{first_profile_id} and second_profile_id = #{second_profile_id})
                           or (first_profile_id = #{second_profile_id} and second_profile_id = #{first_profile_id})") }


  # Поиск в таблице НОВЫХ пар похожих среди ранее сохраненных (СТАРЫХ) найденных пар похожих
  # sims_profiles_pairs = [[38, 42], [41, 40]]
  # TESTED
  def self.find_stored_similars(sims_profiles_pairs, current_user_id)
    new_similars = []
    sims_profiles_pairs.each do |one_sim_pair|
      first_profile_id = one_sim_pair[0]
      second_profile_id = one_sim_pair[1]
      found_sims = SimilarsFound.at_user_id(current_user_id).
                       sims_pair_exists(first_profile_id, second_profile_id).pluck(:id)
      # puts "In SimilarsFound find_stored_similars: found_sims = #{found_sims} "
      # logger.info "In SimilarsFound find_stored_similars: found_sims = #{found_sims} "
      # Если found_sims.blank?, значит эта пара - one_sim_pair - новыe похожиe профили
      new_similars << one_sim_pair if found_sims.blank? # их еще нет в таблице SimilarsFound
    end
    return new_similars
  end

    # Сохранение найденных пар похожих
  def self.store_similars(sims_profiles_pairs, current_user_id)

    sim_pairs = []
    # similars.each do |one_sim_pair|
    #   one_sim_pair_data = { user_id: current_user_id,                               # int
    #                         first_profile_id: one_sim_pair[:first_profile_id],      # int
    #                         second_profile_id: one_sim_pair[:second_profile_id] }   # int
    #   sim_pairs<< self.new(one_sim_pair_data)
    # end
    sims_profiles_pairs.each do |one_sim_pair|
      one_sim_pair_data = { user_id: current_user_id,                # int
                            first_profile_id: one_sim_pair[0],       # int
                            second_profile_id: one_sim_pair[1] }     # int
      sim_pairs<< self.new(one_sim_pair_data)
    end
    sim_pairs.each(&:save)  # store in table SimilarsFound
  end


  # Очистка табл. от ранее сохраненных пар похожих, в случае когда они объединились
  # connection_data =
  # {:profiles_to_rewrite=>[41, 35, 42, 44, 52], :profiles_to_destroy=>[40, 39, 38, 43, 34],
  # :current_user_id=>5, :connection_id=>8, :connected_users_arr=>[5, 4], :table_name=>"profile_keys"}
  def self.clear_similars_found(connection_data)
    logger.info "In SimilarsFound clear_similars_found: connection_data = #{connection_data} "
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    connected_users_arr = connection_data[:connected_users_arr]
    found_sims1 = SimilarsFound.where(user_id: connected_users_arr)
                      .where(first_profile_id: profiles_to_rewrite, second_profile_id: profiles_to_destroy)
                      .pluck(:id)
    found_sims2 = SimilarsFound.where(user_id: connected_users_arr)
                      .where(first_profile_id: profiles_to_destroy, second_profile_id: profiles_to_rewrite)
                      .pluck(:id)
    found_sims = found_sims1 + found_sims2
    logger.info "In SimilarsFound clear_similars_found: found_sims = #{found_sims.inspect}, found_sims1 = #{found_sims1.inspect}, found_sims2 = #{found_sims2.inspect} "
    found_deletion(restore_found(found_sims1 + found_sims2))
  end


  # Очистка табл. от ВСЕХ ранее сохраненных пар похожих ДЛЯ ОДНОГО ДЕРЕВА, в случае когда они объединились
  def self.clear_tree_similars(connected_users_arr)
    logger.info "In SimilarsFound clear_tree_similars: connected_users_arr = #{connected_users_arr} "
    found_sims = SimilarsFound.where(user_id: connected_users_arr).pluck(:id)
    logger.info "In SimilarsFound clear_similars_found: found_sims = #{found_sims.inspect}"
    found_deletion(restore_found(found_sims))
  end


    # Получение массива rows из таблицы SimilarsFound по номеру id row
  def self.restore_found(found_sims)
    SimilarsFound.where(id: found_sims)
  end

  # Удаление массива rows из таблицы SimilarsFound - после объединения похожих
  def self.found_deletion(found_to_destroy)
    found_to_destroy.map(&:destroy)
  end


end
