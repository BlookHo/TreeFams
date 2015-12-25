module DoubleUsersSearch
  extend ActiveSupport::Concern

  #############################################################
  # Иванищев А.В. 2015
  # Метод определения дублей среди пользователей - по стартовому дереву
  #############################################################
  # @note: Осуществляет поиск совпадений в деревьях на основе нового введенного дерева
  #   Если вновь введенный пользователь является дублем для одного из существующих, то
  #   дубль - удаляется из всех БД.
  #############################################################


  # @note: Запуск check дублей found юзеров - from search results
  # def check_tree_doubles(results)
  #   logger.info "In check_doubles: by_trees = #{results[:by_trees].inspect} "
  #   results_by_trees = results[:by_trees]
  #   if results_by_trees.blank?
  #     no_double_trees
  #   else
  #     find_double_tree(results)
  #   end
  # end

  # @note: actions, when double check passed Ok and there are no double trees  #
  #   set attribute :double to 1
  def no_double_trees
    self.update_attributes(:double => 1, :updated_at => Time.now)
    logger.info "Search results READY Ok -> Double trees check PASSED Ok -> to SearchResults.store_search_results."
  end

  # @note: find, at least, first double tree  #
  # @note: Запуск check дублей found юзеров - from search results
  def find_double_tree(results)
    # check_by_user_name(results)
    common_name_users = collect_users_by_names(results[:by_trees])
    logger.info "In find_double_tree: CERTAIN_KOEFF = #{CERTAIN_KOEFF}, common_name_users = #{common_name_users} "
    if common_name_users.blank?
      no_double_trees
      logger.info  "In find_double_tree: NO Double Users: All found users have different users names WITH self.name"
      logger.info  "-> goto SearchResults.store_search_results"
    else
      logger.info  "Found Users have the same names as self -> continue double trees check"
      self_tree_data = collect_tree_data(self.id)
      logger.info "In find_double_tree: after SELF collect_tree_info: self_tree_data = #{self_tree_data} "
          # self_tree_data =
          #     {:profile_searched=>689,
          #      :profile_relations=>{690=>1, 691=>2, 694=>3, 692=>5, 693=>6, 695=>8},
          #      :user_name=>123, :found_user_id=>50,
          #      :user_relations_names=>{690=>162, 691=>219, 694=>461, 692=>188, 693=>2, 695=>9}}

      common_name_users.each do |one_user_id|
        found_tree_data = collect_tree_data(one_user_id)
        logger.info "In find_double_tree: after collect_tree_data: found_tree_data ready"
        # logger.info "found_tree_data = #{found_tree_data} "
            # found_tree_data =
            #     {:profile_searched=>682,
            #      :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8},
            #      :user_name=>123, :found_user_id=>49,
            #      :user_relations_names=>{683=>162, 684=>219, 687=>461, 685=>123, 686=>2, 688=>9}}

        check_one_double?(self_tree_data, found_tree_data).blank? ?
            double_mark = 1 : double_mark = 2
        mark_user(double_mark, one_user_id)
      end

    end

  end


  # @note: prepare all arrays for creating found trees data
  def collect_tree_data(one_user_id)

    profile_id, name_id = user_profile_name(one_user_id)
    logger.info "In collect_tree_info: profile_id = #{profile_id}, name_id = #{name_id} "

     # {:profile_searched=>682,
     # :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8},
     # :user_name=>123, :found_user_id=>49,
     # :user_relations_names=>{683=>162, 684=>219, 687=>461, 685=>123, 686=>2, 688=>9}}

    search_relations(one_user_id, profile_id, CERTAIN_KOEFF)

  end


  # @note: сбор user-id из search results -   #
  # only trees with user_id have the same name as current_user (self)
  def collect_users_by_names(by_trees)
    common_name_users = []
    by_trees.each do |one_found_tree|
      one_found_tree_id = one_found_tree[:found_tree_id]
      found_user_profile = User.find(one_found_tree_id).profile_id
      common_name_users << one_found_tree_id if check_users_names?(found_user_profile)
    end
    common_name_users
  end

  # @note поиск массива записей искомого круга для профиля Юзера
  # @output = Hash
  def search_relations(one_found_user, user_profile_id, certain_koeff)
    one_user_relations_hash = Hash.new
    one_user_names_hash = Hash.new
    user_circle_rows = ProfileKey.where(user_id: one_found_user, profile_id: user_profile_id, deleted: 0)
                           .order('relation_id','is_name_id')
                           .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
                           .distinct
    logger.info "search_relations: Круг ИСКОМОГО ПРОФИЛЯ = #{user_profile_id.inspect} в дереве Юзера #{one_found_user} "
    show_in_logger(user_circle_rows, "all_profile_rows - запись" ) # DEBUGG_TO_LOGG
    if user_circle_rows.blank?
      logger.info "Double Users: ERROR in search_match: В искомом дереве - НЕТ искомого профиля!?? "
    else
      # допускаем до поиска те круги искомых профилей, размер кот-х (кругов) больше или равно коэфф-та достоверности
      if user_circle_rows.size >= certain_koeff
        user_circle_rows.each do |relation_row|
          row_is_profile_id = relation_row.is_profile_id
          one_user_relations_hash.merge!(row_is_profile_id => relation_row.relation_id)
          one_user_names_hash.merge!(row_is_profile_id => relation_row.is_name_id)
        end
      end
    end

    # СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА со всеми данными:
    # ХЭШ профилей-отношений для искомого дерева.
    { profile_searched:     user_profile_id,
      profile_relations:    one_user_relations_hash,
      user_name:            one_user_name(user_profile_id),
      found_user_id:        one_found_user,
      user_relations_names: one_user_names_hash
    }

  end


  # # @note: make found trees data
  # def make_tree_data(tree_info)
  #   profile_searched     = tree_info[:user_profile]
  #   profile_relations     = tree_info[:profile_relations]
  #   user_name           = tree_info[:user_name]
  #   found_user_id       = tree_info[:found_user_id]
  #   user_relations_names = tree_info[:user_relations_names]
  #
  #
  #   tree_data = []
  #
  #
  #   {:profile_searched=>689,
  #    :profile_relations=>{690=>1, 691=>2, 694=>3, 692=>5, 693=>6, 695=>8},
  #    :init_user_name=>123, :init_user_id=>50,
  #    :init_relations_names=>{690=>162, 691=>48, 694=>461, 692=>123, 693=>2, 695=>9}}
  #
  #   {:profile_searched=>682,
  #    :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8},
  #    :user_name=>123, :found_user_id=>49,
  #    :user_relations_names=>{683=>162, 684=>219, 687=>461, 685=>123, 686=>2, 688=>9}}
  #
  #   logger.info "In make_tree_data: after make_tree_data: tree_data = #{tree_data} "
  #   tree_data
  # end
  #

  # @note: make found trees data
  def user_profile_name(user_id)
    user = User.find(user_id)
    return user.profile_id, Profile.find(user.profile_id).name_id
  end

  # @note: Проверка на совпадение отношений с одним из Юзеров
  def check_one_double?(self_tree_data, found_tree_data) #init_user_hash, one_user_relations)
    logger.info "In check_one_double?: Ready - self_tree_data   with   found_tree_data "
    qty_matched_relations = 0
    if match_users_names?(self_tree_data[:user_name], found_tree_data[:user_name])
      qty_matched_relations += 1
      self_tree_data = {
          qty_matched_relations: qty_matched_relations,
          init_user_hash: self_tree_data,
          one_user_relations: found_tree_data
      }
      return return_self_user_id(self_tree_data)
    end
    nil
  end


  # @note: return self user id if this self - is double tree to some other
  def return_self_user_id(self_tree_data)
    qty_matched_relations = self_tree_data[:qty_matched_relations]
    self_user_hash        = self_tree_data[:init_user_hash]
    one_user_relations    = self_tree_data[:one_user_relations]
    found_user_id         = self_user_hash[:found_user_id]
    logger.info "In check_one_double?#return_self_user_id: self[:found_user_id] = #{found_user_id}"
    logger.info "self[:one_user_relations] = #{one_user_relations}"
    [1,2].each do |relation|
      # [1,2,3,4,5,6,7,8].each do |relation|
      if match_relations?(self_user_hash, one_user_relations, relation)
        qty_matched_relations += 1
        logger.info "qty_matched_relations = #{qty_matched_relations} "
        return found_user_id if check_matches_qty?(qty_matched_relations)
      else
        return nil
      end
    end
    relations_arr = self_user_hash[:profile_relations].values - [1,2] #,3,4,5,6,7,8]
    logger.info "other relations_arr = #{relations_arr} "
    relations_arr.each do |relation|
      if match_relations?(self_user_hash, one_user_relations, relation)
        qty_matched_relations += 1
        logger.info "qty_matched_relations = #{qty_matched_relations}"
        return found_user_id if check_matches_qty?(qty_matched_relations)
      end
    end

  end

  # @note: Совпали отношения у Юзеров?
  # совпадение отношений - это когда у одного типа отношений(например, 3 = сын) , совпадают и имена профиля
  # т.е Сын - Борис == Сын Борис
  # если да - то true
  # если нет - то false
  # @return: false - нет совпадений , true - есть
  def match_relations?(self_user_hash, one_user_relations, relation)
    logger.info "In match_relations?: relation = #{relation} "
    self_relation_profile = self_user_hash[:profile_relations].key(relation)
    # logger.info "Double Users: match_relations?: self_relation_profile = #{self_relation_profile.inspect} "

    unless self_relation_profile.blank?
      init_relation_name = self_user_hash[:user_relations_names][self_relation_profile]
      # logger.info "Double Users: match_relations?: init_relation_name = #{init_relation_name.inspect} "
      user_relation_profile = one_user_relations[:profile_relations].key(relation)
      # logger.info "Double Users: match_relations?: user_relation_profile = #{user_relation_profile.inspect} "
      unless user_relation_profile.blank?
        user_relation_name = one_user_relations[:user_relations_names][user_relation_profile]
        # logger.info "Double Users: match_relations?: user_relation_name = #{user_relation_name.inspect} "
        if init_relation_name == user_relation_name
          logger.info "Double Users: match_relations?: TRUE init_relation_name = #{init_relation_name.inspect} <-> user_relation_name = #{user_relation_name.inspect} "
          return true
        else
          logger.info "Double Users: match_relations?: FALSE init_relation_name = #{init_relation_name.inspect} <-> user_relation_name = #{user_relation_name.inspect} "
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

  # @note: Проверка накапливания кол-ва совпадений отношений ( больше или равно 6)
  def check_matches_qty?(matched_relations)
    matched_relations >= CERTAIN_KOEFF ? true : false
  end


  # @note: Помечаем юзер как дубль
  #   Чтобы запускать метод выявления 1 раз для каждого юзера - заносим value:
  #   value = 1 - как норм.
  #   value = 2 - как дубль
  #   Если у Юзера поле = 2, то это - дубль.
  #   У него - ограниченная функциональность. Показываем соотв. уведомление
  def mark_user(value, user_id)
    self.update_attributes(:double => value, :updated_at => Time.now)
    if value == 1
      logger.info  " Ваше дерево - уникально! Вы можете продолжить его расширять и развивать! -> goto SearchResults.store_search_results"
      puts "-> goto SearchResults.store_search_results"
      # flash.now[:notice] = " Ваше дерево - уникально! Вы можете продолжить его расширять и развивать! "
    elsif value == 2
      logger.info " Внимание! Ваше дерево является ДУБЛИКАТОМ ранее созданного дерева! Мы сейчас будем удалять ваше дерево! "
      # logger.info " Пожалуйста, при повторном заходе на сайт - уточните Ваш логин, состав родственников... Иначе для Вас многое будет невозможно на сайте. "
      logger.info "Double Users: mark_user: self.id = #{self.id}, value = #{value}, with user_id = #{user_id}  "

      ##########################################
      # todo: uncomment next line
     self.delete_one_user    # delete DOUBLE user by his ID
      ##########################################
      # flash.now[:alarm] = " Внимание! У вашего дерева уже есть дубликат! Пожалуйста, уточните Ваш логин, состав родственников... Иначе для Вас многое будет невозможно на сайте. "
    end

  end

  #######################################################################

  # @note: Запуск поиска дублей юзеров
  #   only first time after registration
  #   If search_results == blank, then - no doubles
  #   else - start search doubles among search_results
  def start_check_double(results, certain_koeff)
    results_by_trees = results[:by_trees]
    if results_by_trees.blank?
      self.update_attributes(:double => 1, :updated_at => Time.now)
    else
      doubles_search_data = { relations_arr: results[:profiles_relations_arr], by_trees: results_by_trees }
      self.double_users_search(doubles_search_data, certain_koeff)
    end
  end


  # @note: Поиск дублей юзеров for new user
  def double_users_search(doubles_search_data, certain_koeff)
    profiles_relations = doubles_search_data[:relations_arr]
    by_trees      = doubles_search_data[:by_trees]
    found_users = collect_users(by_trees)
    logger.info "1 In double_users_search: after collect_users: found_users = #{found_users} "
    puts "  1 In double_users_search: found_users = #{found_users}  "
    if found_users.blank? # no doubles for new user
      self.update_attributes(:double => 1, :updated_at => Time.now)
      return
    end

    users_relations = init_profile_relations(profiles_relations, self.profile_id)
    logger.info "2 In double_users_search: after init_profile_relations: users_relations = #{users_relations} "
    users_relations[0].merge!(init_user_id: self.id, init_relations_names: init_find_names(users_relations))
    logger.info "3 Ok In double_users_search: after init_find_names: users_relations = #{users_relations} "
    complete_users_relations = collect_relations(users_relations, found_users, certain_koeff)
    logger.info "4 Ok In double_users_search: after collect_relations: complete_users_relations = #{complete_users_relations} "

    find_double(complete_users_relations) unless complete_users_relations.blank?
  end

  # @note: создание хэша отношений для self
  def init_profile_relations(profiles_relations, self_profile_id)
    init_relations_hash = {}
    profiles_relations.each do |one_hash|
      init_relations_hash = collect_init_relations(one_hash, init_relations_hash, self_profile_id)
    end
    users_relations = []
    init_relations_hash.merge!(init_user_name: Profile.find(self_profile_id).name_id)
    logger.info "  3 after: init_profile_relations: init_relations_hash = #{init_relations_hash} "
    logger.info "  3 after: init_profile_relations: profiles_relations = #{profiles_relations} "
    users_relations << init_relations_hash
  end


  # @note: collect init relations hash
  def collect_init_relations(one_hash, init_relations_hash, self_profile_id)
    one_hash.each do |key,val|
      init_relations_hash.merge!(one_hash) if key == :profile_searched && val == self_profile_id
    end
    init_relations_hash
  end

  # @note: добавление хэша имен отношений для self
  def init_find_names(users_relations)
    init_names_hash = {}
    users_relations[0][:profile_relations].each_key do |key|
      name_id = Profile.find(key).name_id
      init_names_hash.merge!(key => name_id)
    end
    logger.info "In double_users_search: init_find_names: init_names_hash = #{init_names_hash} "
    init_names_hash
  end




  # @note: Check, whether new user has the same name with user from search_results
  # if Yes - it should be tested for double
  def check_users_names?(found_user_profile)
    one_user_name(self.profile_id) == one_user_name(found_user_profile)
  end


  # @note: To collect profiles_relations hashes
  # полный набор хэшей для анализа по всем найденным юзерам:
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



  # @note: Делаем Имя юзера по его профилю
  # @param: profile_id_searched -> профиль искомый
  # @return: Имя юзера по его профилю
  # @see:
  def one_user_name(profile_id)
    Profile.find(profile_id).name_id
  end


  # @note: поиск совпадений отношений тек.Юзера с найденными Юзерами
  def find_double(users_relations)
    logger.info "Double Users: find_double: users_relations = #{users_relations} " # DEBUGG_TO_LOGG
    users_relations_size = users_relations.size
    # take init user = current
    init_user_hash = users_relations[0]
    unless users_relations_size < 2
      for ind in 1 .. users_relations_size-1 do
        if self_not_double_yet? # только если еще self Юзер не помечен как Дубль
          # mark self.value = 1 as 'No doubles' OR mark self.value = 2 as 'Double'
          users_relations_ind =  users_relations[ind]
          check_one_double?(init_user_hash, users_relations_ind).blank? ?
              double_mark = 1 : double_mark = 2
          mark_user(double_mark, users_relations_ind[:found_user_id])
        end
      end
    end

  end


  # @note: Check if current user yet is not double?
  def self_not_double_yet?
    self_double = self.double
    self_double == 0 || self_double == 1
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
