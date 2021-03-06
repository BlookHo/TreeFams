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
  def old_start_search(certain_koeff)

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
      ############# РЕЗУЛЬТАТЫ ПОИСКА для save & display in Meteor ######
      by_profiles:              @by_profiles,
      by_trees:                 @by_trees,
      ############### ДУБЛИКАТЫ ПОИСКА ######## NEW METHOD ############
      duplicates_one_to_many:   @duplicates_one_to_many,
      duplicates_many_to_one:   @duplicates_many_to_one }
    # end_search_time = Time.now

    SearchResults.store_search_results(results, self.id) # запись рез-тов поиска в таблицу - для Метеора

    self.start_check_double(results, certain_koeff) if self.double == 0

    end_search_time = Time.now

    logger.info "results[:connected_author_arr] = #{results[:connected_author_arr].inspect}"
    logger.info "results[:by_profiles] = #{results[:by_profiles].inspect}"
    logger.info "results[:by_trees] = #{results[:by_trees].inspect}"
    logger.info "results[:duplicates_one_to_many] = #{results[:duplicates_one_to_many].inspect}"
    logger.info "results[:duplicates_many_to_one] = #{results[:duplicates_many_to_one].inspect}"
    logger.info "results[:profiles_relations_arr] = #{results[:profiles_relations_arr].inspect}"
    search_time = (end_search_time - start_search_time) * 1000
    logger.info "== END OF start_search === Search_time =  #{search_time.round(2)} msec  \n\n"

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
      # logger.info "***** Цикл ПОИСКa: #{iteration+1}-я ИТЕРАЦИЯ - Ищем профиль: #{profile_id_searched.inspect};"
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
    # logger.info "Круг ИСКОМОГО ПРОФИЛЯ = #{profile_id_searched.inspect} в (объединенном) дереве #{connected_users} зарег-го Юзера"      # :user_id, , :id
    # show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG

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
    # logger.info "Где что найдено: Для искомого профиля #{profile_id_searched} - в конце этого Хэша @profiles_found_arr:"
    # logger.info "#{@profiles_found_arr} " # DEBUGG_TO_LOGG
  end # End of search_match


  # @note: main search method
  def search_profile_relations(search_data)
    profiles_hash = search_data[:profiles_hash]
    relation_row  = search_data[:relation_row]
    one_profile_relations_hash = search_data[:one_profile_relations_hash]
    # logger.info "In  search_profile_relations: search_data = #{search_data}"

    found_profiles_data = {
        profiles_hash:       profiles_hash,
        relation_row:        relation_row,
        connected_users:     search_data[:connected_users],
        profile_id_searched: search_data[:profile_id_searched]
    }
    one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)
    # logger.info "## In  search_profile_relations: one_profile_relations_hash = #{one_profile_relations_hash}"
    # Получение РЕЗ-ТАТа ПОИСКА для одной записи Kруга искомого профиля - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
    found_profiles_hash = get_found_profiles(found_profiles_data)
    # logger.info "## In  search_profile_relations, after : found_profiles_hash = #{found_profiles_hash}"

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
    # logger.info "In  get_found_profiles: found_profiles_data = #{found_profiles_data}"

    connected_users     = found_profiles_data[:connected_users] + [106]
    # 106 - admin user - todo: place this id in Weafam_settings
    # logger.info "In  get_found_profiles: connected_users = #{connected_users}"
    relation_row        = found_profiles_data[:relation_row]
    row_relation_id     = relation_row.relation_id

    relation_match_arr = ProfileKey.where.not(user_id: connected_users)
                             .where(:name_id => relation_row.name_id,
                                    :relation_id => row_relation_id,
                                    :is_name_id => relation_row.is_name_id, deleted: 0)
                             .order('user_id','relation_id','is_name_id')
                             .select(:user_id, :profile_id, :name_id,
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
    # logger.info "In  collect_profiles_hash: profiles_data = #{profiles_data}"
    # logger.info "In  collect_profiles_hash: relation_match_arr = #{relation_match_arr}"

    row_relation_id     = profiles_data[:row_relation_id]
    profiles_hash       = profiles_data[:profiles_hash]
    profile_id_searched = profiles_data[:profile_id_searched]

    found_profiles_hash = Hash.new  #
    if relation_match_arr.blank?
      found_profiles_hash.merge!( profile_id_searched  => profiles_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      # logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
    else
      show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
      # logger.info "In ELSE  collect_profiles_hash: relation_match_arr.SIZE = #{relation_match_arr.size}"

      relation_match_arr.each do |tree_row|
        fill_arrays_data = {
          profiles_hash:    profiles_hash,
          tree_user_id:     tree_row.user_id,
          tree_profile_id:  tree_row.profile_id,
          row_relation_id:  row_relation_id
        }
        # logger.info "In  collect_profiles_hash: fill_arrays_data = #{fill_arrays_data}"
        found_profiles_hash.merge!( profile_id_searched  => SearchWork.fill_arrays_in_hash(fill_arrays_data) ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      end
    end
    # logger.info "In  collect_profiles_hash: found_profiles_hash = #{found_profiles_hash}"

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

      logger.info "Before SearchResults: uniq_profiles_pairs = #{uniq_profiles_pairs}, profiles_with_match_hash = #{profiles_with_match_hash} "

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


# id user_id  profile_id  name_id relation_id is_profile_id  is_name_id
5605;57       ;790;         28;       1;          791;          122
5607;57;       790;         28;       2;          792;          82
5611;57       ;790;         28;       3;          793;          370
5617;57;      790;          28;       3;          794;          465
5625;57;      790;          28;       8;          795;          48
5637;57;      790;          28;       91;         796;          90
5645;57;      790;          28;       101;        797;          449
5651;57;      790;          28;       92;         798;          361
5659;57;      790;          28;       102;        799;          293
5689;57;      790;          28;       17;         804;          147;   1
6081;57;      790;          28;       1;          860;          122;   1
6387;57;      790;          28;       17;         897;          147
6395;57;      790;          28;       121;        898;          446


5724;58;      811;          28;       8;          805;          48
5726;58;      811;          28;       3;          810;          465
5728;58;      811;          28;       3;          809;          370
5730;58;      811;          28;       15;         806;          343
5732;58;      811;          28;       16;         807;          82
6371;58;      811;          28;       17;         895;          147
6379;58;      811;          28;       121;        896;          446





# From 46 - > in 45 .. 47


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


160;3;1062;77;3;1059;155;"2015-10-22 15:45:21.540495";"2015-12-08 16:12:04.678911";0
163;3;1062;77;8;1063;453;"2015-10-22 15:45:21.61891";"2015-12-08 16:12:03.586208";0
167;3;1062;77;4;344;218;"2015-10-22 15:45:21.765319";"2015-12-08 16:12:02.514783";0
173;3;1062;77;4;345;335;"2015-10-22 15:45:21.887045";"2015-12-08 16:12:02.561271";0
181;3;1062;77;121;1058;176;"2015-10-22 15:45:22.116802";"2015-12-08 16:12:03.155729";0
193;3;1062;77;121;1061;151;"2015-10-22 15:45:22.300231";"2015-12-08 16:12:03.700507";0
207;3;1062;77;17;1060;107;"2015-10-22 15:45:22.506625";"2015-12-08 16:12:04.498616";0
211;3;1062;77;1;329;322;"2015-10-22 15:45:22.599002";"2015-12-08 16:12:02.596945";0
221;3;1062;77;2;330;178;"2015-10-22 15:45:22.763245";"2015-12-08 16:12:02.55227";0
241;3;1062;77;15;331;198;"2015-10-22 15:45:23.049555";"2015-12-08 16:12:02.608411";0
253;3;1062;77;16;332;572;"2015-10-22 15:45:23.245164";"2015-12-08 16:12:02.587479";0
257;3;1062;77;92;334;366;"2015-10-22 15:46:15.75848";"2015-12-08 16:12:02.572787";0
431;5;1062;77;1;329;322;"2015-10-23 07:52:40.660746";"2015-12-08 16:12:02.599728";0
433;5;1062;77;2;330;178;"2015-10-23 07:52:40.716623";"2015-12-08 16:12:02.554602";0
437;5;1062;77;3;1059;155;"2015-10-23 07:52:40.793408";"2015-12-08 16:12:04.684494";0
443;5;1062;77;4;344;218;"2015-10-23 07:52:40.876439";"2015-12-08 16:12:02.51704";0
451;5;1062;77;4;345;335;"2015-10-23 07:52:41.001849";"2015-12-08 16:12:02.563855";0
461;5;1062;77;8;1063;453;"2015-10-23 07:52:41.137631";"2015-12-08 16:12:03.590593";0
475;5;1062;77;92;334;366;"2015-10-23 07:52:41.359244";"2015-12-08 16:12:02.578968";0
483;5;1062;77;102;336;335;"2015-10-23 07:52:41.543768";"2015-12-08 16:12:02.52303";0
489;3;1062;77;18;346;322;"2015-10-23 18:06:41.451165";"2015-12-08 16:12:02.616844";0
497;3;1062;77;112;347;198;"2015-10-23 18:06:55.309876";"2015-12-08 16:12:02.541117";0
521;3;1062;77;192;337;166;"2015-10-23 18:11:36.701983";"2015-12-08 16:12:02.526142";0

1185;3;1062;77;1;136;77;"2015-10-24 14:40:46.316549";"2015-12-08 16:12:02.488583";0
1195;3;1062;77;5;137;27;"2015-10-24 14:46:04.311084";"2015-12-08 16:12:02.491001";1
1203;3;1062;77;6;99;349;"2015-10-24 14:46:18.763347";"2015-12-08 16:12:02.493873";0
1211;3;1062;77;5;139;39;"2015-10-24 14:46:53.814004";"2015-12-08 16:12:02.49617";0
1231;3;1062;77;212;100;42;"2015-10-24 14:48:27.602354";"2015-12-08 16:12:02.506112";0
1271;3;1062;77;5;147;27;"2015-10-24 14:59:09.359059";"2015-12-08 16:12:02.500538";0
1330;7;1062;77;4;344;218;"2015-10-24 15:16:15.284572";"2015-12-08 16:12:02.511986";0
1332;7;1062;77;112;347;198;"2015-10-24 15:16:15.30952";"2015-12-08 16:12:02.538862";0
1334;7;1062;77;18;346;322;"2015-10-24 15:16:15.327782";"2015-12-08 16:12:02.614179";0
1337;7;1062;77;8;1063;453;"2015-10-24 15:16:15.394074";"2015-12-08 16:12:03.58267";0
1718;11;1062;77;4;345;335;"2015-10-24 20:30:32.366588";"2015-12-08 16:12:02.567536";0
1721;11;1062;77;8;1063;453;"2015-10-24 20:30:32.429052";"2015-12-08 16:12:03.594303";0
1725;11;1062;77;3;1059;155;"2015-10-24 20:30:32.500219";"2015-12-08 16:12:04.688079";0
1731;11;1062;77;4;344;218;"2015-10-24 20:30:32.593575";"2015-12-08 16:12:02.519524";0
1737;11;1062;77;1;329;322;"2015-10-24 20:30:32.781871";"2015-12-08 16:12:02.602492";0
1747;11;1062;77;2;330;178;"2015-10-24 20:30:32.935193";"2015-12-08 16:12:02.556854";0
1767;11;1062;77;15;331;198;"2015-10-24 20:30:33.209667";"2015-12-08 16:12:02.611507";0
1779;11;1062;77;16;332;572;"2015-10-24 20:30:33.420855";"2015-12-08 16:12:02.592045";0
3244;13;1062;77;3;1059;155;"2015-10-28 07:44:43.211188";"2015-12-08 16:12:04.628554";0
3246;13;1062;77;121;1058;176;"2015-10-28 07:44:43.228846";"2015-12-08 16:12:03.20895";0
3248;13;1062;77;121;1061;151;"2015-10-28 07:44:43.246608";"2015-12-08 16:12:03.721208";0
3250;13;1062;77;17;1060;107;"2015-10-28 07:44:43.26457";"2015-12-08 16:12:04.495181";0

3253;13;1062;77;8;1063;453;"2015-10-28 07:44:43.32627";"2015-12-08 16:12:03.577032";0
3307;13;1062;77;1;329;322;"2015-10-28 07:48:11.009461";"2015-12-08 16:12:02.453196";0
3313;13;1062;77;2;330;178;"2015-10-28 07:48:26.010437";"2015-12-08 16:12:02.456113";0
3325;13;1062;77;15;331;198;"2015-10-28 07:48:39.731238";"2015-12-08 16:12:02.458355";0
3333;13;1062;77;16;332;572;"2015-10-28 07:48:55.293679";"2015-12-08 16:12:02.46062";0
3341;13;1062;77;15;333;534;"2015-10-28 07:49:12.847823";"2015-12-08 16:12:02.464748";1
3345;13;1062;77;92;334;366;"2015-10-28 07:49:53.899871";"2015-12-08 16:12:02.467085";0
3357;13;1062;77;102;336;335;"2015-10-28 08:05:35.299564";"2015-12-08 16:12:02.469298";0
3367;13;1062;77;192;337;166;"2015-10-28 08:05:48.318215";"2015-12-08 16:12:02.47175";0
3471;13;1062;77;4;344;218;"2015-10-28 08:53:24.141789";"2015-12-08 16:12:02.475192";0
3481;13;1062;77;4;345;335;"2015-10-28 08:53:35.771257";"2015-12-08 16:12:02.478112";0
3493;13;1062;77;18;346;322;"2015-10-28 08:54:01.10294";"2015-12-08 16:12:02.480329";0
3501;13;1062;77;112;347;198;"2015-10-28 08:54:20.431693";"2015-12-08 16:12:02.482921";0
7447;3;1062;77;221;799;218;"2015-11-13 19:29:21.439598";"2015-12-08 16:12:02.626375";0
8757;3;1062;77;2;940;101;"2015-11-21 17:08:04.668976";"2015-12-08 16:12:02.634246";0
8775;3;1062;77;91;941;450;"2015-11-21 17:09:30.856759";"2015-12-08 16:12:02.637198";0
8834;44;1062;77;4;344;218;"2015-11-21 18:18:24.373046";"2015-12-08 16:12:02.65607";0
8837;44;1062;77;8;1063;453;"2015-11-21 18:18:24.489187";"2015-12-08 16:12:03.631852";0
8841;44;1062;77;3;1059;155;"2015-11-21 18:18:24.595065";"2015-12-08 16:12:04.716377";0
8847;44;1062;77;4;345;335;"2015-11-21 18:18:24.716998";"2015-12-08 16:12:02.646814";0
8855;44;1062;77;112;347;198;"2015-11-21 18:18:24.842619";"2015-12-08 16:12:02.672194";0
8867;44;1062;77;18;346;322;"2015-11-21 18:18:25.052886";"2015-12-08 16:12:02.664295";0
8871;44;1062;77;1;329;322;"2015-11-21 18:18:25.170724";"2015-12-08 16:12:02.675516";0
8881;44;1062;77;2;330;178;"2015-11-21 18:18:25.303302";"2015-12-08 16:12:02.643853";0
8901;44;1062;77;15;331;198;"2015-11-21 18:18:25.616681";"2015-12-08 16:12:02.668583";0
8913;44;1062;77;16;332;572;"2015-11-21 18:18:25.801571";"2015-12-08 16:12:02.660789";0
8925;3;1062;77;4;959;335;"2015-11-22 17:28:34.206674";"2015-12-08 16:12:02.6397";1
9457;3;1062;77;121;1015;176;"2015-11-25 21:50:47.751572";"2015-12-08 16:12:02.442386";1
9537;3;1062;77;121;1019;176;"2015-11-26 16:27:02.640284";"2015-12-08 16:12:02.485161";1
9553;3;1062;77;121;1020;176;"2015-11-26 17:17:32.638981";"2015-12-08 16:12:02.503568";1
9868;50;1062;77;3;1059;155;"2015-12-08 16:06:45.54418";"2015-12-08 16:06:45.54418";0
9870;50;1062;77;121;1061;151;"2015-12-08 16:06:45.56466";"2015-12-08 16:06:45.56466";0
9872;50;1062;77;121;1058;176;"2015-12-08 16:06:45.588936";"2015-12-08 16:06:45.588936";0
9874;50;1062;77;17;1060;107;"2015-12-08 16:06:45.609598";"2015-12-08 16:06:45.609598";0
9877;50;1062;77;8;1063;453;"2015-12-08 16:06:45.69407";"2015-12-08 16:06:45.69407";0
14583;3;1062;77;121;1638;176;"2015-12-11 19:18:36.123866";"2015-12-11 19:20:37.185754";1
17947;3;1062;77;121;2067;374;"2015-12-18 14:29:06.677185";"2015-12-18 14:29:17.197934";1
23065;3;1062;77;121;2683;455;"2015-12-20 16:49:31.398503";"2015-12-20 16:50:20.026982";1
23081;3;1062;77;121;2684;130;"2015-12-20 16:52:37.466063";"2015-12-20 16:53:08.937034";1
25205;3;1062;77;121;2983;309;"2015-12-21 21:54:41.235794";"2015-12-21 21:55:00.574317";1
26457;3;1062;77;121;3173;218;"2015-12-22 14:00:30.651699";"2015-12-22 14:02:44.315928";1

33324;296;4101;77;2;4097;178;"2015-12-24 18:38:53.619809";"2015-12-24 19:18:15.53947";0
33326;296;4101;77;92;4098;366;"2015-12-24 18:38:53.639264";"2015-12-24 19:18:15.535463";0
33328;296;4101;77;102;4099;335;"2015-12-24 18:38:53.655307";"2015-12-24 19:18:15.530215";1
33330;296;4101;77;192;4100;245;"2015-12-24 18:38:53.672313";"2015-12-24 20:51:54.450913";0
33333;296;4101;77;1;4102;256;"2015-12-24 18:38:53.77359";"2015-12-24 20:59:45.404223";0
33347;296;4101;77;3;4104;428;"2015-12-24 18:41:12.99706";"2015-12-24 19:18:15.516412";1
33367;296;4101;77;8;4107;453;"2015-12-24 18:53:02.322848";"2015-12-24 19:18:15.506721";1
33379;296;4101;77;102;4108;418;"2015-12-24 18:53:26.012931";"2015-12-24 19:18:15.512189";0
33479;296;4101;77;8;4126;561;"2015-12-24 19:11:06.579664";"2015-12-24 19:18:15.50308";0
33485;296;4101;77;3;4127;424;"2015-12-24 19:12:10.343648";"2015-12-24 19:18:15.496473";0

