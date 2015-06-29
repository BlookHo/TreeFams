module SimilarsStart
  extend ActiveSupport::Concern
  # in User model

  # Запуск методов поиска Похожих в одном дереве - от current_user
  # Возвращает данные о найденных НОВЫХ Похожих и о дереве - в similars_contrler:
  # sim_data = { log_connection_id: log_connection_id, #
  #              similars: similars  }
  def start_similars
    new_sims = ""
    tree_info = Tree.get_tree_info(self)

    # logger.info "In SimilarsStart 1:  @tree_info[:connected_users] = #{tree_info[:connected_users]}, tree_info = #{tree_info} "
    connected_users = self.get_connected_users

    ### Удаление ВСЕХ ранее сохраненных пар похожих ДЛЯ ОДНОГО ДЕРЕВА
    SimilarsFound.clear_tree_similars(connected_users)

    ###### Запуск User метода определения первых пар Похожих ##################
    similars = User.similars_init_search(tree_info)
    #############################################################################
    check_similars_data =  {  similars: similars, current_user_id: self.id    }
    new_sims = check_new_similars(check_similars_data) unless similars.empty?
    log_connection_id = []
    log_connection_id = SimilarsLog.current_tree_log_id(connected_users) unless connected_users.empty?

    # logger.info "In SimilarsStart 4: sim_data = #{new_sims} "
    {tree_info: tree_info,
     new_sims: new_sims,
     similars: similars,
     connected_users: connected_users,
     log_connection_id: log_connection_id }
  end

  # В случае, когда найдены Похожие, проверяем: есть ли среди них НОВЫЕ Похожие
  # Если есть, то записываем их в табл. SimilarsFound и формируем содержание рез-та sim_data
  # Если нет, то рез-тат - не изменяется, т.е. sim_data = {}
  def check_new_similars(check_similars_data)
    new_sims =  ""
    similars = check_similars_data[:similars]
    current_user_id = check_similars_data[:current_user_id]

    sims_profiles_pairs = collect_sims_profiles_pairs(similars)
    new_similars = SimilarsFound.find_stored_similars(sims_profiles_pairs, current_user_id) #self.id)
    # Проверка найденных П. Если такие пары П - все СТАРЫЕ - уже есть среди сохраненных, new_similars.blank
    # то данный тест пройден - Без П.
    #  Тогда ничего не отображаем в кач-ве рез-та теста П -
    # переходим к Поиску:  sim_data = {} - /home
    unless new_similars.blank?
      # Если найденные П - НОВЫЕ - отс-ют среди ранее сохраненных, или часть НОВЫЕ,
      #  то все similars = рез-тат теста П. И их надо сохранить в таблице SimilarsFound,
      # показать в render :template => 'similars/show_similars_data' и разобраться Да\Нет
      # Если Да - объединяем П, удаляем сохраненные ранее пары П из табл. Найденных
      # Если Нет - /home
      ####################### Сохранение найденных пар похожих
      SimilarsFound.store_similars(sims_profiles_pairs, current_user_id)
      #############################################################################
      new_sims =  "New sims"
    end
    new_sims
  end

  # Сбор пар похожих профилей - для последующего сохранения в табл. SimilarsFound
  def collect_sims_profiles_pairs(similars)
    sims_profiles_pairs = []
    similars.each do |one_sim_pair|
      one_sims_profiles_pair = [one_sim_pair[:first_profile_id], one_sim_pair[:second_profile_id]]
      sims_profiles_pairs <<  one_sims_profiles_pair
    end
    sims_profiles_pairs
  end



end
