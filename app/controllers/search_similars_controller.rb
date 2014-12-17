class SearchSimilarsController < ApplicationController

  layout 'application.new'

  before_filter :logged_in?


  # Запуск методов определения похожих профилей в текущем дереве
  #
  def internal_similars_search


    @tree_info = get_tree_info(current_user)
    logger.info "In internal_similars_search 1: @tree_info = #{@tree_info} "  if !@tree_info.blank?
    view_similars_data = ProfileKey.search_similars(@tree_info)
    @paged_similars_data = pages_of(view_similars_data, 10) # Пагинация - по 10 строк на стр.(?)
    logger.info "In internal_similars_search 2: @paged_similars_data.size = #{@paged_similars_data.size} "  if !view_similars_data.blank?

  end

  # Кол-во профилей в дереве
  # и другая инфа о дереве и профилях дерева
  def get_tree_info(current_user)
    connected_users = current_user.get_connected_users
    author_tree_arr = Tree.get_uniq_connected_tree(connected_users) # DISTINCT Массив объединенного дерева из Tree
    logger.debug "==== In get_tree_info 1:  author_tree_arr.size: #{author_tree_arr.size.inspect} " # DEBUGG_TO_LOGG
    logger.debug "==== In get_tree_info 2:  author_tree_arr[0]: #{author_tree_arr[0].attributes.inspect} " # DEBUGG_TO_LOGG
    tree_is_profiles = author_tree_arr.map {|p| p.is_profile_id }.uniq # Массив профилей в дереве
    logger.debug "==== In get_tree_info 3:  tree_is_profiles: #{tree_is_profiles.inspect} " # DEBUGG_TO_LOGG

    author_tree_arr = author_tree_arr.uniq(:is_profile_id)
    logger.debug "==== In get_tree_info 3a:  author_tree_arr.size: #{author_tree_arr.size.inspect} " # DEBUGG_TO_LOGG

    #author_tree_arr_uniq = author_tree_arr.all.select( " profile_id, name_id, relation_id, distinct(is_profile_id), is_name_id, is_sex_id" )
    #  select("id, title").group("title")
    author_tree_arr_uniq = author_tree_arr.select( :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id, :is_sex_id ).group(:is_profile_id)


    logger.debug "==== In get_tree_info 4:  author_tree_arr_uniq: #{author_tree_arr_uniq.inspect} " # DEBUGG_TO_LOGG
    logger.debug "==== In get_tree_info 4a:  author_tree_arr_uniq.size: #{author_tree_arr_uniq.size.inspect} " # DEBUGG_TO_LOGG
    profiles = []
#    tree_is_profiles.each do |profile_id|
#      logger.debug "==== In tree_is_profiles.each 1:  profile_id: #{profile_id.inspect} " # DEBUGG_TO_LOGG
      author_tree_arr.map {|p|# p.is_profile_id == profile_id &&
          (#logger.debug "==== author_tree_arr.map 1:  p.is_profile_id: #{p.is_profile_id.inspect} " # DEBUGG_TO_LOGG
          one_profile_data = {}
          one_profile_data[:is_profile_id] = p.is_profile_id;
          one_profile_data[:is_name_id] = p.is_name_id;
          one_profile_data[:is_sex_id] = p.is_sex_id;
          logger.debug "==== In tree_is_profiles.each:  one_profile_data: #{one_profile_data.inspect} " # DEBUGG_TO_LOGG
          profiles << one_profile_data
          ) }

  #  end
  logger.debug "==== In get_tree_info 3:  profiles: #{profiles.inspect} " # DEBUGG_TO_LOGG
  logger.debug "==== In get_tree_info 4a:  profiles.size: #{profiles.size.inspect} " # DEBUGG_TO_LOGG

    { current_user:  current_user,
      tree_profiles_amount: Tree.tree_amount(current_user), # Количество профилей в дереве
      connected_users: connected_users,    # Пользователи - авторы дерева
      tree_is_profiles: tree_is_profiles, # Массив профилей в дереве
      profiles: profiles   # Инфа о профилях в дереве
    }

  end

  [{:is_profile_id=>27, :is_name_id=>90, :is_sex_id=>1},
   {:is_profile_id=>13, :is_name_id=>28, :is_sex_id=>1},
   {:is_profile_id=>11, :is_name_id=>370, :is_sex_id=>1},
   {:is_profile_id=>11, :is_name_id=>370, :is_sex_id=>1},
   {:is_profile_id=>10, :is_name_id=>331, :is_sex_id=>0},
   {:is_profile_id=>28, :is_name_id=>449, :is_sex_id=>0},
   {:is_profile_id=>61, :is_name_id=>147, :is_sex_id=>0},
   {:is_profile_id=>9, :is_name_id=>82, :is_sex_id=>0},
   {:is_profile_id=>7, :is_name_id=>48, :is_sex_id=>0},
   {:is_profile_id=>3, :is_name_id=>82, :is_sex_id=>0},
   {:is_profile_id=>12, :is_name_id=>465, :is_sex_id=>1},
   {:is_profile_id=>12, :is_name_id=>465, :is_sex_id=>1},
   {:is_profile_id=>63, :is_name_id=>446, :is_sex_id=>0},
   {:is_profile_id=>8, :is_name_id=>343, :is_sex_id=>1},
   {:is_profile_id=>2, :is_name_id=>122, :is_sex_id=>1}]



end
