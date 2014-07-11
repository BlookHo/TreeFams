class MainController < ApplicationController
 # include MainHelper  #

  before_filter :check_user

  def check_user
    redirect_to :root if !current_user
  end


 # Отображение дерева Юзера в табличной форме.
 # @note GET /
 # @param admin_page [Integer] опциональный номер страницы
 # @see News
 def get_user_tree(user_id)


      user_tree = Tree.where(:user_id => user_id)
      row_arr = []
      tree_arr = []

      user_tree.each do |tree_row|
        row_arr[0] = tree_row.user_id              # user_id ID От_Профиля
        row_arr[1] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        row_arr[2] = tree_row.name_id              # name_id ID От_Профиля
        row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        row_arr[4] = tree_row.is_profile_id        # ID К_Профиля
        row_arr[5] = tree_row.is_name_id           # name_id К_Профиля
        row_arr[6] = tree_row.is_sex_id            # sex К_Профиля
        row_arr[7] = tree_row.connected            # Объединено дерево К_Профиля с другим деревом

        tree_arr << row_arr
        row_arr = []

      end

      session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}
      @tree_arr = tree_arr    # DEBUGG TO VIEW

 end

 ############# МЕТОДЫ ФОРМИРОВАНИЯ ХЭША ПУТЕЙ ДЛЯ РЕЗ-ТОВ ПОИСКА

 # Делаем пути по результатам поиска - для отображения
 # @note GET /
  def make_search_results_paths(final_reduced_profiles_hash) #,final_reduced_relations_hash)
    @search_path_hash = Hash.new
    final_reduced_profiles_hash.each do |k_tree,v_tree|
      paths_arr = []
      one_path_hash = Hash.new
      start_profile = User.find(k_tree).profile_id
      one_tree_hash = get_tree_hash(k_tree)
      #@one_tree_hash = one_tree_hash    # DEBUGG_TO_VIEW
      #@start_profile = start_profile    # DEBUGG_TO_VIEW
      #@hash_to_transform = v_tree   # DEBUGG_TO_VIEW
      v_tree.each do |each_k,v_tree_hash|
        results_qty = v_tree_hash.size
        #@results_qty = results_qty  # DEBUGG_TO_VIEW
        #@profiles_arr_to_transform = v_tree_hash ## DEBUGG_TO_VIEW
        v_tree_hash.each do |finish_profile|
          #@finish_profile = finish_profile   # DEBUGG_TO_VIEW
          one_path_hash = make_path(one_tree_hash, finish_profile, results_qty)
          #@one_path_hash = one_path_hash # DEBUGG_TO_VIEW
          paths_arr << one_path_hash
          #@paths_arr = paths_arr # DEBUGG_TO_VIEW
        end
      end
      # Основной результат = @search_path_hash
      @search_path_hash.merge!({k_tree => paths_arr}) # наполнение хэша хэшами
    end
    # DEBUGG_TO_VIEW
    #@search_path_hash_size = @search_path_hash.size if !@search_path_hash.blank? # DEBUGG_TO_VIEW
  end

  # Добавляем один хэш в один path рез-тов поиска
  #
  def add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)
    qty = 0
    start_elem_arr = tree_hash.values_at(end_profile)[0] #
    relation_to_next_profile = start_elem_arr[0]
    elem_next_profile = start_elem_arr[1]
    qty = results_qty if end_profile == finish_profile
    @one_path_hash.merge!(make_one_hash_in_path(end_profile, relation_to_next_profile, qty))
    return @one_path_hash, relation_to_next_profile, elem_next_profile
  end

  # Делаем один path рез-тов поиска - далее он включается в итоговый хэш
  #
  def make_path(tree_hash, finish_profile, results_qty)
    @one_path_hash = Hash.new
    end_profile = finish_profile
    @one_path_hash, relation_to_next_profile, elem_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)
    while relation_to_next_profile != 0 do
      @one_path_hash, new_elem_relation, new_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, elem_next_profile)
      elem_next_profile = new_next_profile
      relation_to_next_profile = new_elem_relation
    end
    return Hash[@one_path_hash.to_a.reverse] #.reverse_order - чтобы шли от автора
  end

  # Получаем дерево в виде хэша для данного tree_user_id
  #
  def get_tree_hash(tree_user_id)
    return {} if tree_user_id.blank?
    tree_hash = Hash.new
    user_tree = Tree.where(:user_id => tree_user_id)  #
    if !user_tree.blank?
      user_tree.each do |tree_row|
        tree_hash.merge!({tree_row.is_profile_id => [tree_row.relation_id, tree_row.profile_id]})
      end
      return tree_hash
    end
  end

  # Делаем один хэш в один path рез-тов поиска
  #
  def make_one_hash_in_path(one_profile, one_relation, results_qty)
    one_hash_in_path = Hash.new
    one_hash_in_path.merge!({one_profile => {one_relation => results_qty}})
    return one_hash_in_path
  end

  #### КОНЕЦ МЕТОДОВ ФОРМИРОВАНИЯ ХЭША ПУТЕЙ ДЛЯ РЕЗ-ТОВ ПОИСКА




  ############# МЕТОДЫ ФОРМИРОВАНИЯ ВОПРОСОВ В НЕСТ. СИТ-Х

  # Основной метод формирования вопросов в нестандартных ситуациях добавления профилей
  # На выходе: сгенерированные массивы вопросов к каждому нестандартному relation
  # для добавляемого relation.
  def make_questions(user_id, profile_id, relation_add_to, relation_added, name_id_added) #

