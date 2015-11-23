module SearchComplete
  extend ActiveSupport::Concern

  #############################################################
  # Иванищев А.В. 2014 -2015
  # Метод Полного поиска - перед объединением
  #############################################################
  # Осуществляет поиск совпадений в деревьях, расчет результатов и сохранение в БД
  # @note: Here is the storage of SearchComplete class methods
  #   to evaluate data to be stored
  #   as proper search results and update search data
  #############################################################


  # @note: METHOD " SEARCH COMPLETE "
  #   сбор полных достоверных пар профилей для объединения
  #   Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
  # @param:
  #   with_whom_connect_users_arr = [3]
  #   uniq_profiles_pairs =
  #   {15=>{9=>85, 11=>128}, 14=>{3=>22}, 21=>{3=>29},
  #   19=>{3=>27}, 11=>{3=>25, 11=>127, 9=>87}, 2=>{9=>172, 11=>139},
  #   20=>{3=>28}, 16=>{9=>88, 11=>125}, 17=>{9=>86, 11=>126},
  #   12=>{3=>23, 11=>155}, 3=>{9=>173, 11=>154}, 13=>{3=>24, 11=>156},
  #   124=>{9=>91}, 18=>{3=>26}}
  # Output:
  #  final_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} (pid:4353)
  #   ( profiles_to_rewrite = [14, 21, 19, 11, 20, 12, 13, 18]
  #   profiles_to_destroy = [22, 29, 27, 25, 28, 23, 24, 26] )
  def complete_search(complete_search_data)
    logger.info "** IN complete_search Module *** "
    with_whom_connect_users_arr = complete_search_data[:with_whom_connect]
    uniq_profiles_pairs         = complete_search_data[:uniq_profiles_pairs]
    certain_koeff               = complete_search_data[:certain_koeff]

    init_connection_hash = init_connection_data(with_whom_connect_users_arr, uniq_profiles_pairs)
    logger.info "IN complete_search init_connection_hash = #{init_connection_hash}"
    # init_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26}

    final_connection_hash = {}
    unless init_connection_hash.empty?
      final_connection_hash = init_connection_modify(init_connection_hash, certain_koeff)
      puts "final_connection_hash = #{final_connection_hash} "
    end

    final_connection_hash

  end


  # @note: init_hash iterate to collect final_connection_hash
  # final_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} # In Spec
  def init_connection_modify(init_connection_hash, certain_koeff)
    final_connection_hash = init_connection_hash
    # начало сбора полного хэша достоверных пар профилей для объединения
    until init_connection_hash.empty?
      logger.info "** IN UNTIL top: init_connection_hash = #{init_connection_hash}"
      add_connection_hash = collect_add_connection(init_connection_hash, final_connection_hash)

#########################################################################################
      add_hash_checked = SearchWork.check_add_hash(add_connection_hash, certain_koeff)
      puts " After add_hash_checked"

      add_to_hash_data = { add_connection_hash: add_hash_checked, final_connection_hash: final_connection_hash }
