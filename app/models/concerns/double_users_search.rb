module DoubleUsersSearch
  extend ActiveSupport::Concern

  # @note: Запуск поиска дублей юзеров
  def double_users_search(profiles_relations, by_trees, certain_koeff)
    logger.info "In double_users_search "

    found_users = collect_users(by_trees)

    users_relations = init_profile_relations(profiles_relations, self.profile_id)
    logger.info "In double_users_search: after init_profile_relations: users_relations = #{users_relations} "
    users_relations[0].merge!(init_relations_names: init_find_names(users_relations))
    logger.info "In double_users_search: after user init names: users_relations = #{users_relations} "

    complete_users_relations = collect_relations(users_relations, found_users, certain_koeff)

    find_double(complete_users_relations)
    #
    # mark_double_user(user)
  end


  # @note:
  def init_find_names(users_relations)
    logger.info "In double_users_search: init_add_names: users_relations = #{users_relations}"
    # logger.info "In double_users_search: init_add_names: users_relations[0][:profile_relations] = #{users_relations[0][:profile_relations]}"
    init_names_hash = {}
    users_relations[0][:profile_relations].each_key do |key| #, val|
      # logger.info "In double_users_search: init_profile_relations: key,val = #{key} => #{val}"
      name_id = Profile.find(key).name_id
      init_names_hash.merge!(key => name_id)
    end
    logger.info "In double_users_search: init_profile_relations: init_names_hash = #{init_names_hash} "
    init_names_hash
  end



  # @note:
  def init_profile_relations(profiles_relations, self_profile_id)
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
    init_relations_hash.merge!(init_user_name: Profile.find(self_profile_id).name_id)
    logger.info "In double_users_search: init_profile_relations: users_relations = #{users_relations} "
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


  # @note: To collect profiles_relations hashes:
  def collect_relations(users_relations, found_users, certain_koeff)
    complete_users_relations = users_relations
    unless found_users.blank?
      found_users.each do |one_found_user|
        user_profile_id = User.find(one_found_user).profile_id
        complete_users_relations << search_relations(one_found_user, user_profile_id, certain_koeff)
      end
    end
    logger.info "After search_relations: complete_users_relations = #{complete_users_relations} "
    complete_users_relations
  end



  # @note поиск массива записей искомого круга для профиля Юзера
  # @see News
  def search_relations(one_found_user, user_profile_id, certain_koeff)
    one_user_relations_hash = Hash.new
    one_user_names_hash = Hash.new
    user_circle_rows = ProfileKey.where(user_id: one_found_user, profile_id: user_profile_id, deleted: 0)
                                 .order('relation_id','is_name_id')
                                 .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
                                 .distinct
    logger.info "Double Users: Круг ИСКОМОГО ПРОФИЛЯ = #{user_profile_id.inspect} в дереве Юзера #{one_found_user} "
    show_in_logger(user_circle_rows, "all_profile_rows - запись" ) # DEBUGG_TO_LOGG
    if !user_circle_rows.blank?
      # допускаем до поиска те круги искомых профилей, размер кот-х (кругов) больше или равно коэфф-та достоверности
      if user_circle_rows.size >= certain_koeff
        user_circle_rows.each do |relation_row|
          one_user_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)
          one_user_names_hash.merge!(relation_row.is_profile_id => relation_row.is_name_id)
        end
      end
    else
      logger.info "Double Users: ERROR in search_match: В искомом дереве - НЕТ искомого профиля!?? "
    end
    # logger.info "Double Users: one_user_relations_hash = #{one_user_relations_hash} " # DEBUGG_TO_LOGG
    # logger.info "Double Users: one_user_names_hash = #{one_user_names_hash} " # DEBUGG_TO_LOGG

    # СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА со всеми данными:
    make_user_relations(user_profile_id, one_user_name(user_profile_id), one_user_relations_hash, one_user_names_hash)

  end # End of search_match


  # @note: Делаем Имя юзера по его профилю
  # @param: profile_id_searched -> профиль искомый
  # @return: Имя юзера по его профилю
  # @see:
  def one_user_name(profile_id_searched)
    Profile.find(profile_id_searched).name_id
  end


  # @note: Делаем ХЭШ профилей-отношений для искомого дерева. - пригодится.
  # @param:
  # @return: СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА
  #   (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
  #   [ {profile_searched: -> профиль искомый, profile_relations: -> все отношения к искомому профилю } ]
  # @see:
  def make_user_relations(profile_id_searched, name_id, one_user_relations, one_user_names_hash)
    {profile_searched: profile_id_searched, profile_relations: one_user_relations, user_name: name_id, user_relations_names: one_user_names_hash}
  end


  # @note:
  def find_double(users_relations)
    logger.info "Double Users: find_matches: users_relations = #{users_relations} " # DEBUGG_TO_LOGG
     # users_relations =

        [{:profile_searched=>441, :profile_relations=>{442=>1, 443=>2, 444=>3, 448=>5, 450=>6, 445=>8},
          :init_user_name=>252, :init_relations_names=>{442=>162, 443=>219, 444=>461, 448=>123, 450=>2, 445=>9}},

         {:profile_searched=>675, :user_name=>252, :profile_relations=>{676=>1, 677=>2, 680=>3, 678=>5, 679=>6, 681=>8},
          :user_relations_names=>{676=>162, 677=>219, 680=>461, 678=>123, 679=>2, 681=>9}},

         {:profile_searched=>682, :user_name=>123, :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8},
          :user_relations_names=>{683=>162, 684=>219, 687=>461, 685=>123, 686=>2, 688=>9}}]

    # make similars keys?

    # compare users names
    # no - exit
    # yes -> compare relation=1
    # no - exit
    # yes -> compare relation=2
    # no - exit
    # yes -> compare 3 any relations
    # if all match == 6 - mark double_user







  end

  # @note:
  def mark_double_user(user_id)


  end





end