#    get_circle_as_hash(user_id, profile_id)
    @profile_id = profile_id  # profile_id user

#    Тестовый circle_as_hash(user_id, profile_id)
    @fathers_hash = {173 => 45 }
    @mothers_hash = {172 => 235 , 174 => 354 }
    @brothers_hash = {190 => 73, 191 => 66 }
    @sisters_hash = {1000 => 233, 1001 => 16}
    @wives_hash = {155 => 293 }
    @husbands_hash = {194 => 111 }
    @sons_hash = {156 => 151 }
    @daughters_hash = {153 => 212, 157 => 214 }

    case relation_add_to
      when 0
        check_author_relations(relation_added, name_id_added)
      when 1
        check_father_relations(relation_added, name_id_added)
      when 2
        check_mother_relations(relation_added, name_id_added)
      when 3, 4
        check_son_daughter_relations(relation_added, name_id_added)

      when 5, 6
        check_brother_sister_relations(relation_added, name_id_added)

      #when 7
      #  check_husband_relations(relation_added, name_id_added)
      #
      #when 8
      #  check_wife_relations(relation_added)

      else
        @standard_msg = "make_questions: Добавляемое отношение - неизвестно"
    end

  end


  # Выбор группы вопросов для Автора в нестандартных ситуациях
  # в завис-ти от добавляемого relation
  def check_author_relations(relation_added, added_name_id)
    case relation_added
      when 1 # add new father
        ask_author_questions(1, added_name_id)
      when 2 # add new mother
        ask_author_questions(2, added_name_id)
      when 7 # add new husband
        ask_author_questions(7, added_name_id)
      when 8 # add new wife
        ask_author_questions(8, added_name_id)
      else # все остальные relation_added - создают стандартные ситуации
        @standard_msg = "check_author_relations: Добавляемое к Автору отношение явл. СТАНДАРТНЫМ"
    end
  end

  # Выбор группы вопросов для Отца в нестандартных ситуациях
  # в завис-ти от добавляемого relation
  def check_father_relations(relation_added, added_name_id)
    case relation_added
      when 3 # add new son
        ask_father_questions(3, added_name_id)
      when 4 # add new daughter
        ask_father_questions(4, added_name_id)
      when 8 # add new wife
        ask_father_questions(8, added_name_id)
      else  # все остальные relation_added - создают стандартные ситуации
        @standard_msg = "check_father_relations: Добавляемое к Отцу отношение явл. СТАНДАРТНЫМ"
    end
  end

  # Выбор группы вопросов для Матери в нестандартных ситуациях
  # в завис-ти от добавляемого relation
  def check_mother_relations(relation_added, added_name_id)
    case relation_added
      when 3 # add new son
        ask_mother_questions(3, added_name_id)
      when 4 # add new daughter
        ask_mother_questions(4, added_name_id)
      when 7 # add new husband
        ask_mother_questions(7, added_name_id)
      else  # все остальные relation_added - создают стандартные ситуации
        @standard_msg = "check_mother_relations: Добавляемое к Матери отношение явл. СТАНДАРТНЫМ"
    end
  end

  # Выбор группы вопросов для Брата/Сестры в нестандартных ситуациях
  # в завис-ти от добавляемого relation
  def check_brother_sister_relations(relation_added, added_name_id)
    case relation_added
      when 1 # add new father
        ask_brother_sister_questions(1, added_name_id)
      when 2 # add new mother
        ask_brother_sister_questions(2, added_name_id)
      when 5 # add new brother
        ask_brother_sister_questions(5, added_name_id)
      when 6 # add new sister
        ask_brother_sister_questions(6, added_name_id)
      else  # все остальные relation_added - создают стандартные ситуации
        @standard_msg = "check_brother_sister_relations: Добавляемое к Матери отношение явл. СТАНДАРТНЫМ"
    end
  end

  # Выбор группы вопросов для Сына/Дочери в нестандартных ситуациях
  # в завис-ти от добавляемого relation
  def check_son_daughter_relations(relation_added, added_name_id)
    case relation_added
      when 1 # add new father
        ask_son_daughter_questions(1, added_name_id)
      when 2 # add new mother
        ask_son_daughter_questions(2, added_name_id)
      when 5 # add new brother
        ask_son_daughter_questions(5, added_name_id)
      when 6 # add new sister
        ask_son_daughter_questions(6, added_name_id)
      else  # все остальные relation_added - создают стандартные ситуации
        @standard_msg = "check_son_daughter_relations: Добавляемое к Сыну отношение явл. СТАНДАРТНЫМ"
    end
  end

  # Определение склонения по полу слова ВАШЕЙ(ГО) в зависимости от
  # пола relation
  def words_case_sex_relation(profile_relation, text_relation)
    case profile_relation
      when "Отец", "Брат", "Сын", "Муж"
        word_which_1 = "вашего"
      when "Мать", "Сестра", "Дочь", "Жена"
        word_which_1 = "вашей"
      else
        @standard_msg = "К кому добавляем - неизвестно"
    end

    case text_relation
      when "Отец", "Брат", "Сын", "Муж"
        word_which_2 = "вашим"
      when "Мать", "Сестра", "Дочь", "Жена"
        word_which_2 = "вашей"
      else
        @standard_msg = "К кому добавляем - неизвестно"
    end
    return word_which_1, word_which_2
  end

  # Формирование текста одного вопроса
  # При этом в зависимости от того, является ли автор членом хэша родни
  # видоизменяется вид вопроса для автора.
  #
  def make_one_question(one_question_name, author_profile_id, one_question_profile, added_relation, added_name, text_relation, profile_relation, which_string_1, which_string_2)

    name_exist = YandexInflect.inflections(Name.find(one_question_name).name)[1]["__content__"].mb_chars.capitalize
    if one_question_profile != author_profile_id # Если один из профилей в хэше circle - не автор
      # one_question = "Считаете ли вы КОГО <added_name КОГО> - КЕМ вашего(й) КОГО <name_exist КОГО>?"
      one_question = "Считаете ли вы #{added_relation} #{added_name} -  #{text_relation} #{which_string_1} #{profile_relation} #{name_exist}?"
    else  # Если один из профилей в хэше circle - автор. Тогда - видоизменен текст вопроса
      one_question = "Считаете ли вы #{added_relation} #{added_name} -  #{which_string_2} #{text_relation}?"
    end

    return one_question
  end
  # Добавляем вопросы в массив вопросов для данного хэша имен names_hash касательно добавляемого нового профиля с именем added_name_id
  # с новым отношением added_relation.
  # При этом в впоросе выясняется истинность отношения text_relation добавленного added_relation к рассматриваемому профилю
  # с отношением profile_relation
  def add_relation_questions(names_hash, added_name_id, added_relation, text_relation, profile_relation)
    return [] if names_hash.blank?
    if !names_hash.blank?
      names_arr = names_hash.values  # name_id array
      profiles_arr = names_hash.keys  # profile_id array
      #@profiles_arr = profiles_arr # DEBUGG_TO_VIEW
      inflect_added_relation    = YandexInflect.inflections(added_relation)[3]["__content__"]
      inflect_text_relation     = YandexInflect.inflections(text_relation)[4]["__content__"]
      inflect_profile_relation  = YandexInflect.inflections(profile_relation)[1]["__content__"]
      inflect_added_name        = YandexInflect.inflections(Name.find(added_name_id).name)[3]["__content__"].mb_chars.capitalize
      which_string_1, which_string_2 = words_case_sex_relation(profile_relation, text_relation)
      if !names_arr.blank?
        questions_hash = Hash.new
        for arr_ind in 0 .. names_arr.length - 1
          #@names_arr_arr_ind = names_arr[arr_ind] # DEBUGG_TO_VIEW
          one_question = make_one_question(names_arr[arr_ind], @profile_id, profiles_arr[arr_ind], inflect_added_relation, inflect_added_name, inflect_text_relation, inflect_profile_relation, which_string_1, which_string_2)
          # Добавляем один вопрос в хэш вопросов касательно нового отношения
          questions_hash.merge!({profiles_arr[arr_ind] => one_question})
          #@one_question = one_question # DEBUGG_TO_VIEW
        end
      end
    end
    return questions_hash
  end

  # Генерация вопросов для Автора в создавшихся нестандартных ситуациях.
  # В зависимости от того, какое relation добавляем,
  # заполняются те массивы вопросов, которые следует задавать
  def ask_author_questions(added_relation, added_name_id) # 0
    non_standard_questions_hash = Hash.new
    case added_relation
      when 1  # Добавляем Отца к Автору - то же, что 5,6 - 1
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Отец", "Отец", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Отец", "Отец", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@mothers_hash, added_name_id, "Отец", "Муж", "Мать"))
      when 2  # Добавляем Мать к Автору - то же, что 5,6 - 2
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Мать", "Мать", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Мать", "Мать", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@fathers_hash, added_name_id, "Мать", "Жена", "Отец"))
      when 7  # Добавляем Мужа к Автору (женщине)
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Муж", "Отец", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Муж", "Отец", "Дочь"))
      when 8  # Добавляем Жену к Автору (мужчине)
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Жена", "Мать", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Жена", "Мать", "Дочь"))
      else
        "Неизвестно"
    end
    @non_standard_questions_hash = non_standard_questions_hash   #
  end

  # Генерация вопросов для Отца в создавшихся нестандартных ситуациях.
  # В зависимости от того, какое relation добавляем,
  # заполняются те массивы вопросов, которые следует задавать
  #
  def ask_father_questions(added_relation, added_name_id) # 1
    non_standard_questions_hash = Hash.new
    case added_relation
      when 3  # Добавляем Сына к Отцу
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Сын", "Брат", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Сын", "Брат", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@mothers_hash, added_name_id, "Сын", "Сын", "Мать"))
        @standard_msg = "Добавляем Сына к Отцу"
      when 4  # Добавляем Дочь к Отцу
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Дочь", "Сестра", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Дочь", "Сестра", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@mothers_hash, added_name_id, "Дочь", "Дочь", "Мать"))
      when 8  # Добавляем Жену к Отцу
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Жена", "Мать", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Жена", "Мать", "Сестра"))
      else
        "Неизвестно"
    end
    @non_standard_questions_hash = non_standard_questions_hash   #
  end

  # Генерация вопросов для Матери в создавшихся нестандартных ситуациях.
  # В зависимости от того, какое relation добавляем,
  # заполняются те массивы вопросов, которые следует задавать
  def ask_mother_questions(added_relation, added_name_id) # 2
    non_standard_questions_hash = Hash.new
    case added_relation
      when 3  # Добавляем Сына к Матери
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Сын", "Брат", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Сын", "Брат", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@fathers_hash, added_name_id, "Сын", "Сын", "Отец"))
        @standard_msg = "Добавляем Сына к Матери (Автора)"
      when 4  # Добавляем Дочь к Матери
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Дочь", "Сестра", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Дочь", "Сестра", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@fathers_hash, added_name_id, "Дочь", "Дочь", "Отец"))
      when 7  # Добавляем Мужа к Матери
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Муж", "Отец", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Муж", "Отец", "Сестра"))
      else
        "Неизвестно"
    end
    @non_standard_questions_hash = non_standard_questions_hash   #
  end


  # Генерация вопросов для Брата/Сестры в создавшихся нестандартных ситуациях.
  # В зависимости от того, какое relation добавляем,
  # заполняются те массивы вопросов, которые следует задавать
  def ask_brother_sister_questions(added_relation, added_name_id) # 5, 6
    non_standard_questions_hash = Hash.new
    case added_relation
      when 1  # Добавляем Отца к Брату/Сестре - то же, что 0 - 1
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Отец", "Отец", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Отец", "Отец", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@mothers_hash, added_name_id, "Отец", "Муж", "Мать"))
      when 2  # Добавляем Мать к Брату/Сестре - то же, что 0 - 2
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Мать", "Мать", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Мать", "Мать", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@fathers_hash, added_name_id, "Мать", "Жена", "Отец"))
        @standard_msg = "Добавляем Мать к Брату/Сестре"
      when 5  # Добавляем к Брата к Брату/Сестре
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Брат", "Брат", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Брат", "Брат", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@fathers_hash, added_name_id, "Брат", "Сын", "Отец"))
        non_standard_questions_hash.merge!(add_relation_questions(@mothers_hash, added_name_id, "Брат", "Сын", "Мать"))
      when 6  # Добавляем к Сестру к Брату/Сестре
        non_standard_questions_hash.merge!(add_relation_questions(@brothers_hash, added_name_id, "Сестра", "Сестра", "Брат"))
        non_standard_questions_hash.merge!(add_relation_questions(@sisters_hash, added_name_id, "Сестра", "Сестра", "Сестра"))
        non_standard_questions_hash.merge!(add_relation_questions(@fathers_hash, added_name_id, "Сестра", "Дочь", "Отец"))
        non_standard_questions_hash.merge!(add_relation_questions(@mothers_hash, added_name_id, "Сестра", "Дочь", "Мать"))
      else
        "Неизвестно"
    end
    @non_standard_questions_hash = non_standard_questions_hash   #
  end

  # Генерация вопросов для Сына/Дочери в создавшихся нестандартных ситуациях.
  # В зависимости от того, какое relation добавляем,
  # заполняются те массивы вопросов, которые следует задавать
  def ask_son_daughter_questions(added_relation, added_name_id) # 3, 4
    non_standard_questions_hash = Hash.new
    @added_relation = added_relation
    @added_name_id = added_name_id

    case added_relation
      when 1  # Добавляем Отца к Сыну/Дочери - то же, что
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Отец", "Отец", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Отец", "Отец", "Дочь"))
        non_standard_questions_hash.merge!(add_relation_questions(@wives_hash, added_name_id, "Отец", "Муж", "Жена"))
        @standard_msg = "Добавляем Отца к Сыну/Дочери"
      when 2  # Добавляем Мать к Сыну/Дочери - то же, что
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Мать", "Мать", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Мать", "Мать", "Дочь"))
        non_standard_questions_hash.merge!(add_relation_questions(@husbands_hash, added_name_id, "Мать", "Жена", "Муж"))
        @standard_msg = "Добавляем Мать к Сыну/Дочери"
      when 5  # Добавляем Брата к Сыну/Дочери
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Брат", "Брат", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Брат", "Брат", "Дочь"))
        non_standard_questions_hash.merge!(add_relation_questions(@husbands_hash, added_name_id, "Брат", "Сын", "Муж"))
        non_standard_questions_hash.merge!(add_relation_questions(@wives_hash, added_name_id, "Брат", "Сын", "Жена"))
      when 6  # Добавляем Сестру к Сыну/Дочери
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Сестра", "Сестра", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Сестра", "Сестра", "Дочь"))
        non_standard_questions_hash.merge!(add_relation_questions(@husbands_hash, added_name_id, "Сестра", "Дочь", "Муж"))
        non_standard_questions_hash.merge!(add_relation_questions(@wives_hash, added_name_id, "Сестра", "Дочь", "Жена"))

      else
        "Неизвестно"
    end
    @non_standard_questions_hash = non_standard_questions_hash   #
  end



