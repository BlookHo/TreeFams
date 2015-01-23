class SimilarsController < ApplicationController
  include SearchHelper

  layout 'application.new'

  before_filter :logged_in?

  # todo: перенести этот метод в Operational - для нескольких моделей
  #
  # /
  # пересечение 2-х хэшей, у которых - значения = массивы
  def intersection(first, other)
    common_hash = {}
    uncommon_hash = {}
    logger.info "intersection 01: first = #{first}"
    logger.info "intersection 01: other = #{other}"
    # ;  uncommon_hash.merge!(other)
    first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
      if !other.include?(k)
        uncommon_hash.merge!({k => other})
      end
      intersect = other[k] & v    # пересечение = общая часть массивов
      difference = (other[k] - v) + (v - other[k])  # разность = различие 2-х массивов
      logger.info "intersection 02: other[k] = #{other[k]}, v = #{v}, intersect = #{intersect}, difference = #{difference} "
      common_hash.merge!({k => intersect}) if !intersect.blank?
      uncommon_hash.merge!({k => difference}) if !difference.blank?
      logger.info "intersection 05: common_hash = #{common_hash}, uncommon_hash = #{uncommon_hash} "
    end
    return common_hash, uncommon_hash
  end


  # Запуск методов определения похожих профилей в текущем дереве
  #
  def internal_similars_search

    arr1 = [2, 1, 3, 5]
    arr2 = [2, 0, 4]
    inter = arr1 & arr2
    differ = arr1 || arr2
    differ1 = arr1 - arr2
    differ2 = arr2 - arr1
    resdif = differ1 + differ2
    resdif2 = (arr1 - arr2) + (arr2 - arr1)


    #logger.info "&&& In int_sim_search 01: arr1 = #{arr1}, arr2 = #{arr2}, inter = #{inter}, differ = #{differ}"
    #logger.info "&&& In int_sim_search 01: differ1 = #{differ1}, differ2 = #{differ2}, resdif = #{resdif}, resdif2 = #{resdif2}"

    hash1 = {"son"=>[122, 121], "hus"=>[90], "dil"=>[82], "gsf"=>[28]    ,"fat"=>[110]           }
    hash2 = {"son"=>[122, 120], "hus"=>[90], "dil"=>[82], "gsf"=>[28]   ,"hfl"=>[28], "hml"=>[48]}  # from balda
    common_hash, uncommon_hash = intersection(hash1, hash2)
    logger.info "&&& In int_sim_search 021: common_hash = #{common_hash}"
    logger.info "&&& In int_sim_search 022: uncommon_hash = #{uncommon_hash} "





        @tree_info = get_tree_info(current_user)
    logger.info "In internal_similars_search 1: @tree_info = #{@tree_info} "  if !@tree_info.blank?
    logger.info "In internal_similars_search 1a: @tree_info.profiles.size = #{@tree_info[:profiles].size} "  if !@tree_info.blank?
    ############ call of User.module ############################################
    similars, unsimilars = User.similars_init_search(@tree_info)
    #############################################################################
    @similars_qty = similars.size if !similars.empty?
    @unsimilars = unsimilars
    @unsimilars_qty = unsimilars.size if !unsimilars.empty?
    @paged_similars_data = pages_of(similars, 10) # Пагинация - по 10 строк на стр.(?)

  end

  # Кол-во профилей в дереве
  # и другая инфа о дереве и профилях дерева
  def get_tree_info(current_user)

    tree_profiles_info = get_tree_profiles_info(current_user)
    all_tree_profiles_info = get_all_tree_profiles_info(tree_profiles_info)

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

  # Сбор данных обо всех профилях в дереве - для исп-я далее
  def collect_tree_profiles(tree_arr)

    profiles = {}
    tree_arr.map {|p|
      ( one_profile_data = { :is_name_id => p.is_name_id, :is_sex_id => p.is_sex_id , :profile_id => p.profile_id, :relation_id => p.relation_id}
        profiles.merge!( p.is_profile_id => one_profile_data )  if !one_profile_data.empty?
      ) }
    profiles

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
    all_tree_profiles_amount = all_tree_profiles.size if !all_tree_profiles.blank?

    {   all_tree_profiles: all_tree_profiles,    # Весь Массив профилей в дереве (с авторами)
        all_tree_profiles_amount: all_tree_profiles_amount,    # Количество всего массива профилей в дереве (с авторами)
        users_profiles_ids: users_profiles_ids # Массив users_profiles_ids в дереве (авторы)
    }

  end


  # Готовит данные для Объединения похожих профилей - similars_connection_data
  # ПЕредает их в модель для непосредственного объединения
  def connect_similars
    first_profile_connecting  = params[:first_profile_id].to_i
    second_profile_connecting = params[:second_profile_id].to_i
    init_hash = { first_profile_connecting => second_profile_connecting}
    logger.info "*** In connect_similars 2:  init_hash = #{init_hash} "

    # todo: check similars_complete_search, when init_hash has many profiles
    # todo: also - to manipulate  buttons "Yes/No - to connect" in multiple rows in case many profiles

    ############ call of User.module ############################################
    profiles_to_rewrite, profiles_to_destroy = current_user.similars_complete_search(init_hash)
    #############################################################################
    @profiles_to_rewrite = profiles_to_rewrite # TO_VIEW
    @profiles_to_destroy = profiles_to_destroy # TO_VIEW
    logger.info "*** In connect_similars contrler 3:  profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy} "

    similars_connection_data = {profiles_to_rewrite: profiles_to_rewrite, #
                                profiles_to_destroy: profiles_to_destroy,
                                current_user_id: current_user.id,
                                connection_id: 10  }  # порядковый номер connection - взять значение из последнего лога

    # Лог - это массив записей о параметрах всех совершенных объединениях дерева
    # храниться должен отдельно

    ############ call of User.module Similars_connection ########################

    @log_connection = current_user.similars_connect_tree(similars_connection_data)
    logger.info "*** In  Similars_Controller connect_similars: @log_connection = \n     #{@log_connection} "
    @log_connection_id = @log_connection[:log_tree][0][:connected_at]
    logger.info "*** In  Similars_Controller connect_similars: @log_connection_id = #{@log_connection_id} "
    @log_connection_tree_size = @log_connection[:log_tree].size unless @log_connection[:log_tree].blank?
    @log_connection_profilekey_size = @log_connection[:log_profilekey].size unless @log_connection[:log_profilekey].blank?
    @complete_log = @log_connection[:log_tree] + @log_connection[:log_profilekey]
    logger.info "*** In  Similars_Controller connect_similars: @complete_log = \n     #{@complete_log} "
    @complete_log_size = @complete_log.size unless @complete_log.blank?
    logger.info "*** In  Similars_Controller connect_similars: @complete_log_size = #{@complete_log_size} "


  end

  # Оставляет похожие профили без объединения
  # помечаем их как непохожие на будущее
  def keep_disconnected_similars
    first_profile_connecting = params[:first_profile_id]
    second_profile_connecting = params[:second_profile_id]
    logger.info "*** In keep_disconnected_similars:  first_profile_connecting = #{first_profile_connecting},  second_profile_connecting = #{second_profile_connecting} "
    ############ call of User.module ############################################
    current_user.without_connecting_similars

  end

  # Возвращает объединенные профили в состояние перед объединением
  # во всех таблицах
  def disconnect_similars

    log_id = params[:log_connection_id]
    logger.info "*** In disconnect_similars:  log_id = #{log_id}"

    profiles_to_rewrite = params[:profiles_rewrite_arr]
    profiles_to_destroy = params[:profile_destroy_arr]
    logger.info "*** In disconnect_similars:  profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy} "
    ############ call of User.module Similars_disconnection #####################
    current_user.disconnecting_similars(profiles_to_rewrite, profiles_to_destroy)

  end






end