#########################################################################################

      # add_to_hash_data = { add_connection_hash: add_connection_hash, final_connection_hash: final_connection_hash }
      final_connection_hash = SearchWork.collect_final_connection(add_to_hash_data)

      puts "@@@@@ final_connection_hash = #{final_connection_hash} "

      # Подготовка к следующему циклу
      init_connection_hash = add_connection_hash
    end
    final_connection_hash
  end


  # @note: init_hash iterate to collect_add_connection
  def collect_add_connection(init_connection_hash, final_connect_hash)
    add_connection_hash = {}

    init_connection_hash.each do |profile_searched, profile_found|
      new_connection_hash = {}
      # Получение Кругов для пары профилей - для последующего сравнения и анализа
      logger.info "=== КРУГИ ПРОФИЛЕЙ: profile_searched = #{profile_searched}, profile_found = #{profile_found}"
      circles_arrs_data = SearchCircles.find_circles_arrs(profile_searched, profile_found)
      search_bk_arr          = circles_arrs_data[:search_bk_arr]
      search_bk_profiles_arr = circles_arrs_data[:search_bk_profiles_arr]
      search_is_profiles_arr = circles_arrs_data[:search_is_profiles_arr]
      found_bk_arr           = circles_arrs_data[:found_bk_arr]
      found_bk_profiles_arr  = circles_arrs_data[:found_bk_profiles_arr]
      found_is_profiles_arr  = circles_arrs_data[:found_is_profiles_arr]

      compare_circles_data = {
          profile_searched: profile_searched,
          profile_found: profile_found,
          found_bk_arr: found_bk_arr,
          search_bk_arr: search_bk_arr,
          found_bk_profiles_arr: found_bk_profiles_arr,
          search_bk_profiles_arr: search_bk_profiles_arr,
          found_is_profiles_arr: found_is_profiles_arr,
          search_is_profiles_arr: search_is_profiles_arr,
          final_connection_hash: final_connect_hash,
          new_connection_hash: new_connection_hash
      }
      # puts " После сравнения Кругов: compare_circles_data = #{compare_circles_data} "
      new_connection_hash = collect_new_connection_hash(compare_circles_data)

      # накапливание нового доп.хаша по всему циклу
      # add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.blank?
      add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.empty?
      logger.info " add_connection_hash = #{add_connection_hash} "

    end
    add_connection_hash
  end


  # @note: Collect new_connection_hash
  def collect_new_connection_hash(compare_circles_data)
    final_connection_hash = compare_circles_data[:final_connection_hash]
    new_connection_hash = sequest_connection_hash(final_connection_hash,
                                                  SearchCircles.proceed_compare_circles(compare_circles_data))
    puts " after sequest_connection_hash: new_connection_hash = #{new_connection_hash} "
    new_connection_hash
  end


  # @note: Collect new_connection_hash
  # сокращение нового хэша если его эл-ты уже есть в финальном хэше
  # NB !! Вставить проверку: Если нет такой комбинации: k == profiles_s && v == profile_f
  # а есть: k == profiles_s && v != profile_f (?) возможно ли это? Что возвратит delete_if?.
  # и действия
  def sequest_connection_hash(final_conn_hash, new_connection_hash)
    final_conn_hash.each do |profiles_s, profile_f|
      new_connection_hash.delete_if { |k_conn,v_conn| k_conn == profiles_s && v_conn == profile_f }
    end
    new_connection_hash
  end


  # @note: Получение стартового Хэша для объединения профилей на основе:
  # uniq_profiles_pairs - хэша уникальных достоверных пар профилей,
  # полученных в рез-те отработки start_search
  # with_whom_connect_users - array дерева(деревьев), с котороыми собираемся объединяться
  # На выходе - init_connection_hash - Хэш достоверных пар профилей,
  # с которых начинается процесс жесткого определения полного набора соответствий между всеми профилями
  # объединяемых деревьев.
  def init_connection_data(with_whom_connect_users, uniq_profiles_pairs)
    logger.info "with_whom_connect_users_arr = #{with_whom_connect_users}, uniq_profiles_pairs = #{uniq_profiles_pairs}"
    init_connection_hash = {} # hash to work with
    uniq_profiles_pairs.each do |searched_profile, trees_hash|
    init_hash_data = {
      trees_hash:              trees_hash,
      init_connection_hash:    init_connection_hash,
      searched_profile:        searched_profile,
      with_whom_connect_users: with_whom_connect_users
    }

    init_connection_hash = collect_init_hash(init_hash_data)

    end
    init_connection_hash
  end

  # @note: выбор результатов для дерева из with_whom_connect_users_arr
  # перезапись в хэше под key = searched_profile
  def collect_init_hash(init_hash_data)

    trees_hash              = init_hash_data[:trees_hash]
    init_connection_hash    = init_hash_data[:init_connection_hash]
    searched_profile        = init_hash_data[:searched_profile]
    with_whom_connect_users = init_hash_data[:with_whom_connect_users]

    trees_hash.each do |tree_key, found_profile|
      init_connection_hash.merge!( searched_profile => found_profile ) if with_whom_connect_users.include?(tree_key)
    end
    init_connection_hash
  end



