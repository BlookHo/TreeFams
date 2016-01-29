module SearchComplete
  extend ActiveSupport::Concern

  # require 'pry'
  # binding.pry          # Execution will stop here.

  #############################################################
  # Иванищев А.В. 2014 -2015
  # Метод Полного поиска - перед объединением
  #############################################################
  # Осуществляет поиск совпадений в деревьях, расчет результатов и сохранение в БД
  # @note: Here is the storage of SearchComplete class methods
  #   to evaluate data to be stored
  #   as proper search results and update search data
  #############################################################

  # in  collect_new_connection_hash
  # :profile_searched = 749, :profile_found = 766
  # after sequest_connection_hash: new_connection_hash = {}
  # After add_hash_checked = {}
  # @@@@@ final_connection_hash = {736=>752, 741=>753, 742=>754, 735=>755, 738=>756, 737=>757, 743=>760, 740=>758, 746=>763, 748=>761, 747=>762, 739=>759, 744=>765, 745=>764, 749=>766}
   {736=>752, 741=>753, 742=>754, 735=>755, 738=>756, 737=>757,
      743=>760, 740=>758, 746=>763, 748=>761, 747=>762, 739=>759,
      744=>765, 745=>764, 749=>766}

  # @note: METHOD " SEARCH COMPLETE "
  #   сбор полных достоверных пар профилей для объединения
  #   Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
  # Output:
  #  final_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} (pid:4353)
  #   ( profiles_to_rewrite = [14, 21, 19, 11, 20, 12, 13, 18]
  #   profiles_to_destroy = [22, 29, 27, 25, 28, 23, 24, 26] )
  # @input: complete_search_data = {:with_whom_connect=>[61],
  # :uniq_profiles_pairs=>{992=>{61=>991}, 994=>{61=>987}, 995=>{61=>990}, 1000=>{61=>847},
  # 996=>{61=>977}, 993=>{61=>986}, 997=>{61=>978}},
  # :certain_koeff=>4}
  def complete_search(complete_search_data)
    logger.info "** IN complete_search Module *** "
    with_whom_connect_users_arr = complete_search_data[:with_whom_connect]
    uniq_profiles_pairs         = complete_search_data[:uniq_profiles_pairs]
    # certain_koeff               = complete_search_data[:certain_koeff]

    init_connection_hash = init_connection_data(with_whom_connect_users_arr, uniq_profiles_pairs)
    logger.info "IN complete_search init_connection_hash = #{init_connection_hash}"
    final_connection_hash = {}
    unless init_connection_hash.empty?
      final_connection_hash = init_connection_modify(init_connection_hash)#, certain_koeff)
      puts "@@@@@ final_connection_hash = #{final_connection_hash} "
    end
    final_connection_hash
  end


  # @note: init_hash iterate to collect final_connection_hash
  # final_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} # In Spec
  def init_connection_modify(init_connection_hash)#, certain_koeff)
    final_connection_hash = init_connection_hash
    # начало сбора полного хэша достоверных пар профилей для объединения
    until init_connection_hash.empty?
      logger.info "** IN UNTIL top: init_connection_hash = #{init_connection_hash}"
      add_connection_hash = collect_add_connection(init_connection_hash, final_connection_hash)
      #########################################################################################
      add_hash_checked = SearchWork.add_hash_exclusions_check(add_connection_hash)#, certain_koeff)
      puts " After add_hash_checked = #{add_hash_checked}"
      add_to_hash_data = { add_connection_hash: add_hash_checked, final_connection_hash: final_connection_hash }
      #########################################################################################

      final_connection_hash = SearchWork.collect_final_connection(add_to_hash_data)

      init_connection_hash = add_hash_checked # Подготовка к следующему циклу
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
      # logger.info "after find_circles_arrs: circles_arrs_data = #{circles_arrs_data}"
      compare_circles_data = {
        profile_searched:       profile_searched,
        profile_found:          profile_found,
        search_bk_arr:          circles_arrs_data[:search_bk_arr],
        search_bk_profiles_arr: circles_arrs_data[:search_bk_profiles_arr],
        search_is_profiles_arr: circles_arrs_data[:search_is_profiles_arr],
        found_bk_arr:           circles_arrs_data[:found_bk_arr],
        found_bk_profiles_arr:  circles_arrs_data[:found_bk_profiles_arr],
        found_is_profiles_arr:  circles_arrs_data[:found_is_profiles_arr],
        final_connection_hash:  final_connect_hash,
        new_connection_hash:    new_connection_hash
      }
      # puts " После сравнения Кругов: compare_circles_data"#" = #{compare_circles_data} "
      new_connection_hash = collect_new_connection_hash(compare_circles_data)

      # накапливание нового доп.хаша по всему циклу
      # add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.blank?
      add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.empty?
      # logger.info " add_connection_hash = #{add_connection_hash} "
    end
    add_connection_hash
  end


  # @note: Collect new_connection_hash
  def collect_new_connection_hash(compare_circles_data)
    puts " in  collect_new_connection_hash"
    puts "  :profile_searched = #{compare_circles_data[:profile_searched]}, :profile_found = #{compare_circles_data[:profile_found]} "
    # puts "  :search_is_profiles_arr= = #{compare_circles_data[:search_is_profiles_arr]} "
    # puts "  :found_is_profiles_arr== = #{compare_circles_data[:found_is_profiles_arr]} "
    new_connection_hash = sequest_connection_hash(compare_circles_data[:final_connection_hash],
                                                  SearchCircles.two_circles_compare(compare_circles_data))
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

