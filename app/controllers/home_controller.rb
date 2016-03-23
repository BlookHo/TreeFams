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

    logger.info "relations = #{EXCLUSION_RELATIONS.inspect}"
    logger.info "certain_koeff = #{CERTAIN_KOEFF}"
    logger.info "certain_connect = #{CERTAIN_CONNECT}"

 #   WeafamMailer.weekly_manifest_email.deliver_now

    # current_user.modified_search # now = srat_search

    # 64 - 65 - cert.4
    # 4749;64;65;875;890;4;"2015-12-21 12:59:18.674866";"2015-12-21 12:59:18.674866";"{890,892}";"{875,877}";"{4,4}";;0;"{64}";"{65}"
    # 4750;65;64;890;875;4;"2015-12-21 12:59:18.717364";"2015-12-21 12:59:18.717364";"{875,877}";"{890,892}";"{4,4}";;0;"{65}";"{64}"



    # == END OF search_tree_profiles === Search_time = 751.69 msec
    # == END OF search_tree_profiles === Search_time = 575.05 msec
    # == END OF modified_search === Search_time = 1313.72 msec
    # == END OF modified_search === Search_time = 628.13 msec
    # == END OF modified_search === Search_time = 864.09 msec



    # [inf] == END OF start_search === Search_time =  881.45 msec (pid:4469)
    # [inf] == END OF start_search === Search_time =  901.56 msec (pid:4469)
    # [inf] == END OF start_search === Search_time =  990.24 msec (pid:4469)
    # [inf] == END OF start_search === Search_time =  651.77 msec (pid:4469)

    # prev SR
    # 4713;58;59;807;824;5;"2015-12-19 20:28:50.070532";"2015-12-19 20:28:50.070532";"{824,817,820,818,823,819}";"{807,809,810,811,806,805}";"{5,5,5,5,5,5}";;0;"{58}";"{59}"
    # 4714;59;58;824;807;5;"2015-12-19 20:28:50.116034";"2015-12-19 20:28:50.116034";"{807,809,810,811,806,805}";"{824,817,820,818,823,819}";"{5,5,5,5,5,5}";;0;"{59}";"{58}"
    # 4715;58;60;807;832;5;"2015-12-19 20:28:50.159177";"2015-12-19 20:28:50.159177";"{832,828,825,826,831,827}";"{807,809,810,811,806,805}";"{5,5,5,5,5,5}";;0;"{58}";"{60}"
    # 4716;60;58;832;807;5;"2015-12-19 20:28:50.180996";"2015-12-19 20:28:50.180996";"{807,809,810,811,806,805}";"{832,828,825,826,831,827}";"{5,5,5,5,5,5}";;0;"{60}";"{58}"
    # 4717;58;57;896;898;5;"2015-12-19 20:28:50.211476";"2015-12-19 20:28:50.211476";"{898,793,790,795}";"{896,809,811,805}";"{5,5,5,5}";;0;"{58}";"{57}"
    # 4718;57;58;898;896;5;"2015-12-19 20:28:50.239857";"2015-12-19 20:28:50.239857";"{896,809,811,805}";"{898,793,790,795}";"{5,5,5,5}";;0;"{57}";"{58}"

    # modif SR
    # 4731;58;57;896;898;5;"2015-12-21 12:17:51.028559";"2015-12-21 12:17:51.028559";"{898,793,790,795}";"{896,809,811,805}";"{5,5,5,5}";;0;"{58}";"{57}"
    # 4732;57;58;898;896;5;"2015-12-21 12:17:51.047659";"2015-12-21 12:17:51.047659";"{896,809,811,805}";"{898,793,790,795}";"{5,5,5,5}";;0;"{57}";"{58}"
    # 4733;58;59;807;824;5;"2015-12-21 12:17:51.068109";"2015-12-21 12:17:51.068109";"{824,817,820,818,823,819}";"{807,809,810,811,806,805}";"{5,5,5,5,5,5}";;0;"{58}";"{59}"
    # 4734;59;58;824;807;5;"2015-12-21 12:17:51.094377";"2015-12-21 12:17:51.094377";"{807,809,810,811,806,805}";"{824,817,820,818,823,819}";"{5,5,5,5,5,5}";;0;"{59}";"{58}"
    # 4735;58;60;807;832;5;"2015-12-21 12:17:51.113236";"2015-12-21 12:17:51.113236";"{832,828,825,826,831,827}";"{807,809,810,811,806,805}";"{5,5,5,5,5,5}";;0;"{58}";"{60}"
    # 4736;60;58;832;807;5;"2015-12-21 12:17:51.135423";"2015-12-21 12:17:51.135423";"{807,809,810,811,806,805}";"{832,828,825,826,831,827}";"{5,5,5,5,5,5}";;0;"{60}";"{58}"



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
    else
      search_event = 100
      results = SearchResults.start_search_methods(current_user, search_event)
      logger.info "########## In home/index: results = #{results} "

       if results.has_key?(:similars)
         @similars = results[:similars]
         logger.info "########## In home/index: @similars = #{@similars} "
         @log_connection_id = results[:log_connection_id]
         @tree_info = results[:tree_info]

         unless @similars.empty?  # т.е. есть похожие
           flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
           # unless new_sims==""#.empty?  #  т.е. есть новые похожие - отлич. от ранее записанных
           # @tree_info = tree_info  # To View
           view_tree_similars(@tree_info, @similars) #unless @tree_info.empty?
           render :template => 'similars/show_similars_data' # показываем инфу о похожих
           # end
         end
      end
    end

          # todo: проверить: убрать запуск метода SimilarsLog.current_tree_log_id и взять @log_connection_id из sim_data
      # для отображения в show_similars_data
      # @log_connection_id = SimilarsLog.current_tree_log_id(@tree_info[:connected_users]) unless @tree_info.empty?





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



