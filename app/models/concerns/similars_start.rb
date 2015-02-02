module SimilarsStart
  extend ActiveSupport::Concern
  # in User model


  # Запуск методов поиска Похожих в одном дереве - от current_user
  # Возвращает данные о найденных Похожих и о дереве - в similars_contrler:
  # sim_data = { log_connection_id: log_connection_id, #
  #              similars: similars,       #
  #              unsimilars: unsimilars  }
  def start_similars

    tree_info = get_tree_info(self)
    logger.info "In SimilarsStart 1:  @tree_info[:connected_users] = #{tree_info[:connected_users]}, tree_info = #{tree_info},  "
    logger.info "In SimilarsStart 1a: @tree_info.profiles.size = #{tree_info[:profiles].size} "  unless tree_info.blank?

    # Последний id (максимальный) из существующих логов - :connected_at
    log_connection_id = current_tree_log_id(tree_info[:connected_users])

    ############ call of User.module # Запуск метода определения первых пар Похожих ###########################################
    similars, unsimilars = User.similars_init_search(tree_info)
    #############################################################################
    sim_data = {}
    unless similars.empty?
      ####################### Сохранение найденных пар похожих
      SimilarsFound.store_similars(similars, self.id)
      #############################################################################
      sim_data = {   log_connection_id: log_connection_id, #
                     similars: similars,        #
                     unsimilars: unsimilars     }
    end

    return tree_info, sim_data

  end


  # Для текущего дерева - получение номера id лога для прогона разъединения Похожих,
  # ранее объединенных.
  # Последний id (максимальный) из существующих логов - :connected_at
  def current_tree_log_id(connected_users)
    # Сбор всех id логов, относящихся к текущему дереву
    current_tree_logs_ids = SimilarsLog.where(current_user_id: connected_users).pluck(:connected_at).uniq
    logger.info "In SimilarsStart 1b: @current_tree_logs_ids = #{current_tree_logs_ids} " unless current_tree_logs_ids.blank?
    log_connection_id = current_tree_logs_ids.max
    logger.info "In SimilarsStart 1b: MAX log_connection_id = #{log_connection_id} " unless log_connection_id.blank?
    log_connection_id
  end


  # Кол-во профилей в дереве
  # и другая инфа о дереве и профилях дерева
  def get_tree_info(current_user)
    tree_profiles_info = get_tree_profiles_info(current_user)
    all_tree_profiles_info = get_all_tree_profiles_info(tree_profiles_info)
    logger.info "In SimilarsStart 1c get_tree_info: tree_profiles_info[:connected_users] = #{tree_profiles_info[:connected_users]} " unless tree_profiles_info[:connected_users].blank?

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
        tree_profiles_amount: profiles_qty, # Количество профилей в дереве
        tree_is_profiles: tree_is_profiles # Массив профилей в дереве
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