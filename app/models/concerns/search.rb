module Search
  extend ActiveSupport::Concern

  #############################################################
  # Иванищев А.В. 2014 -2015
  # Метод поиска
  #############################################################
  # Осуществляет поиск совпадений в деревьях, расчет результатов и сохранение в БД
  # @note: Here is the storage of Search class methods
  #   to evaluate data to be stored
  #   as proper search results and update search data
  #############################################################


  # @note: Запуск мягкого поиска для объединения
  #   Значение certain_koeff - из DB, WeafamSettings
  # from_profile_searching = author_tree_arr.profile_id     # От какого профиля осущ-ся Поиск DEBUGG_TO_LOGG
  # name_id_searched       = author_tree_arr.name_id        # Имя Профиля DEBUGG_TO_LOGG
  # relation_id_searched   = author_tree_arr.relation_id    # Искомое relation_id К_Профиля DEBUGG_TO_LOGG
  # is_name_id_searched    = author_tree_arr.is_name_id     # Искомое Имя К_Профиля DEBUGG_TO_LOGG
  # profile_id_searched    = author_tree_arr.is_profile_id  # Поиск по ID К_Профиля
  # Задание на поиск от Дерева Юзера:
  # tree_is_profiles = [9, 15, 14, 21, 8, 19, 11, 7, 2, 20, 16, 10, 17, 12, 3, 13, 124, 18] - in RSpec user_spec.rb
  # TO TEST CONNECTION TO FAIL
  # @duplicates_one_to_many = { 3=> [2, 4]}     # for DEBUGG ONLY!!!
  # @duplicates_many_to_one = { 4=> 2, 3 => 2}  # for DEBUGG ONLY!!!
  def start_search(certain_koeff)

    start_search_time = Time.now
    tree_data =  Tree.tree_main_data(self) # collect tree info
    tree_profiles        = tree_data[:tree_profiles]
    qty_of_tree_profiles = tree_data[:qty_of_tree_profiles]
    connected_author_arr = tree_data[:connected_author_arr]
    debug_tree_data_logger(tree_data, certain_koeff) # Debug

    init_vars

    profiles_search_data = {
      certain_koeff:        certain_koeff,
      connected_author_arr: connected_author_arr,
      tree_profiles:        tree_profiles }
    all_profiles_search(profiles_search_data) unless tree_profiles.blank?

    search_profiles_from_tree(certain_koeff)

    results = {
      tree_profiles:            tree_profiles,        # use? - in RSpec, View
      connected_author_arr:     connected_author_arr, # use? - in RSpec, View
      qty_of_tree_profiles:     qty_of_tree_profiles, # use? - in RSpec, View
      ############### РЕЗУЛЬТАТЫ ПОИСКА ######## NEW METHOD ############
      profiles_relations_arr:   @profiles_relations_arr,
      profiles_found_arr:       @profiles_found_arr,
      uniq_profiles_pairs:      @uniq_profiles_pairs,
      profiles_with_match_hash: @profiles_with_match_hash,
      ############# РЕЗУЛЬТАТЫ ПОИСКА для save & display in Meteor ##########################################
      by_profiles:              @by_profiles,
      by_trees:                 @by_trees,
      ############### ДУБЛИКАТЫ ПОИСКА ######## NEW METHOD ############
      duplicates_one_to_many:   @duplicates_one_to_many,
      duplicates_many_to_one:   @duplicates_many_to_one }

    SearchResults.store_search_results(results, self.id) # запись рез-тов поиска в таблицу - для Метеора

    self.start_check_double(results, certain_koeff) if self.double == 0

    end_search_time = Time.now

    search_time = end_search_time - start_search_time
    logger.info "== END OF start_search === Search_time = #{search_time.round(3)} sec; results = #{results.inspect}"

    results
  end


  # @note: init vars to be in results
  def init_vars
    @profiles_found_arr = []     #
    @new_profiles_to_profiles_arr = []     #
    @profiles_relations_arr = []      #
  end


  # @note: поиск для каждого профиля дерева
  #   Запуск Циклов поиска по tree_arr "
  def all_profiles_search(profiles_search_data)
    iteration = 0 # DEBUGG_TO_LOGG
    profiles_search_data[:tree_profiles].each do |profile_id_searched|
      logger.info "***** Цикл ПОИСКa: #{iteration+1}-я ИТЕРАЦИЯ - Ищем профиль: #{profile_id_searched.inspect};"
      ###### ЗАПУСК ПОИСКА ОДНОГО ПРОФИЛЯ
      search_match_data = {
          certain_koeff:        profiles_search_data[:certain_koeff],
          connected_author_arr: profiles_search_data[:connected_author_arr],
          profile_id_searched:  profile_id_searched
      }
      search_match(search_match_data)

      iteration += 1  # DEBUGG_TO_LOGG
    end
  end


  # @note: Поиск совпадений для одного из профилей
  #  Берем параметр: profile_id из массива  = profiles_search_data[:tree_profiles]
  def search_match(search_match_data)
    connected_users     = search_match_data[:connected_author_arr]
    profile_id_searched = search_match_data[:profile_id_searched]
    found_profiles_hash, profiles_hash, one_profile_relations_hash = {}, {}, {}  # init local hashes

    all_profile_rows = ProfileKey.where(:user_id => connected_users)
                           .where(:profile_id => profile_id_searched, deleted: 0)
                           .order('relation_id','is_name_id')
                           .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
                           .distinct
    # поиск массива записей искомого круга для каждого профиля в дереве Юзера
    logger.info "Круг ИСКОМОГО ПРОФИЛЯ = #{profile_id_searched.inspect} в (объединенном) дереве #{connected_users} зарег-го Юзера"      # :user_id, , :id
    show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG

    if all_profile_rows.blank?
      logger.info "ERROR in search_match: В искомом дереве - НЕТ искомого профиля!?? "
    else
      # допускаем до поиска те круги искомых профилей, размер кот-х (кругов) больше или равно коэфф-та достоверности
      if all_profile_rows.size >= search_match_data[:certain_koeff]
        all_profile_rows_no = 1 # DEBUGG_TO_LOGG
        all_profile_rows.each do |relation_row|
          search_data = {
            profiles_hash:              profiles_hash,
            relation_row:               relation_row,
            connected_users:            connected_users,
            profile_id_searched:        profile_id_searched,
            all_profile_rows_no:        all_profile_rows_no,
            one_profile_relations_hash: one_profile_relations_hash
          }
          found_profiles_hash = search_profile_relations(search_data)
          all_profile_rows_no += 1 # Подсчет номера по порядку очередной записи об искомом профиле  # DEBUGG_TO_LOGG
        end
      end
    end
    # ДОПОЛНИТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
    @profiles_relations_arr = SearchWork.make_profile_relations(profile_id_searched, one_profile_relations_hash, @profiles_relations_arr)

    # ОСНОВНОЙ РЕЗ-ТАТ ПОИСКА - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (массив):
    # {профиль искомый -> дерево -> профиль найденный -> [ массив совпавших отношений с искомым профилем ]
    @profiles_found_arr << found_profiles_hash unless found_profiles_hash.empty? # Заполнение выходного массива хэшей
    logger.info "Где что найдено: Для искомого профиля #{profile_id_searched} - в конце этого Хэша @profiles_found_arr:"
    logger.info "#{@profiles_found_arr} " # DEBUGG_TO_LOGG
  end # End of search_match


  # @note: main search method
  def search_profile_relations(search_data)
    profiles_hash = search_data[:profiles_hash]
    relation_row  = search_data[:relation_row]
    one_profile_relations_hash = search_data[:one_profile_relations_hash]
    logger.info "In  search_profile_relations: search_data = #{search_data}"

    found_profiles_data = {
        profiles_hash:       profiles_hash,
        relation_row:        relation_row,
        connected_users:     search_data[:connected_users],
        profile_id_searched: search_data[:profile_id_searched]
    }
    one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)
    logger.info "## In  search_profile_relations: one_profile_relations_hash = #{one_profile_relations_hash}"
    # Получение РЕЗ-ТАТа ПОИСКА для одной записи Kруга искомого профиля - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
    found_profiles_hash = get_found_profiles(found_profiles_data)
    logger.info "## In  search_profile_relations, after : found_profiles_hash = #{found_profiles_hash}"

    logger_data = {
        all_profile_rows_no:        search_data[:all_profile_rows_no],
        one_profile_relations_hash: one_profile_relations_hash,
        profiles_hash:              profiles_hash,
        found_profiles_hash:        found_profiles_hash
    }
    debug_logger(logger_data) # Debug

    found_profiles_hash
  end


  #  @note: Получение РЕЗ-ТАТа ПОИСКА - found_profiles_hash - для одной записи круга искомого профиля
  #   found_profiles_hash - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
  #   Если вставлять деревья, кот-е надо исключить для поиска, то - это здесь: where.not(user_id: search_exclude_users)
  #   search_exclude_users = [22,134,...]
  def get_found_profiles(found_profiles_data)
    logger.info "In  get_found_profiles: found_profiles_data = #{found_profiles_data}"

    connected_users     = found_profiles_data[:connected_users]
    relation_row        = found_profiles_data[:relation_row]
    row_relation_id     = relation_row.relation_id

    relation_match_arr = ProfileKey.where.not(user_id: connected_users)
                             .where(:name_id => relation_row.name_id,
                                    :relation_id => row_relation_id,
                                    :is_name_id => relation_row.is_name_id, deleted: 0)
                             .order('user_id','relation_id','is_name_id')
                             .select(:id, :user_id, :profile_id, :name_id,
                                     :relation_id, :is_profile_id, :is_name_id)
                             .distinct
    profiles_data = {
      row_relation_id:      row_relation_id,
      profiles_hash:        found_profiles_data[:profiles_hash],
      profile_id_searched:  found_profiles_data[:profile_id_searched]
    }
    collect_profiles_hash(profiles_data, relation_match_arr)
  end


  # @note: Collect found_profiles_hash in depence of relations match in ProfileKey
  def collect_profiles_hash(profiles_data, relation_match_arr)

    row_relation_id     = profiles_data[:row_relation_id]
    profiles_hash       = profiles_data[:profiles_hash]
    profile_id_searched = profiles_data[:profile_id_searched]

    found_profiles_hash = Hash.new  #
    if relation_match_arr.blank?
      found_profiles_hash.merge!( profile_id_searched  => profiles_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
    else
      show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
      logger.info "In ELSE  collect_profiles_hash: relation_match_arr.SIZE = #{relation_match_arr.size}"

      relation_match_arr.each do |tree_row|
        fill_arrays_data = {
          profiles_hash:    profiles_hash,
          tree_user_id:     tree_row.user_id,
          tree_profile_id:  tree_row.profile_id,
          row_relation_id:  row_relation_id
        }
        found_profiles_hash.merge!( profile_id_searched  => SearchWork.fill_arrays_in_hash(fill_arrays_data) ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      end
    end
    logger.info "In  collect_profiles_hash: found_profiles_hash = #{found_profiles_hash}"

    found_profiles_hash
  end


  # @note: Основной поиск по дереву Автора - Юзера.
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_from_tree(certain_koeff) #certain_koeff, connected_users_arr, tree_profiles)
    if @profiles_found_arr.blank?
      init_class_vars
    else
      # Запуск метода выбора пар профилей с максимальной мощностью множеств совпадений отношений
      max_power_profiles_pairs_hash, duplicates_one_to_many, profiles_with_match_hash =
          SearchWork.get_certain_profiles_pairs(@profiles_found_arr, certain_koeff)
      # Удаление дубликатов типа duplicates_many_to_one # duplicates_out - метод в hasher.rb
      uniq_profiles_pairs, duplicates_many_to_one = SearchWork.duplicates_out(max_power_profiles_pairs_hash)  # Ok
      # Удаление пустых хэшей из результатов # Exclude empty hashes
      uniq_profiles_pairs.delete_if { |key,val|  val == {} }
      # РЕЗУЛЬТАТЫ ПОИСКА ДЛЯ ОТОБРАЖЕНИЯ НА ГЛАВНОЙ #####
      by_profiles, by_trees = SearchResults.make_search_results(uniq_profiles_pairs, profiles_with_match_hash)
      search_results_data = {
        uniq_profiles_pairs:      uniq_profiles_pairs,
        profiles_with_match_hash: profiles_with_match_hash,
        duplicates_one_to_many:   duplicates_one_to_many,
        duplicates_many_to_one:   duplicates_many_to_one,
        by_profiles:              by_profiles,
        by_trees:                 by_trees
      }
      get_search_results(search_results_data)
    end
  end


  # @note: collect results vars
  #  ПРОМЕЖУТОЧНЫЕ РЕЗУЛЬТАТЫ ПОИСКА
  def get_search_results(search_results_data)
    @uniq_profiles_pairs      = search_results_data[:uniq_profiles_pairs]
    @profiles_with_match_hash = search_results_data[:profiles_with_match_hash]
    @duplicates_one_to_many   = search_results_data[:duplicates_one_to_many]
    @duplicates_many_to_one   = search_results_data[:duplicates_many_to_one]
    @by_profiles              = search_results_data[:by_profiles]
    @by_trees                 = search_results_data[:by_trees]
    logger_search_results(search_results_data)
    logger.info " by_profiles = #{@by_profiles} "
    logger.info " by_trees = #{@by_trees} "
  end


  # @note: init vars of Class to be in results
  def init_class_vars
    logger.info "** NO SEARCH RESULTS & NO DUBLICATES**"
    @uniq_profiles_pairs = {}
    @by_profiles = {}
    @by_trees = {}
    @duplicates_one_to_many = {}
    @duplicates_many_to_one = {}
  end



end # End of search module

# # From 46 - > in 45 .. 47
#
# # by_profiles
#  [{:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7},
#   {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
#   {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7},
#   {:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>7},
#   {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7},
#   {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>7},
#   {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7},
#   {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>7},
#   {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7},
#   {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>5},
#   {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5},
#   {:search_profile_id=>662, :found_tree_id=>34, :found_profile_id=>540, :count=>5},
#   {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5},
#   {:search_profile_id=>657, :found_tree_id=>34, :found_profile_id=>539, :count=>5},
#   {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>5},
#   {:search_profile_id=>658, :found_tree_id=>34, :found_profile_id=>544, :count=>5},
#   {:search_profile_id=>659, :found_tree_id=>34, :found_profile_id=>543, :count=>5},
#   {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5},
#   {:search_profile_id=>663, :found_tree_id=>34, :found_profile_id=>541, :count=>5},
#   {:search_profile_id=>656, :found_tree_id=>34, :found_profile_id=>542, :count=>5}]
#
# # by_trees
#  [{:found_tree_id=>34, :found_profile_ids=>[542, 541, 543, 544, 539, 540]},
#   {:found_tree_id=>45, :found_profile_ids=>[649, 650, 645, 646, 651, 647]},
#   {:found_tree_id=>47, :found_profile_ids=>[669, 671, 666, 668, 672, 667, 670, 673]}]
#
# # duplicates_one_to_many
#  {711=>{45=>{648=>5, 710=>5}}}
#
#
# # From 45 - > in 46 .. 47
# # [inf] by_profiles =
#     [{:search_profile_id=>649, :found_tree_id=>46, :found_profile_id=>656, :count=>7},
#      {:search_profile_id=>646, :found_tree_id=>46, :found_profile_id=>664, :count=>7},
#      {:search_profile_id=>647, :found_tree_id=>46, :found_profile_id=>665, :count=>7},
#      {:search_profile_id=>650, :found_tree_id=>46, :found_profile_id=>659, :count=>7},
#      {:search_profile_id=>645, :found_tree_id=>46, :found_profile_id=>658, :count=>7},
#      {:search_profile_id=>649, :found_tree_id=>47, :found_profile_id=>669, :count=>5},
#      {:search_profile_id=>646, :found_tree_id=>47, :found_profile_id=>672, :count=>5},
#      {:search_profile_id=>651, :found_tree_id=>47, :found_profile_id=>667, :count=>5},
#      {:search_profile_id=>651, :found_tree_id=>46, :found_profile_id=>657, :count=>5},
#      {:search_profile_id=>647, :found_tree_id=>47, :found_profile_id=>673, :count=>5},
#      {:search_profile_id=>650, :found_tree_id=>47, :found_profile_id=>666, :count=>5},
#      {:search_profile_id=>645, :found_tree_id=>47, :found_profile_id=>668, :count=>5}]
#
# # [inf] by_trees =
#     [{:found_tree_id=>46, :found_profile_ids=>[658, 659, 665, 657, 664, 656]},
#      {:found_tree_id=>47, :found_profile_ids=>[668, 666, 673, 667, 672, 669]}]
#
# # duplicates_Many_to_One =
#     {648=>{46=>711}, 710=>{46=>711}}

# From 46 - > in 45 .. 47


#== Local 1 + 2  search from 3
# END OF start_search =========================
#        ======== search_data:
# {:connected_author_arr=>[3],
#  :qty_of_tree_profiles=>5,
#  :profiles_relations_arr=>
#      [{20=>{62=>3, 19=>8, 17=>15, 18=>16}},
#       {19=>{17=>1, 18=>2, 62=>3, 16=>6, 20=>7}},
#       {62=>{20=>1, 19=>2, 17=>92, 18=>102, 16=>202}},
#       {17=>{19=>4, 16=>4, 18=>8, 20=>18, 62=>112}},
#       {18=>{19=>4, 16=>4, 17=>7, 20=>18, 62=>112}}],
#  :profiles_found_arr=>
#      [{20=>{1=>{13=>[3, 8, 15, 16]},
#             2=>{13=>[3, 8, 15, 16]}}},
#       {19=>{1=>{7=>[1, 2, 3, 7]},
#             2=>{7=>[1, 2, 3, 6, 7]}}},
#       {62=>{1=>{11=>[1, 2, 92, 102]},
#             2=>{11=>[1, 2, 92, 102, 202]}}},
#       {17=>{1=>{8=>[4, 8, 18, 112]},
#             2=>{8=>[4, 4, 8, 18, 112]}}},
#       {18=>{1=>{9=>[4, 7, 18, 112]},
#             2=>{9=>[4, 4, 7, 18, 112]}}}],
#  :uniq_profiles_pairs=>
#      {20=>{1=>13, 2=>13},
#       19=>{1=>7, 2=>7},
#       62=>{1=>11, 2=>11},
#       17=>{1=>8, 2=>8},
#       18=>{1=>9, 2=>9}},
#  :profiles_with_match_hash=>
#      {9=>5, 8=>5, 7=>5, 11=>5, 13=>4},
#  :by_profiles=>
#      [{:search_profile_id=>18, :found_tree_id=>2, :found_profile_id=>9, :count=>5},
#       {:search_profile_id=>18, :found_tree_id=>1, :found_profile_id=>9, :count=>5},
#       {:search_profile_id=>17, :found_tree_id=>2, :found_profile_id=>8, :count=>5},
#       {:search_profile_id=>17, :found_tree_id=>1, :found_profile_id=>8, :count=>5},
#       {:search_profile_id=>19, :found_tree_id=>1, :found_profile_id=>7, :count=>5},
#       {:search_profile_id=>62, :found_tree_id=>1, :found_profile_id=>11, :count=>5},
#       {:search_profile_id=>19, :found_tree_id=>2, :found_profile_id=>7, :count=>5},
#       {:search_profile_id=>62, :found_tree_id=>2, :found_profile_id=>11, :count=>5},
#       {:search_profile_id=>20, :found_tree_id=>2, :found_profile_id=>13, :count=>4},
#       {:search_profile_id=>20, :found_tree_id=>1, :found_profile_id=>13, :count=>4}],
#  :by_trees=>
#      [{:found_tree_id=>1, :found_profile_ids=>[13, 7, 11, 8, 9]},
#       {:found_tree_id=>2, :found_profile_ids=>[13, 7, 11, 8, 9]}],
#  :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}
# #


# {:connected_author_arr=>[1, 2], :qty_of_tree_profiles=>16,
#  :profiles_relations_arr=>[{:profile_searched=>9, :profile_relations=>{3=>4, 10=>8, 2=>18, 17=>112}},
#                            {:profile_searched=>15, :profile_relations=>{17=>1, 11=>2, 243=>4, 16=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202}},
#                            {:profile_searched=>14, :profile_relations=>{12=>1, 13=>2, 11=>6, 18=>91, 19=>101, 15=>212, 16=>212}},
#                            {:profile_searched=>243, :profile_relations=>{}},
#                            {:profile_searched=>8, :profile_relations=>{2=>3, 7=>7, 3=>17, 17=>111}},
#                            {:profile_searched=>19, :profile_relations=>{12=>3, 18=>7, 11=>121, 14=>121}},
#                            {:profile_searched=>11, :profile_relations=>{12=>1, 13=>2, 15=>3, 16=>3, 14=>6, 17=>7, 2=>13, 3=>14, 18=>91, 19=>101}},
#                            {:profile_searched=>2, :profile_relations=>{7=>1, 8=>2, 17=>3, 3=>8, 9=>15, 10=>16, 11=>17, 15=>111, 16=>111}},
#                            {:profile_searched=>7, :profile_relations=>{2=>3, 8=>8, 3=>17, 17=>111}},
#                            {:profile_searched=>16, :profile_relations=>{17=>1, 11=>2, 15=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202}},
#                            {:profile_searched=>10, :profile_relations=>{3=>4, 9=>7, 2=>18, 17=>112}},
#                            {:profile_searched=>17, :profile_relations=>{2=>1, 3=>2, 15=>3, 16=>3, 11=>8, 12=>15, 13=>16, 7=>91, 9=>92, 8=>101, 10=>102}},
#                            {:profile_searched=>12, :profile_relations=>{18=>1, 19=>2, 11=>4, 14=>4, 13=>8, 17=>18, 15=>112, 16=>112}},
#                            {:profile_searched=>3, :profile_relations=>{9=>1, 10=>2, 17=>3, 2=>7, 7=>13, 8=>14, 11=>17, 15=>111, 16=>111}},
#                            {:profile_searched=>13, :profile_relations=>{11=>4, 14=>4, 12=>7, 17=>18, 15=>112, 16=>112}},
#                            {:profile_searched=>18, :profile_relations=>{12=>3, 19=>8, 11=>121, 14=>121}}],
#  :profiles_found_arr=>[{9=>{19=>{367=>[4]}}}, {15=>{3=>{215=>[1, 2, 5, 92, 102, 202]}, 9=>{85=>[1, 2, 4, 5, 91, 101]}, 10=>{100=>[1, 2, 4]}, 11=>{128=>[1, 2, 5, 91, 92, 101, 102]}}}, {14=>{3=>{22=>[1, 2, 6, 91, 101, 212, 212]}}}, {8=>{21=>{391=>[7]}}}, {19=>{3=>{27=>[3, 7, 121, 121]}}}, {11=>{3=>{25=>[1, 2, 3, 3, 6, 7, 91, 101]}, 11=>{127=>[1, 2, 3, 3, 7, 13, 14]}, 9=>{87=>[3, 3, 7, 13, 14]}, 10=>{171=>[3, 7]}}}, {2=>{9=>{172=>[3, 8, 17, 111, 111]}, 11=>{139=>[3, 8, 17, 111, 111]}}}, {7=>{21=>{390=>[8]}}}, {16=>{3=>{216=>[1, 2, 5, 92, 102, 202]}, 9=>{88=>[1, 2, 5, 91, 101]}, 11=>{125=>[1, 2, 5, 91, 92, 101, 102]}}}, {10=>{}}, {17=>{9=>{86=>[1, 2, 3, 3, 8]}, 11=>{126=>[1, 2, 3, 3, 8, 15, 16]}, 3=>{209=>[3, 3, 8, 15, 16]}, 10=>{170=>[3, 8]}}}, {12=>{3=>{23=>[1, 2, 4, 4, 8, 18, 112, 112]}, 11=>{155=>[4, 8, 18, 112, 112]}}}, {3=>{19=>{383=>[1]}, 9=>{173=>[3, 7, 17, 111, 111]}, 11=>{154=>[3, 7, 17, 111, 111]}}}, {13=>{3=>{24=>[4, 4, 7, 18, 112, 112]}, 11=>{156=>[4, 7, 18, 112, 112]}}}, {18=>{3=>{26=>[3, 8, 121, 121]}}}],
#  :uniq_profiles_pairs=>{15=>{3=>215, 9=>85, 11=>128}, 14=>{3=>22}, 19=>{3=>27}, 11=>{3=>25, 11=>127, 9=>87}, 2=>{9=>172, 11=>139}, 16=>{3=>216, 9=>88, 11=>125}, 17=>{9=>86, 11=>126, 3=>209}, 12=>{3=>23, 11=>155}, 3=>{9=>173, 11=>154}, 13=>{3=>24, 11=>156}, 18=>{3=>26}},
#  :profiles_with_match_hash=>{23=>8, 25=>8, 126=>7, 125=>7, 127=>7, 22=>7, 128=>7, 24=>6, 216=>6, 85=>6, 215=>6, 156=>5, 154=>5, 173=>5, 155=>5, 209=>5, 86=>5, 88=>5, 139=>5, 172=>5, 87=>5, 26=>4, 27=>4},
#  :by_profiles=>[{:search_profile_id=>12, :found_tree_id=>3, :found_profile_id=>23, :count=>8},
#                 {:search_profile_id=>11, :found_tree_id=>3, :found_profile_id=>25, :count=>8},
#                 {:search_profile_id=>17, :found_tree_id=>11, :found_profile_id=>126, :count=>7},
#                 {:search_profile_id=>16, :found_tree_id=>11, :found_profile_id=>125, :count=>7},
#                 {:search_profile_id=>11, :found_tree_id=>11, :found_profile_id=>127, :count=>7},
#                 {:search_profile_id=>14, :found_tree_id=>3, :found_profile_id=>22, :count=>7},
#                 {:search_profile_id=>15, :found_tree_id=>11, :found_profile_id=>128, :count=>7},
#                 {:search_profile_id=>13, :found_tree_id=>3, :found_profile_id=>24, :count=>6},
#                 {:search_profile_id=>16, :found_tree_id=>3, :found_profile_id=>216, :count=>6},
#                 {:search_profile_id=>15, :found_tree_id=>9, :found_profile_id=>85, :count=>6},
#                 {:search_profile_id=>15, :found_tree_id=>3, :found_profile_id=>215, :count=>6},
#                 {:search_profile_id=>13, :found_tree_id=>11, :found_profile_id=>156, :count=>5},
#                 {:search_profile_id=>3, :found_tree_id=>11, :found_profile_id=>154, :count=>5},
#                 {:search_profile_id=>3, :found_tree_id=>9, :found_profile_id=>173, :count=>5},
#                 {:search_profile_id=>12, :found_tree_id=>11, :found_profile_id=>155, :count=>5},
#                 {:search_profile_id=>17, :found_tree_id=>3, :found_profile_id=>209, :count=>5},
#                 {:search_profile_id=>17, :found_tree_id=>9, :found_profile_id=>86, :count=>5},
#                 {:search_profile_id=>16, :found_tree_id=>9, :found_profile_id=>88, :count=>5},
#                 {:search_profile_id=>2, :found_tree_id=>11, :found_profile_id=>139, :count=>5},
#                 {:search_profile_id=>2, :found_tree_id=>9, :found_profile_id=>172, :count=>5},
#                 {:search_profile_id=>11, :found_tree_id=>9, :found_profile_id=>87, :count=>5},
#                 {:search_profile_id=>18, :found_tree_id=>3, :found_profile_id=>26, :count=>4},
#                 {:search_profile_id=>19, :found_tree_id=>3, :found_profile_id=>27, :count=>4}],
#  :by_trees=>[{:found_tree_id=>3, :found_profile_ids=>[215, 22, 27, 25, 216, 209, 23, 24, 26]},
#              {:found_tree_id=>9, :found_profile_ids=>[85, 87, 172, 88, 86, 173]},
#              {:found_tree_id=>11, :found_profile_ids=>[128, 127, 139, 125, 126, 155, 154, 156]}],
#  :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}
#



    {:tree_profiles=>[656, 659, 664, 658, 545, 660, 663, 547, 657, 546, 662, 665, 548, 661],
     :connected_author_arr=>[34, 46], :qty_of_tree_profiles=>14,
     :profiles_relations_arr=>[{:profile_searched=>656, :profile_relations=>{657=>1, 658=>2, 660=>4, 659=>5, 661=>8, 662=>91, 664=>92, 663=>101, 665=>102}},
                               {:profile_searched=>659, :profile_relations=>{657=>1, 658=>2, 656=>5, 662=>91, 664=>92, 663=>101, 665=>102, 660=>221}}, {:profile_searched=>664, :profile_relations=>{658=>4, 665=>8, 657=>18, 656=>112, 659=>112}},
                               {:profile_searched=>658, :profile_relations=>{664=>1, 665=>2, 656=>3, 659=>3, 657=>7, 662=>13, 663=>14, 661=>17, 660=>121}},
                               {:profile_searched=>545, :profile_relations=>{662=>3, 546=>8, 663=>17, 657=>111}}, {:profile_searched=>660, :profile_relations=>{656=>1, 661=>2, 657=>91, 658=>101, 659=>191}}, {:profile_searched=>663, :profile_relations=>{547=>1, 548=>2, 657=>3, 662=>7, 545=>13, 546=>14, 658=>17, 656=>111, 659=>111}}, {:profile_searched=>547, :profile_relations=>{663=>4, 548=>8, 662=>18, 657=>112}},
                               {:profile_searched=>657, :profile_relations=>{662=>1, 663=>2, 656=>3, 659=>3, 658=>8, 664=>15, 665=>16, 661=>17, 545=>91, 547=>92, 546=>101, 548=>102, 660=>121}}, {:profile_searched=>546, :profile_relations=>{662=>3, 545=>7, 663=>17, 657=>111}}, {:profile_searched=>662, :profile_relations=>{545=>1, 546=>2, 657=>3, 663=>8, 547=>15, 548=>16, 658=>17, 656=>111, 659=>111}},
                               {:profile_searched=>665, :profile_relations=>{658=>4, 664=>7, 657=>18, 656=>112, 659=>112}}, {:profile_searched=>548, :profile_relations=>{663=>4, 547=>7, 662=>18, 657=>112}}, {:profile_searched=>661, :profile_relations=>{660=>4, 656=>7, 657=>13, 658=>14}}],
     :profiles_found_arr=>[{656=>{45=>{649=>[1, 2, 5, 92, 102]}, 47=>{669=>[1, 2, 5, 91, 92, 101, 102]}}}, {659=>{45=>{650=>[1, 2, 5, 92, 102]}, 47=>{666=>[1, 2, 5, 91, 92, 101, 102]}}}, {664=>{45=>{646=>[4, 8, 18, 112, 112]}, 47=>{672=>[4, 8, 18, 112, 112]}}}, {658=>{45=>{645=>[1, 2, 3, 3, 7]}, 47=>{668=>[1, 2, 3, 3, 7, 13, 14]}}}, {545=>{}}, {660=>{}}, {663=>{19=>{383=>[1]}, 47=>{671=>[3, 7, 17, 111, 111]}}}, {547=>{19=>{367=>[4]}}}, {657=>{47=>{667=>[1, 2, 3, 3, 8, 15, 16]}, 45=>{651=>[3, 3, 8, 15, 16]}}}, {546=>{}}, {662=>{47=>{670=>[3, 8, 17, 111, 111]}}}, {665=>{45=>{647=>[4, 7, 18, 112, 112]}, 47=>{673=>[4, 7, 18, 112, 112]}}}, {548=>{}}, {661=>{}}],
     :uniq_profiles_pairs=>{656=>{45=>649, 47=>669}, 659=>{45=>650, 47=>666}, 664=>{45=>646, 47=>672}, 658=>{45=>645, 47=>668}, 663=>{47=>671}, 657=>{47=>667, 45=>651}, 662=>{47=>670}, 665=>{45=>647, 47=>673}},
     :profiles_with_match_hash=>{667=>7, 668=>7, 666=>7, 669=>7, 673=>5, 647=>5, 670=>5, 651=>5, 671=>5, 645=>5, 672=>5, 646=>5, 650=>5, 649=>5}, :by_profiles=>[{:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7}, {:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>7}, {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>7}, {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>7}, {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>5}, {:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>5}, {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5}, {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5}, {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5}, {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>5}, {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>5}, {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>5}, {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>5}, {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>5}],
     :by_trees=>[{:found_tree_id=>45, :found_profile_ids=>[649, 650, 646, 645, 651, 647]}, {:found_tree_id=>47, :found_profile_ids=>[669, 666, 672, 668, 671, 667, 670, 673]}],
     :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}


    {:tree_profiles=>[656, 659, 664, 734, 658, 545, 660, 663, 547, 657, 546, 662, 665, 548, 661],
     :connected_author_arr=>[34, 46], :qty_of_tree_profiles=>15,
     :profiles_relations_arr=>[{:profile_searched=>656, :profile_relations=>{657=>1, 658=>2, 660=>4, 659=>5, 661=>8, 662=>91, 664=>92, 663=>101, 665=>102, 734=>202}}, {:profile_searched=>659, :profile_relations=>{657=>1, 658=>2, 656=>5, 662=>91, 664=>92, 663=>101, 665=>102, 734=>202, 660=>221}}, {:profile_searched=>664, :profile_relations=>{658=>4, 734=>4, 665=>8, 657=>18, 656=>112, 659=>112}}, {:profile_searched=>734, :profile_relations=>{664=>1, 665=>2, 658=>6, 656=>212, 659=>212}}, {:profile_searched=>658, :profile_relations=>{664=>1, 665=>2, 656=>3, 659=>3, 734=>6, 657=>7, 662=>13, 663=>14, 661=>17, 660=>121}}, {:profile_searched=>545, :profile_relations=>{662=>3, 546=>8, 663=>17, 657=>111}}, {:profile_searched=>660, :profile_relations=>{656=>1, 661=>2, 657=>91, 658=>101, 659=>191}}, {:profile_searched=>663, :profile_relations=>{547=>1, 548=>2, 657=>3, 662=>7, 545=>13, 546=>14, 658=>17, 656=>111, 659=>111}},
                                                                                           {:profile_searched=>547, :profile_relations=>{663=>4, 548=>8, 662=>18, 657=>112}}, {:profile_searched=>657, :profile_relations=>{662=>1, 663=>2, 656=>3, 659=>3, 658=>8, 664=>15, 665=>16, 661=>17, 545=>91, 547=>92, 546=>101, 548=>102, 660=>121}}, {:profile_searched=>546, :profile_relations=>{662=>3, 545=>7, 663=>17, 657=>111}}, {:profile_searched=>662, :profile_relations=>{545=>1, 546=>2, 657=>3, 663=>8, 547=>15, 548=>16, 658=>17, 656=>111, 659=>111}}, {:profile_searched=>665, :profile_relations=>{658=>4, 734=>4, 664=>7, 657=>18, 656=>112, 659=>112}}, {:profile_searched=>548, :profile_relations=>{663=>4, 547=>7, 662=>18, 657=>112}}, {:profile_searched=>661, :profile_relations=>{660=>4, 656=>7, 657=>13, 658=>14}}], :profiles_found_arr=>[{656=>{45=>{649=>[1, 2, 5, 92, 102, 202, 202]}, 47=>{669=>[1, 2, 5, 91, 92, 101, 102, 202]}}}, {659=>{45=>{650=>[1, 2, 5, 92, 102, 202, 202]}, 47=>{666=>[1, 2, 5, 91, 92, 101, 102, 202]}}}, {664=>{45=>{646=>[4, 4, 4, 8, 18, 112, 112]}, 47=>{672=>[4, 4, 8, 18, 112, 112]}}}, {734=>{45=>{648=>[1, 2, 6, 212, 212], 733=>[1, 2, 6, 212, 212]}, 47=>{721=>[1, 2, 6, 212, 212]}}}, {658=>{45=>{645=>[1, 2, 3, 3, 6, 6, 7]}, 47=>{668=>[1, 2, 3, 3, 6, 7, 13, 14]}}}, {545=>{}}, {660=>{}}, {663=>{19=>{383=>[1]}, 47=>{671=>[3, 7, 17, 111, 111]}}}, {547=>{19=>{367=>[4]}}}, {657=>{47=>{667=>[1, 2, 3, 3, 8, 15, 16]}, 45=>{651=>[3, 3, 8, 15, 16]}}}, {546=>{}}, {662=>{47=>{670=>[3, 8, 17, 111, 111]}}}, {665=>{45=>{647=>[4, 4, 4, 7, 18, 112, 112]}, 47=>{673=>[4, 4, 7, 18, 112, 112]}}}, {548=>{}}, {661=>{}}],
     :uniq_profiles_pairs=>{656=>{45=>649, 47=>669}, 659=>{45=>650, 47=>666}, 664=>{45=>646, 47=>672}, 734=>{47=>721}, 658=>{45=>645, 47=>668}, 663=>{47=>671}, 657=>{47=>667, 45=>651}, 662=>{47=>670}, 665=>{45=>647, 47=>673}},
     :profiles_with_match_hash=>{668=>8, 666=>8, 669=>8, 647=>7, 667=>7, 645=>7, 646=>7, 650=>7, 649=>7, 673=>6, 672=>6, 670=>5, 651=>5, 671=>5, 721=>5},
     :by_profiles=>[{:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>8}, {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>8}, {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>8}, {:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7}, {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
                    {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7}, {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7}, {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7}, {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7}, {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>6}, {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>6}, {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5}, {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5}, {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5}, {:search_profile_id=>734, :found_tree_id=>47, :found_profile_id=>721, :count=>5}],
     :by_trees=>[{:found_tree_id=>47, :found_profile_ids=>[669, 666, 672, 721, 668, 671, 667, 670, 673]}], :duplicates_one_to_many=>{734=>{45=>{648=>5, 733=>5}}},
     :duplicates_many_to_one=>{}}

