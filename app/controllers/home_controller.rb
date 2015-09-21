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

    # class Hash
    #   def include?(other)
    #     self.merge(other) == self
    #   end
    # end

    def exclude_doubles_results(by_trees_arr, arr_to_exclude)
      new_arr = []
      new_by_trees_arr = []
      arr_to_exclude.each do |tree_id_with_double|
        tree_id_with_double
        # by_trees_arr.delete_if {|one_hash| one_hash.include?({found_tree_id:  tree_id_with_double })  }

        by_trees_arr.each do |one_hash|
          logger.info " In home/index: exclude_doubles_results: one_hash = #{one_hash}, tree_id_with_double = #{tree_id_with_double} "
          # logger.info " In home/index: exclude_doubles_results: include? = #{one_hash.include?({found_tree_id:  tree_id_with_double })} "
          if one_hash.merge({found_tree_id: tree_id_with_double }) == one_hash
            logger.info " In home/index: one_hash = #{one_hash} "
            new_by_trees_arr = by_trees_arr - [one_hash]
          end
        end
        logger.info " In home/index: exclude_doubles_results: new_by_trees_arr = #{new_by_trees_arr} "
        # by_trees_arr.each do |one_hash|
        #   one_hash
        # end
      end
      logger.info "########## In home/index: exclude_doubles_results: - YES"
      new_arr
    end

   ########## In home/index: exclude_doubles_results:
   # by_trees_arr = [{:found_tree_id=>34, :found_profile_ids=>[542, 541, 543, 544, 539, 540]},
   # {:found_tree_id=>45, :found_profile_ids=>[649, 650, 645, 646, 651, 647]},
   # {:found_tree_id=>47, :found_profile_ids=>[669, 671, 666, 668, 672, 667, 670, 673]}]




    # TEST
    by_trees_arr =
    [{:found_tree_id=>34, :found_profile_ids=>[542, 541, 543, 544, 539, 540]},
     {:found_tree_id=>45, :found_profile_ids=>[649, 650, 645, 646, 651, 647]},
     {:found_tree_id=>47, :found_profile_ids=>[669, 671, 666, 668, 672, 667, 670, 673]}]

    arr_to_exclude = [45]

    new_arr = exclude_doubles_results(by_trees_arr, arr_to_exclude)
    logger.info "########## In home/index: after exclude_doubles_results: new_arr = #{new_arr}"


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






    similars_data = current_user.start_similars
    @tree_info = similars_data[:tree_info]
    # new_sims = similars_data[:new_sims]
    @similars = similars_data[:similars]
    logger.info "########## In home/index: @similars = #{@similars} "
    @log_connection_id = similars_data[:log_connection_id]
        # todo: проверить: убрать запуск метода SimilarsLog.current_tree_log_id и взять @log_connection_id из sim_data
    # для отображения в show_similars_data
    # @log_connection_id = SimilarsLog.current_tree_log_id(@tree_info[:connected_users]) unless @tree_info.empty?

    unless @similars.empty?  # т.е. есть похожие
      flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
    #   unless new_sims==""#.empty?  #  т.е. есть новые похожие - отлич. от ранее записанных
    #     # @tree_info = tree_info  # To View
    #     view_tree_similars(@tree_info, @similars) unless @tree_info.empty?
    #     render :template => 'similars/show_similars_data' # показываем инфу о похожих
    #   end
    end

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
        render :template => 'similars/show_similars_data' # показываем инфу о похожих
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