#########################################blank?
  ################################################ end of нестанд.сит-й







# Поиск совпадений по дереву Юзера
# Основной метод
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
 def main_page
   @circle = current_user.profile.circle(current_user.id)
   @author = current_user.profile
    if current_user
    # Для отладки add_profile - исключаем этот метод
     get_user_tree(current_user.id) # Получение массива дерева текущего Юзера из Tree

     ## @bk_arr = circle_as_array(current_user.id)
     # @bk_arr = current_user.profile.circle_as_array(current_user.id)
     # target_profile_id = 155
     # @circle = Profile.find(target_profile_id).circle_as_array(current_user.id)
     #@circle_hash = current_user.profile.circle_as_hash(current_user.id)#
     #@circle_hash_mothers = current_user.profile.mothers_hash(current_user.id)#

      beg_search_time = Time.now   # Начало отсечки времени поиска

      search_profiles_tree_match    # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5)


      # Call of make_path method
      make_search_results_paths(@final_reduced_profiles_hash) #,@final_reduced_relations_hash)

      # Call of make_questions method
      @relation_add_to = 4  # Отношение, к которому добавляем
      @relation_added = 5   # Отношение, которое добавляем
      @user_id = 28 #
      @profile_id = 191
      @name_id = 64

      make_questions(@user_id, @profile_id, @relation_add_to, @relation_added, @name_id) #


    end

    session[:search_results_relations] = nil
    session[:all_match_relations_sorted] = nil


    @search_results_relations = []
    @final_reduced_profiles_hash.each do |tree_id,  tree_value|
      tree_value.each do |matched_key, matched_value|
        matched_value.each_with_index do |profile_id, index|
          relation = @final_reduced_relations_hash[tree_id][matched_key][index]
          @search_results_relations << {profile_id => {matched_key => relation}}
        end
      end
    end

    session[:search_results_relations] = @search_results_relations
    session[:results_count_hash] =  @final_reduced_relations_hash





    # Ближние круги пользователей из результатов поиска
    @search_results = []
    result_users = User.where(id: @wide_user_ids_arr)
    sorted_result_users = @wide_user_ids_arr.collect {|id| result_users.detect {|u| u.id == id.to_i } }
    sorted_result_users.each do |user|
      @search_results << Hashie::Mash.new( {author: user, circle: user.profile.circle(user.id)} )
    end


    # Path search results
    @path_search_results = []
    @search_path_hash.each do |user_id, user_paths|
      user = User.find user_id
      @path_search_results << {user: user, paths: collect_path_profiles(user_paths)}
    end
    @path_search_results

 end



 def collect_path_profiles(user_paths)
   results = []
   user_paths.each do |paths|
     # results << paths
     result = []
     prev_sex_id = nil
     paths.each do |profile_id, data|
       result << {profile: Profile.find(profile_id), data: data, relation: data.keys.first, prev_sex_id: prev_sex_id}
     end
     results << result
   end
   return results
 end



  # Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[tree_index][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
 def get_relation_match(from_profile_searching, profile_id_searched, relation_id_searched)

   found_trees_hash = Hash.new     #{ 0 => []}
   found_profiles_hash = Hash.new  #
   found_relations_hash = Hash.new  #
   all_relation_match_arr = []     #

   wide_found_profiles_hash = Hash.new  #
   wide_found_relations_hash = Hash.new  #


   all_profile_rows = ProfileKey.where(:user_id => current_user.id).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id)
   # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
   @from_profile_searching = from_profile_searching  # DEBUGG_TO_VIEW
   @profile_searched = profile_id_searched   # DEBUGG_TO_VIEW
   @relation_searched = relation_id_searched   # DEBUGG TO VIEW
   @all_profile_rows = all_profile_rows   # DEBUGG_TO_VIEW

   if !all_profile_rows.blank?
     @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #_DEBUGG_TO_VIEW
     # размер ближнего круга профиля в дереве current_user.id
     all_profile_rows.each do |relation_row|
        relation_match_arr = ProfileKey.where.not(user_id: current_user.id).where(:name_id => relation_row.name_id).where(:relation_id => relation_row.relation_id).where(:is_name_id => relation_row.is_name_id).select(:user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        if !relation_match_arr.blank?
          row_arr = []
          relation_match_arr.each do |tree_row|
            row_arr[0] = tree_row.user_id              # ID Автора
            row_arr[1] = tree_row.profile_id           # ID От_Профиля
            row_arr[2] = tree_row.name_id              # ID Имени От_Профиля
            row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с другим К_Профиля
            row_arr[4] = tree_row.is_profile_id        # ID другого К_Профиля
            row_arr[5] = tree_row.is_name_id           # ID Имени К_Профиля

            all_relation_match_arr << row_arr
            row_arr = []

            fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
            found_profiles_hash.merge!({tree_row.user_id  => [tree_row.profile_id]}) # наполнение хэша найденными profile_id
            found_relations_hash.merge!({tree_row.user_id  => [relation_id_searched]}) # наполнение хэша найденными relation_id

            wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [tree_row.profile_id]} } ) # наполнение хэша найденными profile_id
            wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id

          end
          @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW
        else
         # @relation_match_arr = ["relation_match_arr"]   # DEBUGG TO VIEW
        end
     end
     @relation_id_searched_arr << relation_id_searched  #_DEBUGG_TO_VIEW

     ##### НАСТРОЙКИ результатов поиска

     # Исключение тех user_id, по которым не все запросы дали результат внутри Ближнего круга
     # Остаются те user_id, в которых найдены совпавшие профили.
     # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно (не меньше) длине массива
     # всех видов отношений в блжнем круге для разыскиваемого профиля.
     if relation_id_searched != 0 # Для всех профилей, кот-е не явл. current_user
       # Исключение из результатов поиска
