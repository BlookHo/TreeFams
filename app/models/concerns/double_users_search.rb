module DoubleUsersSearch
  extend ActiveSupport::Concern

  # @note: Запуск поиска дублей юзеров
  def double_users_search(profiles_relations, by_trees, certain_koeff)

    found_users = collect_users(by_trees)
    logger.info "1 In double_users_search: after collect_users: found_users = #{found_users} "
    users_relations = init_profile_relations(profiles_relations, self.profile_id)
    logger.info "2 In double_users_search: after init_profile_relations: users_relations = #{users_relations} "
    users_relations[0].merge!(init_user_id: self.id, init_relations_names: init_find_names(users_relations))
    logger.info "3 Ok In double_users_search: after init_find_names: users_relations = #{users_relations} "

    complete_users_relations = collect_relations(users_relations, found_users, certain_koeff)
    logger.info "4 Ok In double_users_search: after collect_relations: complete_users_relations = #{complete_users_relations} "

    find_double(complete_users_relations) unless complete_users_relations.blank?

  end


  # @note: добавление хэша имен отношений для self
  def init_find_names(users_relations)
    init_names_hash = {}
    users_relations[0][:profile_relations].each_key do |key| #, val|
      name_id = Profile.find(key).name_id
      init_names_hash.merge!(key => name_id)
    end
    logger.info "In double_users_search: init_find_names: init_names_hash = #{init_names_hash} "
    init_names_hash
  end


  # @note: создание хэша отношений для self
  def init_profile_relations(profiles_relations, self_profile_id)
    init_relations_hash = {}
    profiles_relations.each do |one_hash|
      one_hash.each do |key,val|
        init_relations_hash = one_hash if key == :profile_searched && val == self_profile_id
      end
    end
    users_relations = []
    init_relations_hash.merge!(init_user_name: Profile.find(self_profile_id).name_id)
    # logger.info "In double_users_search: init_profile_relations: init_relations_hash = #{init_relations_hash} "
    users_relations << init_relations_hash
  end


  # @note: сбор user-id из search results
  def collect_users(by_trees)
    # logger.info "In double_users_search: collect_users: by_trees = #{by_trees} "
    found_users = []
    by_trees.each do |one_found_tree|
      found_users << one_found_tree[:found_tree_id]
    end
    found_users
  end


  # @note: To collect profiles_relations hashes
  #   полный набор хэшей для анализа по всем найденным юзерам:
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
  # @see
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

    # СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА со всеми данными:
    make_user_relations(one_found_user, user_profile_id, one_user_name(user_profile_id), one_user_relations_hash, one_user_names_hash)

  end


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
  def make_user_relations(one_found_user, profile_id_searched, name_id, one_user_relations, one_user_names_hash)
    { profile_searched: profile_id_searched, profile_relations: one_user_relations,
      user_name: name_id, found_user_id: one_found_user, user_relations_names: one_user_names_hash}
  end


  # @note: поиск совпадений отношений тек.Юзера с найденными Юзерами
  def find_double(users_relations)
    logger.info "Double Users: find_double: users_relations = #{users_relations} " # DEBUGG_TO_LOGG

    # take init user = current
    init_user_hash = users_relations[0]
    logger.info "Double Users: find_double: init_user_hash = #{init_user_hash} "

    unless users_relations.size < 2
      for ind in 1 .. users_relations.size-1 do
        if self.double == 0 || self.double == 1 # только если еще self Юзер не помечен как Дубль
          # mark self.value = 1 as 'No doubles' OR mark self.value = 2 as 'Double'
          check_one_double?(init_user_hash, users_relations[ind]).blank? ?
            mark_user(1, users_relations[ind][:found_user_id]) :
            mark_user(2, users_relations[ind][:found_user_id])
        end
      end
    end
  end


  # @note: Проверка на совпадение отношений с одним из Юзеров
  def check_one_double?(init_user_hash, one_user_relations)
    logger.info "Double Users: in check_one_double?: one_user_relations = #{one_user_relations} "
    qty_matched_relations = 0
    if match_users_names?(init_user_hash[:init_user_name], one_user_relations[:user_name])
      qty_matched_relations += 1

      [1,2].each do |relation|
        if match_relations?(init_user_hash, one_user_relations, relation)
          qty_matched_relations += 1
          return init_user_hash[:init_user_id] if check_matches_qty?(qty_matched_relations)
        else
          return nil
        end
      end

      relations_arr = init_user_hash[:profile_relations].values - [1,2]
      logger.info "Double Users: match_users_names?: relations_arr = #{relations_arr} "
      relations_arr.each do |relation|
        if match_relations?(init_user_hash, one_user_relations, relation)
          qty_matched_relations += 1
          return init_user_hash[:init_user_id] if check_matches_qty?(qty_matched_relations)
        end
      end

    end
    nil

  end


  # @note: Проверка накапливания кол-ва совпадений отношений ( больше или равно 6)
  def check_matches_qty?(matched_relations)
    matched_relations >= 6 ? true : false
  end


  # @note: Совпали отношения у Юзеров?
  # совпадение отношений - это когда у одного типа отношений(например, 3 = сын) , совпадают и имена профиля
  # т.е Сын - Борис == Сын Борис
  # если да - то true
  # если нет - то false
  # @return: false - нет совпадений , true - есть
  def match_relations?(init_user_hash, one_user_relations, relation)
    logger.info "Double Users: match_relations?: relation = #{relation} "
    init_relation_profile = init_user_hash[:profile_relations].key(relation)
    logger.info "Double Users: match_relations?: init_relation_profile = #{init_relation_profile.inspect} "

    unless init_relation_profile.blank?
      init_relation_name = init_user_hash[:init_relations_names][init_relation_profile]
      logger.info "Double Users: match_relations?: init_relation_name = #{init_relation_name.inspect} "
      user_relation_profile = one_user_relations[:profile_relations].key(relation)
      logger.info "Double Users: match_relations?: user_relation_profile = #{user_relation_profile.inspect} "
      unless user_relation_profile.blank?
        user_relation_name = one_user_relations[:user_relations_names][user_relation_profile]
        logger.info "Double Users: match_relations?: user_relation_name = #{user_relation_name.inspect} "
        if init_relation_name == user_relation_name
          return true
        else
          return false
        end
      end
    end
    false

  end


  # @note: Совпали имена Юзеров?
  # если да - то продолжаем проверку
  # если нет - то берем след. юзер
  def match_users_names?(init_user_name, one_user_name)
    logger.info "Double Users: match_users_names?: init_user_name = #{init_user_name}, one_user_name = #{one_user_name} " # DEBUGG_TO_LOGG
    init_user_name == one_user_name ? true : false
  end


  # @note: Помечаем юзер как дубль
  #   Чтобы запускать метод выявления 1 раз для каждого юзера - заносим value:
  #   value = 1 - как норм.
  #   value = 2 - как дубль
  #   Если у Юзера поле = 2, то это - дубль.
  #   У него - ограниченная функциональность. Показываем соотв. уведомление
  def mark_user(value, user_id)
    self.update_attributes(:double => value, :updated_at => Time.now)
    # if value == 1
    #   logger.info  " Ваше дерево - уникально! Вы можете продолжить его расширять и развивать! "
    #   # flash.now[:notice] = " Ваше дерево - уникально! Вы можете продолжить его расширять и развивать! "
    # elsif value == 2
    #   logger.info " Внимание! У вашего дерева уже есть дубликат! Пожалуйста, уточните Ваш логин, состав родственников... Иначе для Вас многое будет невозможно на сайте. "
    #   # flash.now[:alarm] = " Внимание! У вашего дерева уже есть дубликат! Пожалуйста, уточните Ваш логин, состав родственников... Иначе для Вас многое будет невозможно на сайте. "
    # end

      logger.info "Double Users: mark_user: self.id = #{self.id}, value = #{value}, with user_id = #{user_id}  "
  end





end


# users_relations =

[{:profile_searched=>441, :profile_relations=>{442=>1, 443=>2, 444=>3, 448=>5, 450=>6, 445=>8},
  :init_user_name=>252, :init_user_id=>24,
  :init_relations_names=>{442=>162, 443=>219, 444=>461, 448=>123, 450=>2, 445=>9}},

 {:profile_searched=>675, :profile_relations=>{676=>1, 677=>2, 680=>3, 678=>5, 679=>6, 681=>8},
  :user_name=>252, :found_user_id=>48,
  :user_relations_names=>{676=>162, 677=>219, 680=>461, 678=>123, 679=>2, 681=>9}},

 {:profile_searched=>682, :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8},
  :user_name=>123, :found_user_id=>49,
  :user_relations_names=>{683=>162, 684=>219, 687=>461, 685=>123, 686=>2, 688=>9}}]