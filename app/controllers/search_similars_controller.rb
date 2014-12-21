class SearchSimilarsController < ApplicationController

  layout 'application.new'

  before_filter :logged_in?


  # Запуск методов определения похожих профилей в текущем дереве
  #
  def internal_similars_search

    @tree_info = get_tree_info(current_user)
    logger.info "In internal_similars_search 1: @tree_info = #{@tree_info} "  if !@tree_info.blank?
    logger.info "In internal_similars_search 1a: @tree_info.profiles.size = #{@tree_info[:profiles].size} "  if !@tree_info.blank?
    similars = ProfileKey.search_similars(@tree_info)
    @similars_qty = similars.size if !similars.empty?
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





end