end # End of search_complete module

# SIM search
# [inf] In compare_tree_circles ITERATION = 37: one_profile_id: 836 - b_profile_id: 846 (pid:6511)
# [inf] *** compare hashes: data_a_to_compare (is_name, is_sex): [214, 0],  - data_b_to_compare: [214, 0] (pid:6511)
# [inf] *** In check_similars_exclusions 1: data_for_check:
    {:a_profile_circle=>{
        "Отец"=>[73], "Мама"=>[445], "Сын"=>[194], "Брат"=>[151], "Сестра"=>[331], "Муж"=>[318],
        "Дед-о"=>[318], "Дед-м"=>[194], "Бабка-о"=>[174], "Бабка-м"=>[128], "Дядя-о"=>[26]},

     :b_profile_circle=>{
         "Отец"=>[26], "Мама"=>[447], "Брат"=>[351], "Дед-о"=>[318], "Бабка-о"=>[174],
         "Дядя-о"=>[73]},
     :common_hash=>{"Дед-о"=>[318], "Бабка-о"=>[174]}}

# [inf] *** In check_similars_exclusion 78: unsimilar_sign: false, inter_relations:
    ["Отец", "Мама", "Брат", "Дядя-о"]



{:tree_profiles=>[849, 851, 852, 855, 857, 853, 856, 854, 858, 850, 859],
 :connected_author_arr=>[62], :qty_of_tree_profiles=>11,
 :profiles_relations_arr=>[
     {:profile_searched=>849,
      :profile_relations=>{850=>1, 851=>2, 854=>3, 852=>5, 853=>6, 855=>7, 856=>91, 858=>92, 857=>101, 859=>102}},
     {:profile_searched=>851,
      :profile_relations=>{858=>1, 859=>2, 852=>3, 849=>4, 853=>4, 850=>7, 856=>13, 857=>14, 855=>18, 854=>112}},
     {:profile_searched=>852,
      :profile_relations=>{850=>1, 851=>2, 849=>6, 853=>6, 856=>91, 858=>92, 857=>101, 859=>102, 854=>212}},
     {:profile_searched=>855,
      :profile_relations=>{854=>3, 849=>8, 850=>15, 851=>16}},
     {:profile_searched=>857,
      :profile_relations=>{850=>3, 856=>7, 851=>17, 852=>111, 849=>121, 853=>121}},
     {:profile_searched=>853,
      :profile_relations=>{850=>1, 851=>2, 852=>5, 849=>6, 856=>91, 858=>92, 857=>101, 859=>102, 854=>212}},
     {:profile_searched=>856,
      :profile_relations=>{850=>3, 857=>8, 851=>17, 852=>111, 849=>121, 853=>121}},
     {:profile_searched=>854,
      :profile_relations=>{855=>1, 849=>2, 850=>92, 851=>102, 852=>192, 853=>202}},
     {:profile_searched=>858,
      :profile_relations=>{851=>4, 859=>8, 850=>18, 852=>112, 849=>122, 853=>122}},
     {:profile_searched=>850,
      :profile_relations=>{856=>1, 857=>2, 852=>3, 849=>4, 853=>4, 851=>8, 858=>15, 859=>16, 855=>18, 854=>112}},
     {:profile_searched=>859,
      :profile_relations=>{851=>4, 858=>7, 850=>18, 852=>112, 849=>122, 853=>122}}],
 :profiles_found_arr=>[
     {849=>{61=>{836=>[1, 2, 3, 5, 6, 7, 91, 92, 101, 102], 846=>[91, 101]}}},
     {851=>{61=>{835=>[1, 2, 3, 4, 4, 7, 13, 14, 18, 112]}}},
     {852=>{61=>{833=>[1, 2, 6, 6, 91, 92, 101, 102, 212]}}},
     {855=>{61=>{847=>[3, 8, 15, 16]}}},
     {857=>{61=>{840=>[3, 7, 17, 111, 121, 121, 121]}}},
     {853=>{61=>{837=>[1, 2, 5, 6, 91, 92, 101, 102, 212]}}},
     {856=>{61=>{839=>[3, 8, 17, 111, 121, 121, 121]}}},
     {854=>{61=>{848=>[1, 2, 92, 102, 192, 202]}}},
     {858=>{61=>{841=>[4, 8, 18, 112, 122, 122]}}},
     {850=>{61=>{834=>[1, 2, 3, 4, 4, 8, 15, 16, 18, 112]}}},
     {859=>{61=>{842=>[4, 7, 18, 112, 122, 122]}}}],
 :uniq_profiles_pairs=>
     {849=>{61=>836}, 851=>{61=>835}, 852=>{61=>833}, 855=>{61=>847},
      857=>{61=>840}, 853=>{61=>837}, 856=>{61=>839}, 854=>{61=>848},
      858=>{61=>841}, 850=>{61=>834}, 859=>{61=>842}},
 :profiles_with_match_hash=>{834=>10, 835=>10, 836=>10,
                             837=>9, 833=>9,
                             839=>7, 840=>7,
                             842=>6, 841=>6, 848=>6,
                             847=>4},
 :by_profiles=>[{:search_profile_id=>850, :found_tree_id=>61, :found_profile_id=>834, :count=>10}, {:search_profile_id=>851, :found_tree_id=>61, :found_profile_id=>835, :count=>10}, {:search_profile_id=>849, :found_tree_id=>61, :found_profile_id=>836, :count=>10}, {:search_profile_id=>853, :found_tree_id=>61, :found_profile_id=>837, :count=>9}, {:search_profile_id=>852, :found_tree_id=>61, :found_profile_id=>833, :count=>9}, {:search_profile_id=>856, :found_tree_id=>61, :found_profile_id=>839, :count=>7}, {:search_profile_id=>857, :found_tree_id=>61, :found_profile_id=>840, :count=>7}, {:search_profile_id=>859, :found_tree_id=>61, :found_profile_id=>842, :count=>6}, {:search_profile_id=>858, :found_tree_id=>61, :found_profile_id=>841, :count=>6}, {:search_profile_id=>854, :found_tree_id=>61, :found_profile_id=>848, :count=>6}, {:search_profile_id=>855, :found_tree_id=>61, :found_profile_id=>847, :count=>4}],
 :by_trees=>[{:found_tree_id=>61, :found_profile_ids=>[836, 835, 833, 847, 840, 837, 839, 848, 841, 834, 842]}],
 :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}