#       if all_profile_rows.length > 3

#       found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length - 1 } #
       #found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length } #
       # all_profile_rows.length = размер ближнего круга профиля в дереве current_user.id
       #else
       #  # Если маленький БК
       #  found_trees_hash.delete_if {|key, value|  value <= 2  }  # 1 .. 3 = НАСТРОЙКА!!
       #end

     else
       if all_profile_rows.length >= 3
         found_trees_hash.delete_if {|key, value|  value <= 2 } #all_profile_rows.length  }  # 1 .. 3 = НАСТРОЙКА!!
         # Исключение из результатов поиска групп с малым кол-вом совпадений в других деревьях or value < all_profile_rows.length
       else
         # Если маленький БК
         found_trees_hash.delete_if {|key, value|  value <= 1  }  # 1 .. 2 = НАСТРОЙКА!!
       end
     end

   end


   ##### КОРРЕКТИРОВКА результатов поиска
   found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   @test_found_profiles_hash = found_profiles_hash

   found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => relation_id} - найденные деревья с найденным relation_id.

   wide_found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   @test_wide_found_profiles_hash = found_profiles_hash

   wide_found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей

   ##### ИТОГОВЫЕ результаты поиска
   #@all_match_trees_arr << found_trees_hash if !found_trees_hash.blank? # Заполнение выходного массива хэшей
   @all_match_profiles_arr << found_profiles_hash if !found_profiles_hash.blank? # Заполнение выходного массива хэшей
   @all_match_relations_arr << found_relations_hash if !found_relations_hash.empty? # Заполнение выходного массива хэшей
   #####

   ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска
   @all_wide_match_profiles_arr << wide_found_profiles_hash if !found_profiles_hash.blank? # Заполнение выходного массива хэшей
   @all_wide_match_relations_arr << wide_found_relations_hash if !found_relations_hash.empty? # Заполнение выходного массива хэшей

   @found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
   @found_relations_hash = found_relations_hash # DEBUGG TO VIEW
   @found_trees_hash = found_trees_hash # DEBUGG TO VIEW
   @all_profile_rows = all_profile_rows   # DEBUGG TO VIEW
   @all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW

   @wide_found_profiles_hash = wide_found_profiles_hash # DEBUGG TO VIEW
   @wide_found_relations_hash = wide_found_relations_hash # DEBUGG TO VIEW

 end

# Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_tree_match

    tree_arr = session[:tree_arr][:value] if !session[:tree_arr].blank?

    @tree_arr = tree_arr    # DEBUGG TO VIEW
    @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW
    @tree_to_display = []
    @tree_row = []

    ##### Будущие результаты поиска
    @all_match_trees_arr = []     # Массив совпадений деревьев
    @all_match_profiles_arr = []  # Массив совпадений профилей
    @all_match_relations_arr = []  # Массив совпадений отношений
    #####
    @all_wide_match_profiles_arr = []     # Широкий Массив совпадений профилей
    @all_wide_match_relations_arr = []     # Широкий Массив совпадений отношений

    @relation_id_searched_arr = []     #_DEBUGG_TO_VIEW Ok

    if !tree_arr.blank?
      for tree_index in 0 .. tree_arr.length-1
        from_profile_searching = tree_arr[tree_index][1] # От какого профиля осущ-ся Поиск
        profile_id_searched = tree_arr[tree_index][4] # Поиск по ID К_Профиля
        relation_id_searched = tree_arr[tree_index][3] # relation_id К_Профиля
        get_relation_match(from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
      end
    end

    if !@all_match_profiles_arr.blank?

      #### PROFILES
      all_match_hash = join_arr_of_hashes(@all_match_profiles_arr) if !@all_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      #@all_match_hash = all_match_hash  #_DEBUGG_TO_VIEW

      @all_match_arr_sorted = Hash[all_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      ##### НАСТРОЙКИ результатов поиска:

      # КОРРЕКТИРОВАТЬ ВМЕСТЕ С @all_match_relations_sorted !!!!
      #@all_match_arr_sorted.delete_if {|key, value| value.size == 1 }  #
      # Исключение тех рез-тов поиска, где найден всего один профиль
      @user_ids_arr = @all_match_arr_sorted.keys  # TO VIEW
      profile_ids_arr = @all_match_arr_sorted.values.flatten # TO VIEW
      @amount_of_profiles = profile_ids_arr.size if !profile_ids_arr.blank? # TO VIEW

      #### RELATIONS
      all_match_relations_hash = join_arr_of_hashes(@all_match_relations_arr) if !@all_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_match_relations_sorted = Hash[all_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      ##### НАСТРОЙКИ результатов поиска
      #@all_match_relations_sorted.delete_if {|key, value| value .size == 1 }  #
      # Исключение тех рез-тов поиска (отношения), где найден всего один профиль

      @relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
           @all_match_relations_hash = all_match_relations_hash # TO VIEW
      count_users_found(profile_ids_arr) # TO VIEW
    end

    #### расширенные РЕЗУЛЬТАТЫ ПОИСКА:
    if !@all_wide_match_profiles_arr.blank?
      #### PROFILES
      all_wide_match_hash = join_arr_of_hashes(@all_wide_match_profiles_arr) if !@all_wide_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_hash = all_wide_match_hash  #_DEBUGG_TO_VIEW
      @all_wide_match_arr_sorted = Hash[all_wide_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      @complete_hash = make_complete_hash(@all_wide_match_arr_sorted)  #_DEBUGG_TO_VIEW

      # @final_reduced_profiles_hash = итоговый Хаш массивов найденных профилей
      @final_reduced_profiles_hash = reduce_hash(make_complete_hash(@all_wide_match_arr_sorted))  # TO VIEW

      # @wide_user_ids_arr = итоговый массив найденных деревьев
      @wide_user_ids_arr = @final_reduced_profiles_hash.keys.flatten  # TO VIEW

      # @wide_profile_ids_arr = итоговый массив хашей найденных профилей
      @wide_profile_ids_arr = @final_reduced_profiles_hash.values.flatten # TO VIEW

      # @wide_amount_of_profiles = Подсчет количества найденных Профилей в массиве Хэшей
      @wide_amount_of_profiles = count_profiles_in_hash(@wide_profile_ids_arr)

      #### RELATIONS
      all_wide_match_relations_hash = join_arr_of_hashes(@all_wide_match_relations_arr) if !@all_wide_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_relations_sorted = Hash[all_wide_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      #@complete_relations_hash = make_complete_hash(@all_wide_match_relations_sorted)

      @final_reduced_relations_hash = reduce_hash(make_complete_hash(@all_wide_match_relations_sorted))  # TO VIEW

      #@relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
      #@all_match_relations_hash = all_match_relations_hash # TO VIEW
      #count_users_found(profile_ids_arr) # TO VIEW

    else
      @final_reduced_profiles_hash = []
      @final_reduced_relations_hash = []
      @wide_user_ids_arr = []
    end

  end



  ## Формирование полного щирокого Хаша
  # @note GET
  # На входе:
  # На выходе: @ Итоговый  ХЭШ
  def make_complete_hash(input_hash)
    complete_hash = Hash.new     #
    if !input_hash.blank?
      input_hash.each do |k, v|
        if v.size == 1
          complete_hash.merge!({k => v}) # наполнение хэша найденными profile_id
        else
          rez_hash = Hash.new     #
          v.each do |one_arr|
            if !one_arr.blank?
              merged_hash = rez_hash.merge({one_arr[0] => one_arr[1]}){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
              rez_hash = merged_hash
            end
          end
          complete_hash.merge!(k => rez_hash) # искомый хэш
          # с найденнымии profile_id, распределенными по связанным с ними profile_id
        end
      end
    end
    return complete_hash
  end


  # НАСТРОЙКА СОКРАЩЕНИЯ РЕ-В ПОИСКА: УДАЛЕНИЕ КОРОТКИХ СОВПАДЕНИЙ
  # ЦИФРА В УСЛОВИИ if - ЭТО РАЗМЕР СОВПАДЕНИЙ В ДЕРЕВЕ ПРИ ПОИСКЕ.
  # # Исключение тех рез-тов поиска, где найден всего один профиль
  # @note GET
  # На входе:
  # На выходе: @ Итоговый  ХЭШ
  def reduce_hash(input_hash)
    reduced_hash = Hash.new
    input_hash.each do |k, v|
      if v.values.flatten.size > 1  # НАСТРОЙКА УДАЛЕНИЯ МАЛЫХ СОВПАДЕНИЙ
        reduced_hash.merge!({k => v}) #
      end
    end
    return reduced_hash
  end

  # Слияние массива Хэшей без потери значений { (key = user_id) => (value = profile_id) }
  # Получение упорядоченного Хэша: {user_id  -> [ profile_id, profile_id, profile_id ...]}
  # @note GET
  # На входе: массив хэшей: [{user_id -> profile_id, ... , user_id -> profile_id}, ..., {user_id -> profile_id, ... , user_id -> profile_id} ]
  # На выходе: @all_match_hash Итоговый упорядоченный ХЭШ
  # @param admin_page [Integer]
  def join_arr_of_hashes(all_match_hash_arr)
    final_merged_hash = Hash.new
    for h_ind in 0 .. all_match_hash_arr.length - 1
      next_hash = all_match_hash_arr[h_ind]
      merged_hash = final_merged_hash.merge(next_hash){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
      final_merged_hash = merged_hash
    end
    #@all_match_hash = final_merged_hash  # DEBUGG TO VIEW
    return final_merged_hash
  end

  # Преобразование Хэша хэшей в Хэш массивов вместо хэшей
  # На входе: Из: { user_id => { profile_id => [profile_id, profile_id ,..]}, user_id => { profile_id => [profile_id, profile_id ,..]}
  # На выходе в Хэш, где значения - массивы:
  # { user_id => [ profile_id, [profile_id, profile_id ,..]], user_id => [profile_id, [profile_id, profile_id ,..]]
  # @note GET
  # final_hash_arr = Итоговый ХЭШ
  def hash_hash_to_hash_arr(input_hash_hash)
    final_hash_arr = Hash.new
    ind = 0
    input_hash_hash.values.each do |one_hash|
      new_hash_merging = final_hash_arr.merge({input_hash_hash.keys[ind] => one_hash.to_a.flatten(1)} )
      final_hash_arr = new_hash_merging
      ind += 1
    end
    return final_hash_arr
  end


  # Подсчет количества найденных Профилей в массиве Хэшей
  # На входе: массив Хэшей профилей input_arr_hash
  # На выходе: amount_found Кол-во
  def count_profiles_in_hash(input_arr_hash)
    amount_found = 0
    input_arr_hash.each do |k|
      amount_found = amount_found + k.values.flatten.size
    end
    return amount_found
  end
  # Подсчет количества найденных Юзеров среди найденных Профилей
  # @note GET
  # На входе: массив профилей all_profiles_arr: profile_id
  # На выходе: @count Кол-во Юзеров
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def count_users_found(all_profiles_arr)
    @count = 0
    @users_ids_arr = []
    for ind in 0 .. all_profiles_arr.length - 1
      user_found_id = User.find_by_profile_id(all_profiles_arr[ind])
      if !user_found_id.blank?
        @count += 1
        @users_ids_arr << user_found_id.id  # user_id среди найденных профилей
      end
    end
  end

  # Подтверждение совпадения родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def match_approval

    @session_id = request.session_options[:id]    # ?

    if user_signed_in?

      @new_approved_qty = 3
      @total_approved_qty = @@approved_match_qty + @new_approved_qty
      @rest_to_approve = @@match_qty - @total_approved_qty

      @triplex_arr = []
      make_one_triplex_arr(current_user.id,@triplex_arr,nil,1,2)   # @triplex_arr - ready!

      # Поиск братьев/сестер по триплекс-массиву
      # У братьев/сестер - те же отец и мать.
      # [profile_id, sex_id, name_id, relation_id]
      # @triplex_arr: [[22, 0, 506, nil], [23, 1, 45, 1], [24, 0, 453, 2]]
      search_bros_sist(@triplex_arr)  # найдены общие отцы с потенциальными братьями/сестрами

    end

  end

  # Отображение меню действий для родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def relative_menu
    @menu_choice = "No choice yet - in Relative_menu"
  end







end
