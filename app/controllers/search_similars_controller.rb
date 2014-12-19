class SearchSimilarsController < ApplicationController

  layout 'application.new'

  before_filter :logged_in?


  # Запуск методов определения похожих профилей в текущем дереве
  #
  def internal_similars_search

    @tree_info = get_tree_info(current_user)
    logger.info "In internal_similars_search 1: @tree_info = #{@tree_info} "  if !@tree_info.blank?
    logger.info "In internal_similars_search 1a: @tree_info.profiles.size = #{@tree_info[:profiles].size} "  if !@tree_info.blank?
    view_similars_data = ProfileKey.search_similars(@tree_info)
    @paged_similars_data = pages_of(view_similars_data, 10) # Пагинация - по 10 строк на стр.(?)

  end

  # Кол-во профилей в дереве
  # и другая инфа о дереве и профилях дерева
  def get_tree_info(current_user)
    connected_users = current_user.get_connected_users
    author_tree_arr = Tree.get_connected_tree(connected_users) # DISTINCT Массив объединенного дерева из Tree
    profiles_qty, tree_is_profiles = Tree.tree_amount(current_user)
    { current_user:  current_user,
      tree_profiles_amount: profiles_qty, # Количество профилей в дереве
      connected_users: connected_users,    # Пользователи - авторы дерева
      tree_is_profiles: tree_is_profiles, # Массив профилей в дереве
      profiles: collect_tree_profiles(author_tree_arr)   # Инфа о профилях в дереве
    }
  end

  # Сбор данных обо всех профилях в дереве - для исп-я далее
  def collect_tree_profiles(tree_arr)

    profiles = {}
    tree_arr.map {|p|
      ( one_profile_data = {}
        one_profile_data[:is_profile_id] = p.is_profile_id
        one_profile_data[:is_name_id] = p.is_name_id
        one_profile_data[:is_sex_id] = p.is_sex_id
        logger.debug "==== In tree_is_profiles.each:  one_profile_data: #{one_profile_data.inspect} " # DEBUGG_TO_LOGG
        profile_name_sex = { :is_name_id => p.is_name_id, :is_sex_id => p.is_sex_id }
        profiles.merge!( p.is_profile_id => profile_name_sex )  if !profile_name_sex.empty?
      ) }
    profiles

  end


end