# Сообщение об объединении: @connection_message = "Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! ЕСТЬ дублирования в массивах"
# Управление СТОПом объединения: @stop_connection = true
# Кто хочет соединиться: Автор: 61
# @who_connect_users_arr: [61]
# Выбран Юзер, с кем Автор хочет соединиться (из вьюхи): 62
# @with_whom_connect_users_arr: [62]
# ИТОГОВЫЕ ДОСТОВЕРНЫЕ ПАРЫ ПРОФИЛЕЙ - БЕЗ ДУБЛИКАТОВ: @uniq_profiles_pairs:
{833=>{62=>852}, 841=>{62=>858}, 840=>{62=>857}, 842=>{62=>859},
 836=>{62=>849}, 837=>{62=>853}, 839=>{62=>856}, 834=>{62=>850},
 848=>{62=>854}, 835=>{62=>851}, 847=>{62=>855}}
# ИТОГОВЫЕ ДУБЛИКАТЫ ПРОФИЛЕЙ One_to_Many : @duplicates_one_to_many: {}
# ИТОГОВЫЕ ДУБЛИКАТЫ ПРОФИЛЕЙ Many_to_One : @duplicates_many_to_one: {}
# Длительность поиска: 1.47493
# Определение массивов ПЕРЕЗАПИСИ ПРОФИЛЕЙ:
#                                     Массивы перезаписи, найденные в Connect_Users
# @profiles_to_rewrite:
    [833, 841, 840, 842, 836, 837, 839, 834, 848, 835, 847, 846]
