class SimilarsFound < ActiveRecord::Base



  # Поиск в таблице ранее сохраненных (СТАРЫХ) найденных пар похожих
  # и выявление НОВЫХ пар похожих
  # /
  def self.find_stored_similars(similars, current_user_id)

    previous_similars, new_similars = [], []
    previous_similars_couunt, new_similars_count = 0, 0

    similars.each do |one_sim_pair|
      first_profile_id = one_sim_pair[:first_profile_id]
      second_profile_id = one_sim_pair[:second_profile_id]
      found_sims = SimilarsFound.where(user_id: current_user_id)
                       .where(" (first_profile_id = #{first_profile_id} and second_profile_id = #{second_profile_id})
                         or (first_profile_id = #{second_profile_id} and second_profile_id = #{first_profile_id})")
                       .pluck(:id)
      # logger.info "In SimilarsStart 2a: first_profile_id = #{first_profile_id}, second_profile_id = #{second_profile_id} "
      # logger.info "In SimilarsStart 2aa: current_user_id = #{current_user_id}, found_sims = #{found_sims} "

      if found_sims.blank?
        new_similars << one_sim_pair  # Новые найденные похожие
        new_similars_count +=1
      else
        previous_similars << one_sim_pair  # Старые похожие (ранее найденные и записанные в SimilarsFound)
        previous_similars_couunt +=1
      end

    end
    # logger.info "In SimilarsStart 3: previous_similars = #{previous_similars}, previous_similars_couunt = #{previous_similars_couunt} "
    # logger.info "In SimilarsStart 3: new_similars = #{new_similars}, new_similars_count = #{new_similars_count} "

    return previous_similars, new_similars

  end

    # Сохранение найденных пар похожих
  def self.store_similars(similars, current_user_id)

    # [{:first_profile_id=>38, :first_relation_id=>"Жена", :name_first_relation_id=>"Петра", :first_name_id=>"Ольга", :first_sex_id=>"Ж",
    #   :second_profile_id=>42, :second_relation_id=>"Сестра", :name_second_relation_id=>"Елены", :second_name_id=>"Ольга", :second_sex_id=>"Ж",
    #   :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370]}, :common_power=>4, :inter_relations=>[]},
    #  {:first_profile_id=>44, :first_relation_id=>"Мама", :name_first_relation_id=>"Ольги", :first_name_id=>"Жанна", :first_sex_id=>"Ж",
    #   :second_profile_id=>43, :second_relation_id=>"Жена", :name_second_relation_id=>"Олега", :second_name_id=>"Жанна", :second_sex_id=>"Ж",
    #   :common_relations=>{"Дочь"=>[173, 354], "Муж"=>[351]}, :common_power=>3, :inter_relations=>[]},
    #  {:first_profile_id=>41, :first_relation_id=>"Отец", :name_first_relation_id=>"Елены", :first_name_id=>"Олег", :first_sex_id=>"М",
    #   :second_profile_id=>40, :second_relation_id=>"Отец", :name_second_relation_id=>"Ольги", :second_name_id=>"Олег", :second_sex_id=>"М",
    #   :common_relations=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[370]},
    #   :common_power=>4, :inter_relations=>[]},
    #  {:first_profile_id=>39, :first_relation_id=>"Сестра", :name_first_relation_id=>"Ольги", :first_name_id=>"Елена", :first_sex_id=>"Ж",
    #   :second_profile_id=>35, :second_relation_id=>"Жена", :name_second_relation_id=>"Андрея", :second_name_id=>"Елена", :second_sex_id=>"Ж",
    #   :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[354]}, :common_power=>3, :inter_relations=>[]}]

    sim_pairs = []
    similars.each do |one_sim_pair|
      one_sim_pair_data = { user_id: current_user_id,                               # int
                            first_profile_id: one_sim_pair[:first_profile_id],      # int
                            second_profile_id: one_sim_pair[:second_profile_id] }   # int
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
