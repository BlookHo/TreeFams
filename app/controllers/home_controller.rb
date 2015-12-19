# class  Hash  # SuperHash <
#   def method_missing(name, *args, &block)
#
#     puts "method '#{name}' is missing"
#
#     key = name#.to_s
#     # logger.info "In method_missing name = #{key}" #", self = #{self} " #  unless tree_info.blank?
#     # if key?(name)
#     #   self[name]
#     # else
#     #   super
#     # end
#
#     self.class.send :define_method, name do
#       # do your thing
#       self[name] if self.has_key? key
#     end
#     self.send(name)
#     # return self.class.send :define_method, name do self[:v] end if self.has_key? name
#     # return self[key] if self.has_key? key
#     # super
#   end
#
#   def call_me
#     puts "method call_me is running"
#   end
#
#
# end
#
#



class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'
  include SimilarsHelper
  # require 'ostruct' # for metaprogramming  work!
  # require 'hash_methods.rb' # for metaprogramming  work!

  # All profiles in user's tree
  def index

    # profile_id_searched = 811
    # profile_id_found = 790
    # name_id_searched = 28
    # connected_users = [58]

    # @note: extra_search
    # New super speed extra search
    # Before:
    # 1.new table Person: user_id, profile_id, name_id, deleted, in_sims,
    #                     fathers (arr - int) = [23,124,345]
    #                     mothers (arr - int) = [23,124,345]
    #                     sisters (arr - int) = [23,124,345]
    #                     daughters (arr - int) = [23,124,345]
    #                     sons (arr - int) = [23,124,345]
    #                     wives (arr - int) = [23,124,345]
    #                     husbands (arr - int) = [23,124,345]
    #                     deds_father (arr - int) = [23,124,345]
    #                     deds_mother (arr - int) = [23,124,345]
    #                     babs_father (arr - int) = [23,124,345]
    #                     babs_mother (arr - int) = [23,124,345]
    #                     vnuks_father (arr - int) = [23,124,345]
    #                     vnuks_mother (arr - int) = [23,124,345]
    #                     vnuchkas_father (arr - int) = [23,124,345]
    #                     vnuchkas_mother (arr - int) = [23,124,345]
    #                     .... an so on
    # 2.create and update all joined records in Person - at the same time as usual
    #   so Person content is up_to_date as other main tables
    # 3.
    #
    # Searching.
    # for each profile from searching tree
    # 1.circle of searching profile
    # 2.using arrays match and exclusion logic in query -
    #   find found matched records of profiles - get profile_ids with user_ids
    # 3.determine, which profile_id have more records than coeff-t
    # 4.sequest profile_ids if necessary
    # 5.determine found profiles in each user_id
    # 6.eliminate doubled found profiles if there are
    # 7.make usual search_results for store/
    # /

    # Служебный метод для отладки - для LOGGER
    # todo: перенести этот метод в Operational - для нескольких моделей
    # Показывает массив в logger
    def show_in_logger(arr_to_log, string_to_add)
      row_no = 0  # DEBUGG_TO_LOGG
      arr_to_log.each do |row| # DEBUGG_TO_LOGG
        row_no += 1
        logger.info "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
      end  # DEBUGG_TO_LOGG
    end

    # @note: collect hash of keys and items array as hash value
    # from input array of arrays=pairs: [[key, item] .. [ , ]]
    def get_keys_with_items_array(key_item_pairs_arr)
      new_items_hash = {}
      key_item_pairs_arr.each do |one_array|
        SearchWork.fill_hash_w_val_arr(new_items_hash, one_array[0], one_array[1])
      end
      # logger.info "new_items_hash = #{new_items_hash}"
      new_items_hash
    end


    # @note: collect hash of two fields records: relations (key) and names array (value)
    # for searching profile
    # todo: place this method in ProfileKey model
    def rel_name_profile_records(profile_id)
      logger.info "In get_profile_records: profile_id = #{profile_id}"
      ProfileKey.where(:profile_id => profile_id, deleted: 0)
          .order('relation_id','is_name_id')
          .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
          .distinct
          .pluck(:relation_id, :is_name_id)
    end

    # @note: collect hash of relations (key) and names array (value)
    # todo: place this method in ProfileKey model
    def one_field_content(profile_id, field_name)
      logger.info "In one_field_content: field_name = #{field_name}"
      ProfileKey.where(:profile_id => profile_id, deleted: 0)
          .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
          .order('relation_id')
          .pluck(field_name)
          # .distinct
    end

    # @note: get checked profiles for exclusions
    def profiles_checking(profile_id_searched, trees_profiles)

      all_trees_found = trees_profiles.keys.flatten
      logger.info "all_trees_found = #{all_trees_found}"
      all_profiles_found = trees_profiles.values.flatten
      logger.info "all_profiles_found = #{all_profiles_found}"

      certain_profiles_trees = []
      certain_profiles_found = []
      certain_profiles_count = []

      certain_koeff = WeafamSetting.first.certain_koeff
      all_profiles_found.each_with_index do |found_profile_to_check, index|
        priznak, match_count = check_exclusions(profile_id_searched, found_profile_to_check)
        # logger.info "After check_exclusions: found_profile_to_check = #{found_profile_to_check}, priznak = #{priznak}, match_count = #{match_count}"
        profile_checked = check_exclusions_priznak(priznak, match_count, found_profile_to_check, certain_koeff)
        if profile_checked
          certain_profiles_count << match_count
          certain_profiles_found << profile_checked
          certain_profiles_trees << all_trees_found[index]
          logger.info "After check_exclusions & check_match_count?: profile_checked = #{profile_checked.inspect}, priznak = #{priznak}, match_count = #{match_count}"
        end
       end
      return certain_profiles_found, certain_profiles_count, certain_profiles_trees
    end

    # @note: main check of exclusions - special algorythm
    def check_exclusions(profile_id_searched, profile_id_found)
      puts "\n # check_exclusions # profile_id_searched = #{profile_id_searched}, profile_id_found To check = #{profile_id_found}\n"

      s_rel_name_arr = rel_name_profile_records(profile_id_searched)
      # s_rel_name_arr =
          [[8, 48], [3, 465], [3, 370], [15, 343], [16, 82], [17, 147], [121, 446]]
      # logger.info "search results: s_rel_name_arr = #{s_rel_name_arr} "

      f_rel_name_arr = rel_name_profile_records(profile_id_found)
      # f_rel_name_arr =
          [[1, 122], [2, 82], [91, 90], [3, 465], [121, 446], [3, 370], [8, 48], [101, 449], [92, 361], [102, 293], [17, 147]]
      # logger.info "found results: f_rel_name_arr = #{f_rel_name_arr}"

      excl_rel = [1,2,3,4,5,6,7,8,91,101,111,121,92,102,112,122]
      # excl_rel - relations to check - todo: place this array in Weafam_settings

      search_filling_hash = get_keys_with_items_array(s_rel_name_arr)
      logger.info "search_filling_hash = #{search_filling_hash}"
      found_filling_hash = get_keys_with_items_array(f_rel_name_arr)
      logger.info "found_filling_hash = #{found_filling_hash}"

      match_count = 0
      priznak = true
      search_filling_hash.each do |relation, names|
        # logger.info "In search_filling_hash: - relation = #{relation}, names = #{names}"
        sval = search_filling_hash[relation]
        fval = found_filling_hash[relation]
        if found_filling_hash.has_key?(relation)
          # logger.info "In found_filling_hash  has_key: - relation = #{relation}, fval = #{fval}, sval = #{sval}"
          if excl_rel.include?(relation)
            # logger.info "include main relations = #{relation}"
            if sval == fval
              match_count += sval.size
              priznak = true
              # logger.info "In IF check: (==) COMPLETE EQUAL - match_count = #{match_count}, check = #{(sval == fval) }"
            elsif sval & fval != []
              match_count += (sval & fval).size
              priznak = true
              # logger.info "In IF check: (&)ARE COMMON - match_count = #{match_count}, check = #{sval & fval != []}"
            else
              priznak = false
              # logger.info "In All checks failed: - priznak = #{priznak}, match_count = #{match_count}"
              return priznak, match_count
            end
          else
            # logger.info "Not include main relations = #{relation}"
            if sval == fval
              match_count += sval.size
              # logger.info "In IF check: (==) COMPLETE EQUAL - match_count = #{match_count}, check = #{(sval == fval) }"
            else sval & fval != []
            match_count += (sval & fval).size
            # logger.info "In IF check: (&)ARE COMMON - match_count = #{match_count}, check = #{sval & fval != []}"
            end
          end

        else
          priznak = true
          # logger.info "In IF check: ([]) EMPTY Arrs - match_count = #{match_count}, check = #{sval == [] || fval == []}"
        end

      end
      # logger.info "check_exclusions end: - priznak = #{priznak}, match_count = #{match_count}"

      return priznak, match_count
    end


    def check_match_count?(match_count, certain_koeff)
      if match_count >= certain_koeff
        # logger.info "PROFILES ARE EQUAL - with exclusions determine"
        true
      else
        # logger.info "PROFILES NOT EQUAL"
        false
      end
    end


    def check_exclusions_priznak(priznak, match_count, profile_id_found, certain_koeff)
      # logger.info "check_exclusions_priznak: - priznak = #{priznak}, match_count = #{match_count}"
      if priznak
        # logger.info "EXCLUSIONS PASSED"
        if check_match_count?(match_count, certain_koeff)
          profile_id_found
        else
          nil
        end
      else
        # logger.info "EXCLUSIONS DID NOT PASSED"
        nil
      end
    end


    # @note: create data for search_results generation
    # @input: profiles_found = [790, 818, 826], profiles_trees = [57, 59, 60]
    def create_results_data(certain_search_data)

      profile_id_searched = certain_search_data[:search]
      profiles_found      = certain_search_data[:founds]
      profiles_count      = certain_search_data[:counts]
      profiles_trees      = certain_search_data[:trees]
      # - certain_profiles_found =
      [790, 818, 826]
      # - certain_profiles_count =
      [5, 5, 5]
      # - certain_profiles_trees =
      [57, 59, 60]

      uniq_profiles_pairs = {}
      trees_profiles_found = {}
      profiles_counts = {}
      profiles_found.each_with_index do |one_profile, index|
        trees_profiles_found.merge!(profiles_trees[index] => one_profile )
        profiles_counts.merge!(one_profile => profiles_count[index] )
      end
      uniq_profiles_pairs.merge!(profile_id_searched => trees_profiles_found )
      {811=>{57=>790, 59=>818, 60=>826}}

      # uniq_profiles_pairs

      # uniq_profiles_pairs, profiles_with_match_hash = create_uniq_hash(profile_id_searched, profiles_found, profiles_trees)
      {811=>{57=>790, 59=>818, 60=>826}}

      # profiles_with_match_hash = create_profiles_counts(profiles_found, profiles_count)
      {790=>5, 818=>5, 826=>5}

      return uniq_profiles_pairs, profiles_counts
    end


    # [inf] Before SearchResults:
    # uniq_profiles_pairs =
    {805=>{59=>819, 60=>827, 57=>795},
     806=>{59=>823, 60=>831},
     811=>{57=>790, 59=>818, 60=>826},
     810=>{59=>820, 60=>825},
     809=>{57=>793, 59=>817, 60=>828},
     807=>{59=>824, 60=>832},
     896=>{57=>898}}

    # profiles_with_match_hash =
    {898=>5, 832=>5, 824=>5, 828=>5, 817=>5, 793=>5, 825=>5, 820=>5,
     826=>5, 818=>5, 790=>5, 831=>5, 823=>5, 795=>5, 827=>5, 819=>5}

     # [inf] search records: profiles_with_match_hash =
    {795=>5, 819=>5, 827=>5, 823=>5, 831=>5, 790=>5, 818=>5, 826=>5,
     820=>5, 825=>5, 793=>5, 817=>5, 828=>5, 824=>5, 832=>5, 898=>5}

    # search records: uniq_profiles_pairs =
               {805=>{57=>795, 59=>819, 60=>827},
                806=>{59=>823, 60=>831},
                811=>{57=>790, 59=>818, 60=>826},
                810=>{59=>820, 60=>825},
                809=>{57=>793, 59=>817, 60=>828},
                807=>{59=>824, 60=>832},
                896=>{57=>898}}

    # == END OF search_tree_profiles === Search_time = 756.15 msec

    # == END OF search_tree_profiles === Search_time = 679.99 msec
    # == END OF search_tree_profiles === Search_time = 667.55 msec


    # [inf] == END OF start_search === Search_time = 1.43 sec (pid:3770)
    # [inf] == END OF start_search === Search_time =  854.63 msec (pid:3770)

    # @note: New modified quick search
    # for each profile from searching tree
    # 1.circle of searching profile
    # 2.find found matched records - get user_ids
    # 3.determine, for which trees have more records than coeff-t
    # 4.sequest user_ids if necessary
    # 5.determine found profiles in each user_id
    # 6.eliminate doubled found profiles if there are
    # 7.collect final found profile_ids
    # 8.check exclusions for each found profile_ids
    # 9.get final found profile_ids with user_id position
    # 10.make usual search_results for store/
    def modi_search_one_profile(profile_id_searched)
      start_search_time = Time.now

      puts "\n ##### modi_search #####\n\n"


      s_rel_name_arr = rel_name_profile_records(profile_id_searched)
      [[8, 48], [3, 465], [3, 370], [15, 343], [16, 82], [17, 147], [121, 446]]
      logger.info "search records: profile_id_searched = #{profile_id_searched}, s_rel_name_arr = #{s_rel_name_arr} "

      profile = Profile.find(profile_id_searched)
      name_id_searched = profile.name_id
      tree_id = profile.tree_id
      connected_users = User.find(tree_id).connected_users

      arr_relations = one_field_content(profile_id_searched, 'relation_id')
      arr_names     = one_field_content(profile_id_searched, 'is_name_id')

      query_data = { connected_users: connected_users, name_id_searched: name_id_searched,
                     arr_relations: arr_relations, arr_names: arr_names }
      logger.info "query_data = #{query_data}"
      # [inf] query_data =
          {:connected_users=>[58], :name_id_searched=>28,
           :arr_relations=>[3, 3, 8, 15, 16, 17, 121],
           :arr_names=>   [465, 370, 48, 343, 82, 147, 446]}

      # found_trees = get_found_fields(query_data, 'user_id')
      # logger.info "found_trees = #{found_trees}"

      # collect_found_profiles
      # found_profiles = get_found_fields(query_data, 'profile_id')
      # logger.info "found_profiles = #{found_profiles}"

      trees_profiles = get_found_two_fields(query_data, 'user_id', 'profile_id')
      logger.info "trees_profiles = #{trees_profiles}"

      # no_doubles, with_doubles = exclude_double_profiles(arr_of_trees_profiles)
      # logger.info "trees no_doubles = #{no_doubles}, trees with_doubles = #{with_doubles}"


      certain_profiles_found, certain_profiles_count, certain_profiles_trees = profiles_checking(profile_id_searched, trees_profiles)
      logger.info "After profile_checking: profile_id_searched = #{profile_id_searched}"
      logger.info " - certain_profiles_found = #{certain_profiles_found}"
      logger.info " - certain_profiles_count = #{certain_profiles_count}"
      logger.info " - certain_profiles_trees = #{certain_profiles_trees}"

      certain_search_data = {
          search: profile_id_searched,
          founds: certain_profiles_found,
          counts: certain_profiles_count,
          trees: certain_profiles_trees }

      profiles_trees_pairs, profiles_counts = create_results_data(certain_search_data)

      # :by_profiles=>
          [{:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>8}, {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>8}, {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>8}, {:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7}, {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
                     {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7}, {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7}, {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7}, {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7}, {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>6}, {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>6}, {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5}, {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5}, {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5}, {:search_profile_id=>734, :found_tree_id=>47, :found_profile_id=>721, :count=>5}]
          # :by_trees=>
          [{:found_tree_id=>47, :found_profile_ids=>[669, 666, 672, 721, 668, 671, 667, 670, 673]}]
      # , :duplicates_one_to_many=>
          {734=>{45=>{648=>5, 733=>5}}}

      end_search_time = Time.now
      search_time = (end_search_time - start_search_time) * 1000
      puts "\n == END OF modi_search === Search_time = #{search_time.round(2)} msec  \n\n"
      return profiles_trees_pairs, profiles_counts

    end


    # @note: Determine: in which trees ids profiles were found
    def get_found_two_fields(query_data, field_one, field_two)
      fields_arr_values = both_fields_records(query_data, field_one, field_two)
      logger.info "fields_arr_values = #{fields_arr_values}"
      # fields_arr_values = [[57, 790], [57, 790], [57, 790], [57, 790], [57, 7960], [59, 818], [59, 818], [59, 818], [59, 818], [59, 818], [60, 826], [60, 826], [60, 826], [60, 826], [60, 826]]

      get_keys_with_items_array(fields_arr_values)
      # values_occurence = occurence_counts(field_values)
      # logger.info "values_occurence = #{values_occurence}"
      #
      # exclude_uncertain_trees(values_occurence)
    end

    # @note: Determine: in which trees ids profiles were found
    def get_found_fields(query_data, field)
      field_values = found_records(query_data, field)
      logger.info "field_values = #{field_values}"

      values_occurence = occurence_counts(field_values)
      logger.info "values_occurence = #{values_occurence}"

      exclude_uncertain_trees(values_occurence)
    end

    # @note: Find by fields - [relation, is_name_id]
    # for each row in ProfileKey
    # get array of arrays: [[key, item] .. [ , ]]
    def both_fields_records(query_data, field_one, field_two)
      connected_users = query_data[:connected_users]
      name_id_searched = query_data[:name_id_searched]
      arr_relations = query_data[:arr_relations]
      arr_names = query_data[:arr_names]

      # arr_relations = [8,3,3,15,16,17,121]
      # arr_names = [48,465,370,343,82,147,446]

      ProfileKey.where.not(user_id: connected_users)
          .where(:name_id => name_id_searched)
          .where(deleted: 0)
          .where("relation_id in (?)", arr_relations)
          .where("is_name_id in (?)", arr_names)
          .order('user_id','relation_id','is_name_id')
          .select('id','user_id','profile_id','name_id','relation_id','is_name_id','is_profile_id')
          .pluck(field_one, field_two)
    end

  # @note: Find by new field - [relation, is_name_id]
  # for each row in ProfileKey
  def found_records(query_data, field_array)
    connected_users = query_data[:connected_users]
    name_id_searched = query_data[:name_id_searched]
    arr_relations = query_data[:arr_relations]
    arr_names = query_data[:arr_names]

    # arr_relations = [8,3,3,15,16,17,121]
    # arr_names = [48,465,370,343,82,147,446]

    ProfileKey.where.not(user_id: connected_users)
              .where(:name_id => name_id_searched)
              .where(deleted: 0)
              .where("relation_id in (?)", arr_relations)
              .where("is_name_id in (?)", arr_names)
              .order('user_id','relation_id','is_name_id')
              .select('id','user_id','profile_id','name_id','relation_id','is_name_id','is_profile_id')
        .pluck(field_array)

  end

    # @note: How many array element ocure
    def occurence_counts(user_ids)
      user_ids.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
    end


    # @note: Exclude tree_id (user_id) if found records < certain_koeff
    def exclude_uncertain_trees(user_id_occurence)
      # user_id_occurence = {57=>5, 59=>5, 60=>4} #test
      koeff = get_certain_koeff
      user_id_occurence.delete_if { |user_id, occure| occure < koeff }
      user_id_occurence.keys
    end

    # @note: New super extra search
    # for each profile in tree
    def collect_found_profiles(profile_id_searched)

    end

    # @note: New super extra search body
    def search_tree_profiles
      profile_id_searched = 811
      # profile_id_found = 790

      start_search_time = Time.now

      puts "\n ##### search_tree_profiles #####\n\n"

      connected_author_arr = current_user.get_connected_users # Состав объединенного дерева в виде массива id
      author_tree_arr = Tree.get_connected_tree(connected_author_arr) # DISTINCT Массив объединенного дерева из Tree
      tree_profiles = [current_user.profile_id] + author_tree_arr.map {|p| p.is_profile_id }.uniq
      tree_profiles = tree_profiles.uniq
      logger.info "search records: connected_author_arr = #{connected_author_arr}, tree_profiles = #{tree_profiles} "

      uniq_profiles_pairs = {}
      profiles_with_match_hash = {}

      tree_profiles.each do |profile_id_searched|
        profiles_trees_pairs, profiles_counts = modi_search_one_profile(profile_id_searched)
        logger.info "after modi_search_one_profile: profiles_trees_pairs = #{profiles_trees_pairs}, profiles_counts = #{profiles_counts} "
        uniq_profiles_pairs.merge!(profiles_trees_pairs)
        profiles_with_match_hash.merge!(profiles_counts)
      end

      uniq_profiles_pairs.delete_if { |key,val|  val == {} }

      logger.info "search records: uniq_profiles_pairs = #{uniq_profiles_pairs}"
      logger.info "search records: profiles_with_match_hash = #{profiles_with_match_hash}"


      # profiles_search_found.merge!(profile_id_searched => certain_profiles_found )
      # logger.info "profiles_search_found = #{profiles_search_found}"

      # SearchResults.store_search_results(results, current_user.id) # запись рез-тов поиска в таблицу - для Метеора

      # current_user.start_check_double(results, certain_koeff) if current_user.double == 0

      end_search_time = Time.now
      search_time = (end_search_time - start_search_time) * 1000
      puts "\n == END OF search_tree_profiles === Search_time = #{search_time.round(2)} msec  \n\n"

    end


    search_tree_profiles

    # arr_rel = [8,3,3,15,16,17,121]
    # arr_nam = [48,465,370,343,82,147,446]

    # match_rows_rel_name = ProfileKey
    #                           .where.not(user_id: connected_users)
    #                           .where(:name_id => name_id_searched)
    #                           .where(deleted: 0)
    #                           .where("relation_id + is_name_id in (?)", rel_name_arr)
    #                           .order('user_id','relation_id','is_name_id')
    #                           .select('id','user_id','profile_id','name_id','relation_id','is_name_id','is_profile_id')
    # .where("relation_id in (?)", arr_rel)
    # .where("is_name_id in (?)", arr_nam)
    # .where("'---- ' || relation_id || '- ' || is_name_id in (?)", rel_name_arr)

    # logger.info "search results: match_rows_rel_name = #{match_rows_rel_name.inspect}, match_rows_rel_name.size = #{match_rows_rel_name.size}"
    # show_in_logger(match_rows_rel_name, "=== результат" )  # DEBUGG_TO_LOGG


    # ('---- 8- 48','---- 3- 465','---- 3- 370','---- 15- 343','---- 16- 82','---- 17- 147','---- 121- 446')




    # excl_rel = [1,2,3,4,5,6,7,8,91,101,111,121,92,102,112,122]
    # excl_match_rows_rel_name = ProfileKey
    #                           .where.not(user_id: connected_users)
    #                           .where(:name_id => name_id_searched)
    #                           .where("relation_id in (?)", arr_rel)
    #                           .where("relation_id in (?)", excl_rel)
    #                           .where("is_name_id in (?)", arr_nam)
    #                           .where(deleted: 0)
    #                           .order('user_id','relation_id','is_name_id')
    #
    # logger.info "search results: excl_match_rows_rel_name = #{excl_match_rows_rel_name}"
    # show_in_logger(excl_match_rows_rel_name, "=== результат2" )  # DEBUGG_TO_LOGG


    [[8, 48, 805], [3, 465, 810], [3, 370, 809], [15, 343, 806], [16, 82, 807], [17, 147, 895], [121, 446, 896]]

    #   unnest_rows = ProfileKey.where(:profile_id => profile_id_searched, deleted: 0)
    #                       .unnest(rel_name_prof_arr)
    #                      # .pluck(:relation_id, :is_name_id, :is_profile_id)
    # logger.info "search results: unnest_rows = #{unnest_rows}"
    #                      .distinct




    # @note: Check and delete_if: if one_hash contains {found_tree_id: tree_id_with_double} - tree w/doubles results
  #   If No -> leave this one_hash in by_trees_arr of hashes
  # @params: by_trees_arr - from search results
  #   arr_to_exclude - arr of tree ids where doubles were found
  # def exclude_doubles_results(by_trees_arr, arr_to_exclude)
  #   arr_to_exclude.each do |tree_id_with_double|
  #     by_trees_arr.delete_if { |one_hash| one_hash.merge({found_tree_id: tree_id_with_double }) == one_hash }
  #   end
  #   by_trees_arr
  # end




    # SELECT "profile_keys".* FROM "profile_keys"  WHERE ("profile_keys"."user_id" NOT IN (58)) AND "profile_keys"."name_id" = 28 AND (relation_id in (8,3,3,15,16,17,121)) AND (is_name_id in (48,465,370,343,82,147,446)) AND "profile_keys"."deleted" = 0  ORDER BY user_id, relation_id, is_name_id (pid:26935)
  {"id"=>5611, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_name_id"=>370, "is_profile_id"=>793}
  {"id"=>5617, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_name_id"=>465, "is_profile_id"=>794}
  {"id"=>5625, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>8, "is_name_id"=>48, "is_profile_id"=>795}
  {"id"=>6387, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>17, "is_name_id"=>147, "is_profile_id"=>897}
  {"id"=>6395, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>121, "is_name_id"=>446, "is_profile_id"=>898}
  {"id"=>5776, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_name_id"=>370, "is_profile_id"=>817}
  {"id"=>5783, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_name_id"=>465, "is_profile_id"=>820}
  {"id"=>5779, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>8, "is_name_id"=>48, "is_profile_id"=>819}
  {"id"=>5811, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>15, "is_name_id"=>343, "is_profile_id"=>823}
  {"id"=>5821, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>16, "is_name_id"=>82, "is_profile_id"=>824}
  {"id"=>5831, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_name_id"=>370, "is_profile_id"=>828}
  {"id"=>5824, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_name_id"=>465, "is_profile_id"=>825}
  {"id"=>5827, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>8, "is_name_id"=>48, "is_profile_id"=>827}
  {"id"=>5859, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>15, "is_name_id"=>343, "is_profile_id"=>831}
  {"id"=>5869, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>16, "is_name_id"=>82, "is_profile_id"=>832}


  {"id"=>5611, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>793, "is_name_id"=>370}
  {"id"=>5617, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>794, "is_name_id"=>465}
  {"id"=>5625, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>8, "is_profile_id"=>795, "is_name_id"=>48}
  {"id"=>6395, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>121, "is_profile_id"=>898, "is_name_id"=>446}
  {"id"=>5776, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>817, "is_name_id"=>370}
  {"id"=>5783, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>820, "is_name_id"=>465}
  {"id"=>5779, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>8, "is_profile_id"=>819, "is_name_id"=>48}
  {"id"=>5831, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>828, "is_name_id"=>370}
  {"id"=>5824, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>825, "is_name_id"=>465}
  {"id"=>5827, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>8, "is_profile_id"=>827, "is_name_id"=>48}




      # TEST
  # duplicates_one_to_many = {711=>{45=>{648=>5, 710=>5}}, 712=>{49=>{648=>5, 710=>5}}, 713=>{45=>{648=>5, 710=>5}} }
  # duplicates_one_to_many = {}
  # duplicates_many_to_one = {648=>{46=>711}, 710=>{46=>711}, 649=>{45=>711}, 711=>{45=>711}}
  # duplicates_many_to_one = {}

  # def collect_one_doubles_ids(one_type_doubles)
  #   tree_ids_with_doubles = []
  #   one_type_doubles.each_value do |val|
  #     val.each_key do |key|
  #       tree_ids_with_doubles << key
  #     end
  #   end
  #   tree_ids_with_doubles.uniq
  # end


  # def collect_doubles_tree_ids(results)
  #   tree_ids_one_to_many = []
  #   tree_ids_many_to_one = []
  #   tree_ids_one_to_many = collect_one_doubles_ids(results[:duplicates_one_to_many]) unless results[:duplicates_one_to_many].empty?
  #   tree_ids_many_to_one = collect_one_doubles_ids(results[:duplicates_many_to_one]) unless results[:duplicates_many_to_one].empty?
  #   tree_ids_one_to_many + tree_ids_many_to_one
  # end
  #
  # tree_ids_to_exclude = collect_doubles_tree_ids(results)
 #  tree_ids_one_to_many = collect_one_doubles_ids(duplicates_one_to_many) unless duplicates_one_to_many.empty?
 #  tree_ids_many_to_one = collect_one_doubles_ids(duplicates_many_to_one) unless duplicates_many_to_one.empty?
 #  logger.info "# In home/index: collect_doubles_tree_ids :
 # tree_ids_one_to_many = #{tree_ids_one_to_many}, tree_ids_many_to_one = #{tree_ids_many_to_one} "
 #  (tree_ids_one_to_many + tree_ids_many_to_one).uniq
 #  logger.info "# In home/index: collect_doubles_tree_ids : +++ = #{(tree_ids_one_to_many + tree_ids_many_to_one).uniq} "


    # TEST
    # by_trees_arr =
    # [{:found_tree_id=>34, :found_profile_ids=>[542, 541, 543, 544, 539, 540]},
    #  {:found_tree_id=>45, :found_profile_ids=>[649, 650, 645, 646, 651, 647]},
    #  {:found_tree_id=>47, :found_profile_ids=>[669, 671, 666, 668, 672, 667, 670, 673]}]
    #
    # arr_to_exclude =  [45, 47, 34]
    #
    # no_doubles_by_trees_arr = exclude_doubles_results(by_trees_arr, arr_to_exclude)
    # logger.info "########## In home/index: after exclude_doubles_results: no_doubles_by_trees_arr = #{no_doubles_by_trees_arr}"


    # TEST
    # work!
    # os = OpenStruct.new @attributes
    # @rez = os.key1 #


    # TEST
    # does work: Metaprogramming - need require and make Hash from SHash in /lib/hash_methods.rb
    # @attributes = {key1: "Doe", wideName: {first_name: "Mike", sec_name: "Bill"}, givenName: "John"}
    # puts "1. @attributes = #{@attributes}, #{@attributes.class} "
    # puts @attributes.call_me
    # name = "call_me_more"
    # puts " name = #{name} "
    # @attributes.class.send :define_method, name do
    #   puts "2. define_method '#{name}' "
    # end
    # puts "3. respond = #{@attributes.respond_to?(name)} \n\n"
    # s = @attributes.givenName
    # puts "4. s = #{s},  @attributes.key1 = #{@attributes.key1} "
    # nns = @attributes.wideName.sec_name
    # puts "5. s = #{nns},  @attributes.key1 = #{@attributes.wideName.sec_name} "


    # tree_content_data = Tree.tree_amounts(current_user)
    #
    # logger.info "In home/index: Tree info:  profiles_qty= #{tree_content_data[:profiles_qty]},
    #               tree_is_profiles= #{tree_content_data[:tree_is_profiles]},
    #               profiles_male_qty= #{tree_content_data[:profiles_male_qty]},
    #               tree_male_profiles= #{tree_content_data[:tree_male_profiles]},
    #               profiles_female_qty= #{tree_content_data[:profiles_female_qty]},
    #               tree_female_profiles= #{tree_content_data[:tree_female_profiles]},
    #               user_males= #{tree_content_data[:user_males]},
    #               user_females= #{tree_content_data[:user_females]},
    #               user_males_qty= #{tree_content_data[:user_males_qty]},
    #               user_females_qty= #{tree_content_data[:user_females_qty]} "


    # TEST
    # if Profile.check_profiles_exists?(417, 420)
    #   logger.info "########## In home/index: check_profiles_exists: - YES"
    #   # row_to_update.update_attributes(:"#{log_row[:field]}" => log_row[:overwritten],
    #   #                                 :updated_at => Time.now) unless row_to_update.blank?
    # else
    #   logger.info "########## In home/index: check_profiles_exists: - NO"
    # end

    # TEST
    # if WeafamStat.exists?
    #   logger.info "TEST WeafamStat: last.exists"
    #   # if (Time.current - 1.day) > WeafamStat.last.created_at
    #   #   logger.info "TEST WeafamStat: Time.current - 1.day"
    #     WeafamStat.create_stats_row
    #   # else
    #   #   logger.info "TEST WeafamStat: DO NOT 1.day) > "
    #   # end
    # else
    #   logger.info "TEST WeafamStat: DO NOT last.exists"
    # end

    # if Counter.exists?
    #   logger.info "TEST Counter: exists"
    #    #   logger.info "TEST Counter: increment_invites = #{Counter.first.invites}, increment_disconnects = #{Counter.first.disconnects}"
    #   Counter.increment_invites
    #    #   Counter.increment_disconnects
    #    #   logger.info "Counter AFTER: increment_invites = #{Counter.first.invites}, increment_disconnects = #{Counter.first.disconnects}"
    #    # else
    #   logger.info "TEST Counter: DO NOT exists"
    # end

    # TEST
    # profiles_to_rewrite = [122,233,455,677,899]
    # profiles_to_destroy = [122,234,455,677,899]
    #
    # def clean_profiles_arrs(profiles_to_rewrite, profiles_to_destroy)
    #   clean_to_rewrite = []
    #   clean_to_destroy = []
    #   profiles_to_rewrite.each_with_index do |profile_id, index|
    #     if profile_id != profiles_to_destroy[index]
    #       clean_to_rewrite << profile_id
    #       clean_to_destroy << profiles_to_destroy[index]
    #     end
    #   end
    #   return clean_to_rewrite, clean_to_destroy
    # end
    #
    # clean_to_rewrite, clean_to_destroy = clean_profiles_arrs(profiles_to_rewrite, profiles_to_destroy)
    # logger.info "TEST clean_profiles_arrs: clean_to_rewrite = #{clean_to_rewrite} , clean_to_destroy = #{clean_to_destroy} "

    # TEST
    #     name_of_table = Profile.table_name
    #     model = name_of_table.classify.constantize
    #     logger.info "*** In module SimilarsProfileMerge make_user_profile_link: name_of_table = #{name_of_table.inspect}, model = #{model.inspect} "

    # TEST
    # profile_id = 455
    # is_profile_id = 468
    #
    # res = Profile.check_profiles_exists?(profile_id, is_profile_id)
    # logger.info "*** In module Profile.check_profiles_exists: res = #{res.inspect} "
    @similars = []
    logger.info "## current_user = #{current_user.id} ## In home/index: Before similars_results_exists?"

    if SimilarsFound.similars_results_exists?(current_user.id)
      @similars = [""]
    end
   # results = SearchResults.start_search_methods(current_user)
   # logger.info "########## In home/index: results = #{results} "

   # if results.has_key?(:similars)
   #   @similars = results[:similars]
   #   logger.info "########## In home/index: @similars = #{@similars} "
   #   @log_connection_id = results[:log_connection_id]
   #   @tree_info = results[:tree_info]
   #
   #  # similars_data = current_user.start_similars
   #  # @tree_info = similars_data[:tree_info]
   #  # # new_sims = similars_data[:new_sims]
   #  # @similars = similars_data[:similars]
   #  # logger.info "########## In home/index: @similars = #{@similars} "
   #  # @log_connection_id = similars_data[:log_connection_id]
   #
   #
   #        # todo: проверить: убрать запуск метода SimilarsLog.current_tree_log_id и взять @log_connection_id из sim_data
   #    # для отображения в show_similars_data
   #    # @log_connection_id = SimilarsLog.current_tree_log_id(@tree_info[:connected_users]) unless @tree_info.empty?
   #
   #    unless @similars.empty?  # т.е. есть похожие
   #      flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
   #    #   unless new_sims==""#.empty?  #  т.е. есть новые похожие - отлич. от ранее записанных
   #    #     # @tree_info = tree_info  # To View
   #    #     view_tree_similars(@tree_info, @similars) unless @tree_info.empty?
   #    #     render :template => 'similars/show_similars_data' # показываем инфу о похожих
   #    #   end
   #    end
   #
   # end



  end


  def show
  end

  def show_similars

    similars_data = current_user.start_similars
    @tree_info = similars_data[:tree_info]
    new_sims = similars_data[:new_sims]
    @similars = similars_data[:similars]
    # @log_connection_id = similars_data[:log_connection_id]

    unless @similars.empty?  # т.е. есть похожие
      flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
      unless new_sims==""   #.empty?  #  т.е. есть новые похожие - отлич. от ранее записанных
        view_tree_similars(@tree_info, @similars) unless @tree_info.empty?
        # render :template => 'similars/show_similars_data' # показываем инфу о похожих
        render 'similars/show_similars_data' # показываем инфу о похожих
      end
    end

  end


  def search
  end



end

# {"circles" => [
#     {"id" =>90,"name" =>"Денис","display_name" =>"Денис ","relation" =>"Центр круга","relation_id" =>0,"is_relation" =>null,
# "is_relation_id" =>null,"distance" =>0,"current_user_profile" =>true,"icon" =>"/assets/man.svg",
# "avatar" =>"/system/profile_data/avatars/000/000/009/round_thumb/20120607_223247.jpg?1419834070",
# "has_rights" =>true,"user_id" =>4},
#     {"id" =>440,"name" =>"Борис","display_name" =>"Борис ","sex_id" =>1,"relation" =>"Отец","relation_id" =>1,
# "is_relation" =>"сын","is_relation_id" =>3,"target" =>90,"distance" =>1,"current_user_profile" =>false,"icon" =>"/assets/man.svg",
# "avatar" =>"/system/profile_data/avatars/000/000/019/round_thumb/%D0%9F%D0%B0%D0%BF%D0%B0.jpg?1420045035","user_id" =>false},
#     {"id" =>46,"name" =>"Сузанна","display_name" =>"Сузанна ","sex_id" =>0,"relation" =>"Мать","relation_id" =>2,
# "is_relation" =>"сын","is_relation_id" =>3,"target" =>90,"distance" =>1,"current_user_profile" =>false,
# "icon" =>"/assets/woman.svg","avatar" =>"/system/profile_data/avatars/000/000/016/round_thumb/%D0%9C%D0%B0%D0%BC%D0%B0.jpg?1419886395",
# "user_id" =>false},
#     {"id" =>42,"name" =>"Екатерина","display_name" =>"Екатерина ","sex_id" =>0,"relation" =>"Дочь","relation_id" =>4,
# "is_relation" =>"отец","is_relation_id" =>1,"target" =>90,"distance" =>1,"current_user_profile" =>false,
# "icon" =>"/assets/woman.svg",
# "avatar" =>"/system/profile_data/avatars/000/000/014/round_thumb/%D0%95%D0%BA%D0%B0%D1%82%D0%B5%D1%80%D0%B8%D0%BD%D0%B0_%D0%9B%D0%BE%D0%B1%D0%BA%D0%BE%D0%B2%D0%B0.jpg?1419842293","user_id" =>22}
# ] }

 # In similars_init_search 1: # Исходное состояние - до объединения похожих
# In similars_init_search 1:
  #  tree_circles =
  #       {81=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370]},
  #        70=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370], "Свекор"=>[90], "Свекровь"=>[345]},
  #        63=>{"Отец"=>[90], "Мама"=>[345], "Брат"=>[370], "Жена"=>[173], "Тесть"=>[351], "Дед-о"=>[343], "Бабка-о"=>[293]},
  #        83=>{"Дочь"=>[173, 354], "Муж"=>[351], "Зять"=>[370]},
  #        64=>{"Отец"=>[343], "Мама"=>[293], "Сын"=>[40, 370], "Жена"=>[345], "Невестка"=>[173, 354]},
  #        79=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[370]},
  #        66=>{"Отец"=>[90], "Мама"=>[345], "Брат"=>[40], "Жена"=>[354], "Тесть"=>[351], "Дед-о"=>[343], "Бабка-о"=>[293]},
  #        68=>{"Сын"=>[90], "Жена"=>[293], "Невестка"=>[345], "Внук-о"=>[40, 370]},
  #        78=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[354]},
  #        65=>{"Сын"=>[40, 370], "Муж"=>[90], "Свекор"=>[343], "Свекровь"=>[293], "Невестка"=>[173, 354]},
  #        80=>{"Дочь"=>[173, 354], "Муж"=>[351]},
  #        69=>{"Сын"=>[90], "Муж"=>[343], "Невестка"=>[345], "Внук-о"=>[40, 370]},
  #        82=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[40, 370]},
  #        67=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[354], "Муж"=>[40], "Свекор"=>[90], "Свекровь"=>[345]},
  #        84=>{"Жена"=>[354], "Тесть"=>[351], "Теща"=>[187]}}


# In similars_connect_tree :
#     tree_info[:tree_is_profiles] =
#         [81, 70, 63, 83, 64, 79, 66, 68, 78, 65, 80, 69, 82, 67, 84]
        # @tree_info[:connected_users] =
        #     [7, 8]

 # final_connection_hash = {81=>70, 82=>79, 83=>80, 67=>78, 84=>66}

# In similars_init_search 11111: connected
#     tree_circles =
#     {65=>{"Сын"=>[40, 370], "Муж"=>[90], "Свекор"=>[343], "Свекровь"=>[293], "Невестка"=>[173, 354]},
#      81=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370], "Свекор"=>[90], "Свекровь"=>[345]},
#      67=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[354], "Муж"=>[40], "Свекор"=>[90], "Свекровь"=>[345]},
#      83=>{"Дочь"=>[173, 354], "Муж"=>[351], "Зять"=>[370]},
#      82=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[40, 370]},
#      63=>{"Отец"=>[90], "Мама"=>[345], "Брат"=>[370], "Жена"=>[173], "Тесть"=>[351], "Дед-о"=>[343], "Бабка-о"=>[293]},
#      84=>{"Отец"=>[90], "Мама"=>[345], "Брат"=>[40], "Жена"=>[354], "Тесть"=>[351], "Теща"=>[187], "Дед-о"=>[343], "Бабка-о"=>[293]},
#      68=>{"Сын"=>[90], "Жена"=>[293], "Невестка"=>[345], "Внук-о"=>[40, 370]},
#      69=>{"Сын"=>[90], "Муж"=>[343], "Невестка"=>[345], "Внук-о"=>[40, 370]},
#      64=>{"Отец"=>[343], "Мама"=>[293], "Сын"=>[40, 370], "Жена"=>[345], "Невестка"=>[173, 354]}}


  # profiles_arr =   connected
  #   [65, 81, 67, 83, 82, 63, 84, 68, 69, 64]