# @profiles_to_destroy:
    [852, 858, 857, 859, 849, 853, 856, 850, 854, 851, 855, 849]


# compare_two_circles: ИСКОМОГО ПРОФИЛЯ = 840 и НАЙДЕННОГО ПРОФИЛЯ = 857:
# circles Sizes = EQUAL, но Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != [])
# common_circle_arr =
    [
    {"name_id"=>174, "relation_id"=>3, "is_name_id"=>73, "deleted"=>0},
    {"name_id"=>174, "relation_id"=>7, "is_name_id"=>318, "deleted"=>0},
    {"name_id"=>174, "relation_id"=>17, "is_name_id"=>445, "deleted"=>0},
    {"name_id"=>174, "relation_id"=>111, "is_name_id"=>151, "deleted"=>0},
    {"name_id"=>174, "relation_id"=>121, "is_name_id"=>214, "deleted"=>0},
    {"name_id"=>174, "relation_id"=>121, "is_name_id"=>331, "deleted"=>0}]

# ПЕРЕСЕЧЕНИЕ двух Кругов: common_circle_arr =
    [{"name_id"=>174, "relation_id"=>3, "is_name_id"=>73, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>7, "is_name_id"=>318, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>17, "is_name_id"=>445, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>111, "is_name_id"=>151, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>121, "is_name_id"=>214, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>121, "is_name_id"=>331, "deleted"=>0}]

# После сравнения Кругов: new_connection_hash =
     {834=>850, 839=>856, 835=>851, 833=>852, 836=>849, 846=>849, 837=>853}

# compare_two_circles: ИСКОМОГО ПРОФИЛЯ = 846 и НАЙДЕННОГО ПРОФИЛЯ = 849:
# circles Sizes = EQUAL, но Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != []) common_circle_arr =
[{"name_id"=>214, "relation_id"=>91, "is_name_id"=>318, "deleted"=>0},
 {"name_id"=>214, "relation_id"=>101, "is_name_id"=>174, "deleted"=>0}]

# 840
# compare_two_circles: search_bk =
    [{"name_id"=>174, "relation_id"=>3, "is_name_id"=>26, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>3, "is_name_id"=>73, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>7, "is_name_id"=>318, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>17, "is_name_id"=>445, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>17, "is_name_id"=>447, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>111, "is_name_id"=>151, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>111, "is_name_id"=>351, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>121, "is_name_id"=>214, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>121, "is_name_id"=>214, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>121, "is_name_id"=>331, "deleted"=>0}]

# 857
# compare_two_circles: found_bk =
    [{"name_id"=>174, "relation_id"=>3, "is_name_id"=>73, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>7, "is_name_id"=>318, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>17, "is_name_id"=>445, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>111, "is_name_id"=>151, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>121, "is_name_id"=>214, "deleted"=>0},
     {"name_id"=>174, "relation_id"=>121, "is_name_id"=>331, "deleted"=>0}]

