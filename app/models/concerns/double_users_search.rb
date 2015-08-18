module DoubleUsersSearch
  extend ActiveSupport::Concern

  # @note: Запуск поиска дублей юзеров
  def double_users_search(profiles_relations_arr, by_trees, certain_koeff)
    logger.info "In double_users_search "

    found_users = collect_users(by_trees)

    relations = collect_relations(found_users, certain_koeff)

    # find_matches(profiles_relations_arr, relations)
    #
    # mark_double_user(user)

  end


  # @note:
  def collect_users(by_trees)
    logger.info "In double_users_search: collect_users: by_trees = #{by_trees} "
    found_users = []
    by_trees.each do |one_found_tree|
      found_users << one_found_tree[:found_tree_id]
    end
    found_users
  end


  # @note: # To collect profiles_relations hashes:
  def collect_relations(found_users, certain_koeff)
    logger.info "In double_users_search: collect_relations: found_users = #{found_users} "
    users_profiles = [self.profile_id]
    unless found_users.blank?
      found_users.each do |one_found_user|
        user_profile_id = User.find(one_found_user).profile_id
        users_profiles << user_profile_id
        search_relations(one_found_user, user_profile_id, certain_koeff)
        logger.info "After search_relations: @profiles_relations_arr = #{@profiles_relations_arr} "
        ###################################
      end
    end

    logger.info "In double_users_search: collect_relations: users_profiles = #{users_profiles} "

    users_profiles
    # relations
  end

  # @profiles_relations_arr =
      [{:profile_searched=>441, :profile_relations=>{442=>1, 443=>2, 444=>3, 448=>5, 450=>6, 445=>8}},
       {:profile_searched=>443, :profile_relations=>{448=>3, 441=>3, 450=>4, 442=>7, 445=>17, 444=>111}},
       {:profile_searched=>445, :profile_relations=>{444=>3, 441=>7, 442=>13, 443=>14}},
       {:profile_searched=>450, :profile_relations=>{442=>1, 443=>2, 448=>5, 441=>5, 444=>211}},
       {:profile_searched=>442, :profile_relations=>{448=>3, 441=>3, 450=>4, 443=>8, 445=>17, 444=>111}},
       {:profile_searched=>444, :profile_relations=>{441=>1, 445=>2, 442=>91, 443=>101, 448=>191, 450=>201}},
       {:profile_searched=>448, :profile_relations=>{442=>1, 443=>2, 441=>5, 450=>6, 444=>211}},
       {:profile_searched=>675, :profile_relations=>{676=>1, 677=>2, 680=>3, 678=>5, 679=>6, 681=>8}},
       {:profile_searched=>682, :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8}}]

      [{:profile_searched=>441, :profile_relations=>{442=>1, 443=>2, 444=>3, 448=>5, 450=>6, 445=>8}},
       {:profile_searched=>443, :profile_relations=>{448=>3, 441=>3, 450=>4, 442=>7, 445=>17, 444=>111}},
       {:profile_searched=>445, :profile_relations=>{444=>3, 441=>7, 442=>13, 443=>14}},
       {:profile_searched=>450, :profile_relations=>{442=>1, 443=>2, 448=>5, 441=>5, 444=>211}},
       {:profile_searched=>442, :profile_relations=>{448=>3, 441=>3, 450=>4, 443=>8, 445=>17, 444=>111}},
       {:profile_searched=>444, :profile_relations=>{441=>1, 445=>2, 442=>91, 443=>101, 448=>191, 450=>201}},
       {:profile_searched=>448, :profile_relations=>{442=>1, 443=>2, 441=>5, 450=>6, 444=>211}},
       {:profile_searched=>675, :profile_relations=>{676=>1, 677=>2, 680=>3, 678=>5, 679=>6, 681=>8}},
       {:profile_searched=>682, :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8}}]



  # Поиск совпадений для одного из профилей
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @see News
  def search_relations(one_found_user, user_profile_id, certain_koeff)

    logger.info "=== IN search_match "
    logger.info " "
    found_profiles_hash = Hash.new  #
    profiles_hash = Hash.new
    one_profile_relations_hash = Hash.new

    all_profile_rows = ProfileKey.where(:user_id => one_found_user).where(:profile_id => user_profile_id, deleted: 0).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
    # поиск массива записей искомого круга для каждого профиля в дереве Юзера
    logger.info "Круг ИСКОМОГО ПРОФИЛЯ = #{user_profile_id.inspect} в  дереве #{one_found_user} зарег-го Юзера"      # :user_id, , :id
    show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG

    all_profile_rows_No = 1 # DEBUGG_TO_LOGG
    if !all_profile_rows.blank?
      logger.info "all_profile_rows.size = #{all_profile_rows.size} " # DEBUGG_TO_LOGG
      # допускаем до поиска те круги искомых профилей, размер кот-х (кругов) больше или равно коэфф-та достоверности
      if all_profile_rows.size >= certain_koeff
        all_profile_rows.each do |relation_row|
          one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)
          # Получение РЕЗ-ТАТа ПОИСКА для одной записи Kруга искомого профиля - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
          found_profiles_hash = get_found_profiles(profiles_hash, relation_row, one_found_user, user_profile_id)

          logger.info " "
          logger.info "=== После ПОИСКА по записи № #{all_profile_rows_No}" # DEBUGG_TO_LOGG
          logger.info "one_profile_relations_hash = #{one_profile_relations_hash} " # DEBUGG_TO_LOGG
          logger.info "profiles_hash = #{profiles_hash} " # DEBUGG_TO_LOGG
          logger.info "found_profiles_hash = #{found_profiles_hash} " # DEBUGG_TO_LOGG

          all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле  # DEBUGG_TO_LOGG
        end

      end

    else
      logger.info " "
      logger.info "ERROR in search_match: В искомом дереве - НЕТ искомого профиля!?? "
    end

    # ДОПОЛНИТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
    @profiles_relations_arr = make_profile_relations(user_profile_id, one_profile_relations_hash, @profiles_relations_arr)

    # ОСНОВНОЙ РЕЗ-ТАТ ПОИСКА - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (массив):
    # {профиль искомый -> дерево -> профиль найденный -> [ массив совпавших отношений с искомым профилем ]
    @profiles_found_arr << found_profiles_hash if !found_profiles_hash.empty? # Заполнение выходного массива хэшей
    logger.info "Где что найдено: Для искомого профиля #{user_profile_id} - в конце этого Хэша @profiles_found_arr:"
    logger.info "#{@profiles_found_arr} " # DEBUGG_TO_LOGG


  end # End of search_match


  # @note:
  def find_matches(profiles_relations_arr, relations)



  end

  # @note:
  def mark_double_user(user)


  end





end