class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'


  # All profiles in user's tree
  def index
    tree_info, sim_data, similars = current_user.start_similars
    # todo: проверить: убрать запуск метода SimilarsLog.current_tree_log_id и взять @log_connection_id из sim_data
    # для отображения в show_similars_data
    @log_connection_id = SimilarsLog.current_tree_log_id(tree_info[:connected_users]) unless tree_info.empty?
    unless similars.empty?  # т.е. есть похожие
      # flash_obj = {
      #   type: :alert,
      #   message: "Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно",
      #   link: internal_similars_search_path
      # }
      # flash.now[:link] = flash_obj # unless similars.empty?
      flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
      unless sim_data.empty?  #  т.е. есть новые похожие - отлич. от ранее записанных
        @tree_info = tree_info  # To View
        view_tree_data(tree_info, sim_data) unless tree_info.empty?
        render :template => 'similars/show_similars_data' # показываем инфу о похожих
      end
    end
  end


  def show
  end


  def search
  end



  private


  # Отобр-е параметров дерева и sim_data во вьюхе
  def view_tree_data(tree_info, sim_data)

    @tree_info = tree_info
    logger.info "In similars_contrler 1:  @tree_info[:connected_users] = #{tree_info[:connected_users]}, @tree_info = #{tree_info},  "  if !tree_info.blank?
    logger.info "In similars_contrler 1a: @tree_info.profiles.size = #{tree_info[:profiles].size} "  if !tree_info.blank?
   # @log_connection_id = sim_data[:log_connection_id]
    @current_user_id = current_user.id

    view_similars(sim_data) unless sim_data.empty?

  end


  # Отображение во вьюхе Похожих и - для них - непохожих, если есть
  def view_similars(sim_data)

    @sim_data = sim_data  #
    logger.info "In similars_contrler 01:  @sim_data = #{@sim_data} "
    @similars = sim_data[:similars]
    @similars_qty = @similars.size unless sim_data[:similars].empty?
    #################################################
    @paged_similars_data = pages_of(@similars, 10) # Пагинация - по 10 строк на стр.

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