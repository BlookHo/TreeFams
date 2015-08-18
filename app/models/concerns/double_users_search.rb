module DoubleUsersSearch
  extend ActiveSupport::Concern

  # @note: Запуск поиска дублей юзеров
  def double_users_search(profiles_relations, by_trees, certain_koeff)
    logger.info "In double_users_search "

    found_users = collect_users(by_trees)

    users_relations = init_profile_relations(profiles_relations, self.profile_id)
    complete_users_relations = collect_relations(users_relations, found_users, certain_koeff)

    find_matches(complete_users_relations)
    #
    # mark_double_user(user)

  end

  # @note:
  def init_profile_relations(profiles_relations, self_profile_id)
    # logger.info "In double_users_search: init_profile_relations: self_profile_id = #{self_profile_id}, profiles_relations_arr = #{profiles_relations} "
            [{:profile_searched=>441, :profile_relations=>{442=>1, 443=>2, 444=>3, 448=>5, 450=>6, 445=>8}},
            {:profile_searched=>443, :profile_relations=>{448=>3, 441=>3, 450=>4, 442=>7, 445=>17, 444=>111}},
            {:profile_searched=>445, :profile_relations=>{444=>3, 441=>7, 442=>13, 443=>14}},
            {:profile_searched=>450, :profile_relations=>{442=>1, 443=>2, 448=>5, 441=>5, 444=>211}},
            {:profile_searched=>442, :profile_relations=>{448=>3, 441=>3, 450=>4, 443=>8, 445=>17, 444=>111}},
            {:profile_searched=>444, :profile_relations=>{441=>1, 445=>2, 442=>91, 443=>101, 448=>191, 450=>201}},
            {:profile_searched=>448, :profile_relations=>{442=>1, 443=>2, 441=>5, 450=>6, 444=>211}}]

    init_relations_hash = {}
    profiles_relations.each do |one_hash|
      one_hash.each do |key,val|
        init_relations_hash = one_hash if key == :profile_searched && val == self_profile_id
      end
    end
    users_relations = []
    logger.info "In double_users_search: init_profile_relations: init profile_relations = #{init_relations_hash[:profile_relations]} "
    users_relations << init_relations_hash
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
  def collect_relations(users_relations, found_users, certain_koeff)
    logger.info "In double_users_search: collect_relations: users_relations = #{users_relations} "
    logger.info "In double_users_search: collect_relations: found_users = #{found_users} "
    # users_profiles = [self.profile_id]
    complete_users_relations = users_relations
    # logger.info "In double_users_search: collect_relations: complete_users_relations = #{complete_users_relations} "
    # users_profiles = []
    unless found_users.blank?
      found_users.each do |one_found_user|
        user_profile_id = User.find(one_found_user).profile_id
        # users_profiles << user_profile_id
        logger.info "In double_users_search: collect_relations: user_profile_id = #{user_profile_id} "
        complete_users_relations << search_relations(users_relations, one_found_user, user_profile_id, certain_koeff)
        logger.info "After search_relations: complete_users_relations = #{complete_users_relations} "
        ###################################
      end
    end

    # logger.info "In double_users_search: collect_relations: users_profiles = #{users_profiles} "

    # users_relations
    complete_users_relations
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
  def search_relations(users_relations, one_found_user, user_profile_id, certain_koeff)

    logger.info "Double Users: === IN search_relations "
    one_profile_relations_hash = Hash.new

    all_profile_rows = ProfileKey.where(:user_id => one_found_user).where(:profile_id => user_profile_id, deleted: 0).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
    # поиск массива записей искомого круга для каждого профиля в дереве Юзера
    logger.info "Double Users: Круг ИСКОМОГО ПРОФИЛЯ = #{user_profile_id.inspect} в  дереве #{one_found_user} зарег-го Юзера"      # :user_id, , :id
    show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG

    all_profile_rows_No = 1 # DEBUGG_TO_LOGG
    if !all_profile_rows.blank?
      logger.info "Double Users: all_profile_rows.size = #{all_profile_rows.size} " # DEBUGG_TO_LOGG
      # допускаем до поиска те круги искомых профилей, размер кот-х (кругов) больше или равно коэфф-та достоверности
      if all_profile_rows.size >= certain_koeff
        all_profile_rows.each do |relation_row|
          one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)

          logger.info "Double Users: === После ПОИСКА по записи № #{all_profile_rows_No}" # DEBUGG_TO_LOGG
          logger.info "Double Users: one_profile_relations_hash = #{one_profile_relations_hash} " # DEBUGG_TO_LOGG

          all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле  # DEBUGG_TO_LOGG
        end

      end

    else
      logger.info " "
      logger.info "Double Users: ERROR in search_match: В искомом дереве - НЕТ искомого профиля!?? "
    end

    # ДОПОЛНИТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
    make_user_relations(user_profile_id, one_profile_relations_hash)


  end # End of search_match

  # @note: Делаем ХЭШ профилей-отношений для искомого дерева. - пригодится.
  #   Tested
  # @param:
  # @return: ВСПОМОГАТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА
  #   (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
  #   [ {profile_searched: -> профиль искомый, profile_relations: -> все отношения к искомому профилю } ]
  # @see:
  def make_user_relations(profile_id_searched, one_profile_relations)
    profile_relations_hash = Hash.new
    one_profile_relations_hash = { profile_searched: profile_id_searched, profile_relations: one_profile_relations}
    # profile_relations_hash.merge!(profile_id_searched  => one_profile_relations)
    profile_relations_hash.merge!(one_profile_relations_hash)
    # profiles_relations_arr << profile_relations_hash unless profile_relations_hash.empty? # Заполнение выходного массива хэшей
    logger.info "Все пары profile_relations ИСКОМОГО ПРОФИЛЯ: profile_relations_hash = #{profile_relations_hash} "
    logger.info ""
    # profiles_relations_arr
    profile_relations_hash
  end


  # @note:
  def find_matches(users_relations)
    logger.info "Double Users: find_matches: users_relations = #{users_relations} " # DEBUGG_TO_LOGG
     # users_relations =
        [{:profile_searched=>441, :profile_relations=>{442=>1, 443=>2, 444=>3, 448=>5, 450=>6, 445=>8}},
         {:profile_searched=>675, :profile_relations=>{676=>1, 677=>2, 680=>3, 678=>5, 679=>6, 681=>8}},
         {:profile_searched=>682, :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8}}]

  end

  # @note:
  def mark_double_user(user)


  end





end