# 2.a. circles Sizes = EQUAL, но Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != []) common_circle_arr =
[{"name_id"=>174, "relation_id"=>3, "is_name_id"=>73, "deleted"=>0},
 {"name_id"=>174, "relation_id"=>7, "is_name_id"=>318, "deleted"=>0},
 {"name_id"=>174, "relation_id"=>17, "is_name_id"=>445, "deleted"=>0},
 {"name_id"=>174, "relation_id"=>111, "is_name_id"=>151, "deleted"=>0},
 {"name_id"=>174, "relation_id"=>121, "is_name_id"=>214, "deleted"=>0},
 {"name_id"=>174, "relation_id"=>121, "is_name_id"=>331, "deleted"=>0}]

# To get_fields_arr_from_circles: search_bk_profiles_arr =
       [{"profile_id"=>840, "name_id"=>174, "relation_id"=>3, "is_profile_id"=>843, "is_name_id"=>26, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>3, "is_profile_id"=>834, "is_name_id"=>73, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>7, "is_profile_id"=>839, "is_name_id"=>318, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>17, "is_profile_id"=>835, "is_name_id"=>445, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>17, "is_profile_id"=>844, "is_name_id"=>447, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>111, "is_profile_id"=>833, "is_name_id"=>151, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>111, "is_profile_id"=>845, "is_name_id"=>351, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>121, "is_profile_id"=>836, "is_name_id"=>214, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>121, "is_profile_id"=>846, "is_name_id"=>214, "deleted"=>0},
        {"profile_id"=>840, "name_id"=>174, "relation_id"=>121, "is_profile_id"=>837, "is_name_id"=>331, "deleted"=>0}]

# To get_fields_arr_from_circles: found_bk_profiles_arr =
       [{"profile_id"=>857, "name_id"=>174, "relation_id"=>3, "is_profile_id"=>850, "is_name_id"=>73, "deleted"=>0},
        {"profile_id"=>857, "name_id"=>174, "relation_id"=>7, "is_profile_id"=>856, "is_name_id"=>318, "deleted"=>0},
        {"profile_id"=>857, "name_id"=>174, "relation_id"=>17, "is_profile_id"=>851, "is_name_id"=>445, "deleted"=>0},
        {"profile_id"=>857, "name_id"=>174, "relation_id"=>111, "is_profile_id"=>852, "is_name_id"=>151, "deleted"=>0},
        {"profile_id"=>857, "name_id"=>174, "relation_id"=>121, "is_profile_id"=>849, "is_name_id"=>214, "deleted"=>0},
        {"profile_id"=>857, "name_id"=>174, "relation_id"=>121, "is_profile_id"=>853, "is_name_id"=>331, "deleted"=>0}]



# После сравнения Кругов: new_connection_hash =
                    {834=>850, 839=>856, 835=>851, 833=>852, 836=>849, 846=>849, 837=>853}

# compare_two_circles: ИСКОМОГО ПРОФИЛЯ = 846 и НАЙДЕННОГО ПРОФИЛЯ = 849:
#     compare_two_circles: search_bk =
    [{"name_id"=>214, "relation_id"=>1, "is_name_id"=>26, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>2, "is_name_id"=>447, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>5, "is_name_id"=>351, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>91, "is_name_id"=>318, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>101, "is_name_id"=>174, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>191, "is_name_id"=>73, "deleted"=>0}]

    # compare_two_circles: found_bk =
    [{"name_id"=>214, "relation_id"=>1, "is_name_id"=>73, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>2, "is_name_id"=>445, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>3, "is_name_id"=>194, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>5, "is_name_id"=>151, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>6, "is_name_id"=>331, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>7, "is_name_id"=>318, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>91, "is_name_id"=>318, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>92, "is_name_id"=>194, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>101, "is_name_id"=>174, "deleted"=>0},
     {"name_id"=>214, "relation_id"=>102, "is_name_id"=>128, "deleted"=>0}]


# ПЕРЕСЕЧЕНИЕ двух Кругов: common_circle_arr =
      [{"name_id"=>214, "relation_id"=>91, "is_name_id"=>318, "deleted"=>0},
       {"name_id"=>214, "relation_id"=>101, "is_name_id"=>174, "deleted"=>0}]
