class SearchSimilarsController < ApplicationController

  layout 'application.new'

  before_filter :logged_in?


  # Запуск методов определения похожих профилей в текущем дереве
  #
  def internal_similars_search

    @tree_info = get_tree_info(current_user)
    view_similars_data = ProfileKey.search_similars(@tree_info)
  #  @paged_similars_data = pages_of(view_similars_data, 10) # Пагинация - по 10 строк на стр.(?)
  #  logger.info "In internal_similars_search: @paged_similars_data.size = #{@paged_similars_data.size} "

  end

  # Кол-во профилей в дереве
  # и другая инфа о дереве
  def get_tree_info(current_user)
    tree_info = Hash.new
    tree_info[:current_user] = current_user
    tree_info[:tree_profiles_amount] = Tree.tree_amount(current_user) # Количество профилей в дереве
    tree_info[:connected_users] = current_user.get_connected_users    # Пользователи - авторы дерева
    tree_info[:author_tree_arr] = Tree.get_connected_tree(tree_info[:connected_users]) # DISTINCT Массив объединенного дерева из Tree
    tree_info[:tree_is_profiles] = tree_info[:author_tree_arr].map {|p| p.is_profile_id }.uniq # Массив профилей в дереве

    return tree_info

  end



end
