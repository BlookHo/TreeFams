module SimilarsStart
  extend ActiveSupport::Concern
  # in User model

  # Запуск методов поиска Похожих в одном дереве - от current_user
  # Возвращает данные о найденных НОВЫХ Похожих и о дереве - в similars_contrler:
  # sim_data = { log_connection_id: log_connection_id, #
  #              similars: similars  }
  def start_similars
    new_sims = ""
    tree_info = get_tree_info(self)
    logger.info "In SimilarsStart 1:  @tree_info[:connected_users] = #{tree_info[:connected_users]}, tree_info = #{tree_info} "

    ###### Запуск User метода определения первых пар Похожих ##################
    similars = User.similars_init_search(tree_info)
    #############################################################################
    check_similars_data =  {  similars: similars,
                              current_user_id: self.id    }
    new_sims = check_new_similars(check_similars_data) unless similars.empty?

    logger.info "In SimilarsStart 4: sim_data = #{new_sims} "
    return tree_info, new_sims, similars
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


  # Кол-во профилей в дереве
  # и другая инфа о дереве и профилях дерева
  def get_tree_info(current_user)
    tree_profiles_info = get_tree_profiles_info(current_user)
    all_tree_profiles_info = get_all_tree_profiles_info(tree_profiles_info)
    # logger.info "In SimilarsStart 1c get_tree_info: tree_profiles_info[:connected_users] = #{tree_profiles_info[:connected_users]} " unless tree_profiles_info[:connected_users].blank?
    { current_user:  current_user,
      users_profiles_ids: all_tree_profiles_info[:users_profiles_ids], # Массив users_profiles_ids в дереве (авторы)

      tree_is_profiles: tree_profiles_info[:tree_is_profiles], # Массив профилей в дереве
      tree_profiles_amount: tree_profiles_info[:tree_profiles_amount], # Количество профилей в дереве

      all_tree_profiles: all_tree_profiles_info[:all_tree_profiles], # Весь Массив профилей в дереве (с авторами)
      all_tree_profiles_amount: all_tree_profiles_info[:all_tree_profiles_amount], # Количество всего массива профилей в дереве (с авторами)

      connected_users: tree_profiles_info[:connected_users],    # Пользователи - авторы дерева
      profiles: collect_tree_profiles(tree_profiles_info[:author_tree_arr])   # Инфа о профилях в дереве
    }
  end


  # Сбор инфы о профилях дерева - без профилей авторов
  def get_tree_profiles_info(current_user)
    connected_users = current_user.get_connected_users
    author_tree_arr = Tree.get_connected_tree(connected_users) # DISTINCT Массив объединенного дерева из Tree
    profiles_qty, tree_is_profiles = Tree.tree_amount(current_user)
    {   connected_users: connected_users,    # Пользователи - авторы дерева
        author_tree_arr: author_tree_arr,    # Пользователи - авторы дерева
        tree_profiles_amount: profiles_qty,  # Количество профилей в дереве
        tree_is_profiles: tree_is_profiles   # Массив профилей в дереве
    }
  end

  # Сбор полной инфы о профилях дерева - с профилями авторов
  def get_all_tree_profiles_info(tree_profiles_info)
    users_profiles_ids = []
    tree_profiles_info[:connected_users].each do |user_id|
      user_profile_id = User.find(user_id).profile_id
      users_profiles_ids << user_profile_id
    end
    all_tree_profiles = (tree_profiles_info[:tree_is_profiles] + users_profiles_ids).uniq
    all_tree_profiles_amount = all_tree_profiles.size unless all_tree_profiles.blank?

    {   all_tree_profiles: all_tree_profiles,    # Весь Массив профилей в дереве (с авторами)
        all_tree_profiles_amount: all_tree_profiles_amount,    # Количество всего массива профилей в дереве (с авторами)
        users_profiles_ids: users_profiles_ids # Массив users_profiles_ids в дереве (авторы)
    }
  end

  # Сбор данных обо всех профилях в дереве - для исп-я далее
  def collect_tree_profiles(tree_arr)
    profiles = {}
    tree_arr.map {|p|
      ( one_profile_data = { :is_name_id => p.is_name_id, :is_sex_id => p.is_sex_id , :profile_id => p.profile_id, :relation_id => p.relation_id}
      profiles.merge!( p.is_profile_id => one_profile_data )  unless one_profile_data.empty?
      ) }
    profiles
  end





end
