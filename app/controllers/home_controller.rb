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



    profile_id_searched = 811
    profile_id_found = 790
    found_profile_id = 790
    certain_koeff = 5
    name_id_searched = 28
    connected_users = [58]

    def check_exclusions(certain_koeff, profile_id_searched, profile_id_found, name_id_searched, connected_users)

      s_rel_name_arr = ProfileKey.where(:profile_id => profile_id_searched, deleted: 0)
                                  .pluck(:relation_id, :is_name_id)
      [[8, 48], [3, 465], [3, 370], [15, 343], [16, 82], [17, 147], [121, 446]]
      # s_rel_name_hash = Hash[*s_rel_name_arr.flatten(1)]
      #  {8=>48, 3=>370, 15=>343, 16=>82, 17=>147, 121=>446}
      logger.info "search results: s_rel_name_arr = #{s_rel_name_arr} "

      f_rel_name_arr = ProfileKey.where(:profile_id => profile_id_found, deleted: 0)
                           .pluck(:relation_id, :is_name_id)
      [[1, 122], [2, 82], [91, 90], [3, 465], [121, 446], [3, 370], [8, 48], [101, 449], [92, 361], [102, 293], [17, 147]]
      # f_rel_name_hash = Hash[*f_rel_name_arr.flatten(1)]
      # {1=>122, 2=>82, 91=>90, 3=>370, 121=>446, 8=>48, 101=>449, 92=>361, 102=>293, 17=>147}
      logger.info "found results: f_rel_name_arr = #{f_rel_name_arr}"
      # ", f_rel_name_hash = #{f_rel_name_hash}" #", is_name_arr = #{is_name_arr}"

      # count_arrs = s_rel_name_arr & f_rel_name_arr
      # logger.info "found results: count_arrs = #{count_arrs}"
      #
      # if count_arrs.size >= 5
      #   logger.info "PROFILES CAN BE EQUAL - to determine exclusions"
      # else
      #   logger.info "PROFILES NOT EQUAL"
      # end
      s_filling_hash = {}
      s_rel_name_arr.each do |one_array|
        SearchWork.fill_hash_w_val_arr(s_filling_hash, one_array[0], one_array[1])
      end
      logger.info "S s_filling_hash = #{s_filling_hash}"
      s_filling_hash = {8=>[48], 3=>[465, 370], 15=>[343], 16=>[82], 17=>[147,33], 121=>[4465], 4=>[33]}

      f_filling_hash = {}
      f_rel_name_arr.each do |one_array|
        SearchWork.fill_hash_w_val_arr(f_filling_hash, one_array[0], one_array[1])
      end
      logger.info "F f_filling_hash = #{f_filling_hash}"
      {1=>[122], 2=>[82], 91=>[90], 3=>[465, 370], 121=>[446], 8=>[48], 101=>[449], 92=>[361], 102=>[293], 17=>[147]}

      match_count = 0
      priznak = "Ok"
      s_filling_hash.each do |relation, names|
        logger.info "In s_filling_hash: - relation = #{relation}, names = #{names}"
        sval = s_filling_hash[relation]

        if f_filling_hash.has_key?(relation)
          fval = f_filling_hash[relation]
          logger.info "In f_filling_hash  has_key: - relation = #{relation}, fval = #{fval}, sval = #{sval}"

          if sval == fval
            match_count += sval.size
            priznak = "Ok"
            logger.info "In IF check: (==) COMPLETE EQUAL - match_count = #{match_count}, check = #{(sval == fval) }"
          elsif sval & fval != []
              match_count += (sval & fval).size
              priznak = "Ok"
              logger.info "In IF check: (&)ARE COMMON - match_count = #{match_count}, check = #{sval & fval != []}"
          # elsif sval == [] || fval == []
          #       match_count += 1
          #       priznak = "Ok"
          #       logger.info "In IF check: EMPTY Arrs - match_count = #{match_count}, check = #{sval == [] || fval == []}"
          else
                logger.info "In IF check: All checks failed"
                priznak = "NotOk"
                return priznak, match_count
          end
        else
          # match_count += 1
          priznak = "Ok"
          logger.info "In IF check: ([]) EMPTY Arrs - match_count = #{match_count}, check = #{sval == [] || fval == []}"
        end

      end

      return priznak, match_count
    end


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

    def check_match_count(match_count)
      if match_count >= 5
        logger.info "PROFILES ARE EQUAL - with exclusions determine"
      else
        logger.info "PROFILES NOT EQUAL"
      end
    end

    def check_exclusions_priznak(priznak, match_count)
      if priznak == "NotOk"
        logger.info "EXCLUSIONS DID NOT PASSED"
      else
        logger.info "EXCLUSIONS PASSED"
        check_match_count(match_count)
      end
    end




    priznak, match_count = check_exclusions(certain_koeff, profile_id_searched, profile_id_found, name_id_searched, connected_users)
    check_exclusions_priznak(priznak, match_count)




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