# Модуль генерации вопросов при добавлении нового профиля с нестандартными отношениями
module ProfileQuestions

  extend ActiveSupport::Concern

  ############# МЕТОДЫ ФОРМИРОВАНИЯ ВОПРОСОВ В НЕСТ. СИТ-Х

  # Основной метод формирования вопросов в нестандартных ситуациях добавления профилей
  # На выходе: сгенерированные массивы вопросов к каждому нестандартному relation
  # для добавляемого relation.

  # user_id           Дерево в которое добавляем или массив деревеье
  # profile_id        Профиль к которому добавляем
  # relation_add_to   Отношение К которому добавляем
  # relation_added    Отношение КОТОРОЕ добавляем (кого добавляем)
  # name_id_added     ID имени нового отношения
  # author_profile_id  ID профиля автора (центра) круга, для кого нужно собирать хеши и относительно кого строются вопросы
  # user_ids - Id всех объединенных юзеров
  def make_questions(user_id, profile_id, relation_add_to, relation_added, name_id_added, author_profile_id, user_ids)

    logger.info " in make_questions: profile_id = #{profile_id}"
    @non_standard_questions_hash = Hash.new
    # Собираем хеш ближнего круга
    circle_hashes = get_circle_as_hash(user_ids, author_profile_id)

    @incoming_author_profile_id = author_profile_id # автор текущего круга

    @tmp_author_profile_id = User.find(user_id).profile_id  # Главный автор - Юзер


    @fathers_hash = circle_hashes[:fathers]
    @mothers_hash = circle_hashes[:mothers]
    @brothers_hash = circle_hashes[:brothers]
    @sisters_hash = circle_hashes[:sisters]
    @wives_hash = circle_hashes[:wives]
    @husbands_hash = circle_hashes[:husbands]
    @sons_hash = circle_hashes[:sons]
    @daughters_hash = circle_hashes[:daughters]

    @author_hash = circle_hashes[:author] # Инфа о текущем авторе
    tmp_author_hash = {@author_hash["profile_id"] => @author_hash["name_id"]}

    # Включение в списки братьев или сестер автора в завис-ти от его пола
    if @author_hash["sex_id"] == 1
      @brothers_hash.merge!(tmp_author_hash)
    else
      @sisters_hash.merge!(tmp_author_hash)
    end

    logger.info "=====@fathers_hash========"
    logger.info @fathers_hash
    logger.info "=====@mothers_hash========"
    logger.info @mothers_hash
    logger.info "=====@brothers_hash========"
    logger.info @brothers_hash
    logger.info "=====@sisters_hash========"
    logger.info @sisters_hash
    logger.info "=====@wives_hash========"
    logger.info @wives_hash
    logger.info "=====@husbands_hash========"
    logger.info @husbands_hash
    logger.info "=====@sons_hash========"
    logger.info @sons_hash
    logger.info "=====@daughters_hash========"
    logger.info @daughters_hash

    case relation_add_to
      when 0
        logger.info "== in case: relation_add_to = #{relation_add_to} "
        check_author_relations(relation_added, name_id_added)
      when 1

        check_father_relations(relation_added, name_id_added)
      when 2
        check_mother_relations(relation_added, name_id_added)
      when 3
        check_son_daughter_relations(relation_added, name_id_added)
      when 4
        check_son_daughter_relations(relation_added, name_id_added)
      when 5, 6
        check_brother_sister_relations(relation_added, name_id_added)
      when 7, 8
        check_husband_wife_relations(relation_added, name_id_added)
      else
        # @standard_msg = "make_questions: Добавляемое отношение - неизвестно"
        nil
    end
    logger.info "== after case: relation_add_to = #{relation_add_to} "
    logger.info "== after  - make_questions: @non_standard_questions_hash = #{@non_standard_questions_hash} "

    return @non_standard_questions_hash
  end



  def get_circle_as_hash(user_id, profile_id)
    profile = Profile.find profile_id
    profile.circle_as_hash(user_id)
  end


  # Выбор группы вопросов для Автора в нестандартных ситуациях
  # в завис-ти от добавляемого relation
  def check_author_relations(relation_added, added_name_id)
    logger.info "== in check_author_relations: relation_added = #{relation_added} "

    case relation_added
      when 1 # add new father
        ask_author_questions(1, added_name_id)
      when 2 # add new mother
        ask_author_questions(2, added_name_id)
      when 7 # add new husband
        ask_author_questions(7, added_name_id)
      when 8 # add new wife
        logger.info "== in case 8  - check_author_relations: relation_added = #{relation_added} "
        ask_author_questions(8, added_name_id)
      else # все остальные relation_added - создают стандартные ситуации
        # @standard_msg = "check_author_relations: Добавляемое к Автору отношение явл. СТАНДАРТНЫМ"
        nil
    end
    logger.info "== after  - check_author_relations: @non_standard_questions_hash = #{@non_standard_questions_hash} "

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
        # @standard_msg = "check_father_relations: Добавляемое к Отцу отношение явл. СТАНДАРТНЫМ"
        nil
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
        # @standard_msg = "check_mother_relations: Добавляемое к Матери отношение явл. СТАНДАРТНЫМ"
        nil
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
        # @standard_msg = "check_brother_sister_relations: Добавляемое к Матери отношение явл. СТАНДАРТНЫМ"
        nil
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
        # @standard_msg = "check_son_daughter_relations: Добавляемое к Сыну/Дочери отношение явл. СТАНДАРТНЫМ"
        nil
    end
  end

  # Выбор группы вопросов для Мужа/Жены в нестандартных ситуациях
  # в завис-ти от добавляемого relation
  def check_husband_wife_relations(relation_added, added_name_id)
    case relation_added
      when 3 # add new son
        ask_husband_wife_questions(3, added_name_id)
      when 4 # add new daughter
        ask_husband_wife_questions(4, added_name_id)
      when 7 # add new husband
        ask_husband_wife_questions(7, added_name_id)
      when 8 # add new wife
        ask_husband_wife_questions(8, added_name_id)
      else  # все остальные relation_added - создают стандартные ситуации
        # @standard_msg = "check_father_relations: Добавляемое к Мужа/Жены отношение явл. СТАНДАРТНЫМ"
        nil
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
    logger.info "BIG DEBUG =============one_question_profile==========="
    logger.info one_question_profile
    logger.info "BIG DEBUG ============author_profile_id============"
    logger.info author_profile_id
    logger.info "EDN BIG DEBUG ========================"


    #if one_question_profile != author_profile_id # Если один из профилей в хэше circle - не автор
    #   # one_question = "Считаете ли вы КОГО <added_name КОГО> - КЕМ вашего(й) КОГО <name_exist КОГО>?"
    #   one_question = "Считаете ли вы #{added_relation} #{added_name} -  #{text_relation} #{which_string_1} #{profile_relation} #{name_exist}?"
    #else  # Если один из профилей в хэше circle - автор. Тогда - видоизменен текст вопроса
    #   logger.info "2 BIG DEBUG ========================"
    #   one_question = "Считаете ли вы #{added_relation} #{added_name} -  #{which_string_2} #{text_relation}?"
    #end

    if @incoming_author_profile_id.to_i != author_profile_id
      ## one_question = "Считаете ли вы КОГО <added_name КОГО> - КЕМ вашего(й) КОГО <name_exist КОГО>?"
      #  one_question = "Считаете ли вы #{added_relation} #{added_name} -  #{text_relation} <strike>1 #{which_string_1} #{profile_relation} </strike> #{name_exist}?"
        one_question = "Считаете ли вы #{added_relation} #{added_name} -  #{text_relation} #{name_exist}?"
    else
      if one_question_profile != author_profile_id # Если один из профилей в хэше circle - не автор
        # one_question = "Считаете ли вы КОГО <added_name КОГО> - КЕМ вашего(й) КОГО <name_exist КОГО>?"
        one_question = "Считаете ли вы #{added_relation} #{added_name} - #{text_relation} #{which_string_1} #{profile_relation} #{name_exist}?"
      else  # Если один из профилей в хэше circle - автор. Тогда - видоизменен текст вопроса
        logger.info "2 BIG DEBUG ========================"
        one_question = "Считаете ли вы #{added_relation} #{added_name} - #{which_string_2} #{text_relation}?"
      end
    end

    return one_question
  end
  # Добавляем вопросы в массив вопросов для данного хэша имен names_hash касательно добавляемого нового профиля с именем added_name_id
  # с новым отношением added_relation.
  # При этом в впоросе выясняется истинность отношения text_relation добавленного added_relation к рассматриваемому профилю
  # с отношением profile_relation
  def add_relation_questions(names_hash, added_name_id, added_relation, text_relation, profile_relation)
    logger.info "== in  - add_relation_questions: names_hash = #{names_hash}, added_name_id = #{added_name_id}, added_relation = #{added_relation}, text_relation = #{text_relation}, profile_relation = #{profile_relation}"
    return {} if names_hash.blank?
    if !names_hash.blank?
      names_arr = names_hash.values   # name_id array
      profiles_arr = names_hash.keys  # profile_id array
      inflect_added_relation    = YandexInflect.inflections(added_relation)[3]["__content__"]
      inflect_text_relation     = YandexInflect.inflections(text_relation)[4]["__content__"]
      inflect_profile_relation  = YandexInflect.inflections(profile_relation)[1]["__content__"]
      inflect_added_name        = YandexInflect.inflections(Name.find(added_name_id).name)[3]["__content__"].mb_chars.capitalize
      which_string_1, which_string_2 = words_case_sex_relation(profile_relation, text_relation)
      if !names_arr.blank?
        questions_hash = Hash.new
        for arr_ind in 0 .. names_arr.length - 1
          # one_question = make_one_question(names_arr[arr_ind], @profile_id, profiles_arr[arr_ind], inflect_added_relation, inflect_added_name, inflect_text_relation, inflect_profile_relation, which_string_1, which_string_2)
          one_question = make_one_question(names_arr[arr_ind], @tmp_author_profile_id, profiles_arr[arr_ind], inflect_added_relation, inflect_added_name, inflect_text_relation, inflect_profile_relation, which_string_1, which_string_2)
          # Добавляем один вопрос в хэш вопросов касательно нового отношения
          questions_hash.merge!({profiles_arr[arr_ind] => one_question})
        end
      end
    end
    return questions_hash
  end

  # Генерация вопросов для Автора в создавшихся нестандартных ситуациях.
  # В зависимости от того, какое relation добавляем,
  # заполняются те массивы вопросов, которые следует задавать
  def ask_author_questions(added_relation, added_name_id) # 0
    logger.info "== in - ask_author_questions: added_name_id = #{added_name_id} "
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
        logger.info "== in case 8  - ask_author_questions: added_relation = #{added_relation} "
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Жена", "Мать", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Жена", "Мать", "Дочь"))
      else
        "Неизвестно"
    end
    @non_standard_questions_hash = non_standard_questions_hash   #
    logger.info "== after  - ask_author_questions: non_standard_questions_hash = #{non_standard_questions_hash} "
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
        logger.info "============================== in 3 ask #{@brothers_hash}"
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

  # Генерация вопросов для Мужa/Жены в создавшихся нестандартных ситуациях.
  # В зависимости от того, какое relation добавляем,
  # заполняются те массивы вопросов, которые следует задавать
  def ask_husband_wife_questions(added_relation, added_name_id) # 7,8
    non_standard_questions_hash = Hash.new
    case added_relation
      when 3  # Добавляем Сына к Мужу/Жене
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Сын", "Брат", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Сын", "Брат", "Дочь"))
        non_standard_questions_hash.merge!(add_relation_questions(@wives_hash, added_name_id, "Сын", "Сын", "Жена"))
        non_standard_questions_hash.merge!(add_relation_questions(@husbands_hash, added_name_id, "Сын", "Сын", "Муж"))
        @standard_msg = "Добавляем Сына к Мужу/Жене"
      when 4  # Добавляем Дочь к Мужу/Жене
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Дочь", "Сестра", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Дочь", "Сестра", "Дочь"))
        non_standard_questions_hash.merge!(add_relation_questions(@wives_hash, added_name_id, "Дочь", "Дочь", "Жена"))
        non_standard_questions_hash.merge!(add_relation_questions(@husbands_hash, added_name_id, "Дочь", "Дочь", "Муж"))
        @standard_msg = "Добавляем Дочь к Мужу/Жене"
      when 7  # Добавляем Мужа к Жене
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Муж", "Отец", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Муж", "Отец", "Дочь"))
      when 8  # Добавляем Жену к Мужу
        non_standard_questions_hash.merge!(add_relation_questions(@sons_hash, added_name_id, "Жена", "Мать", "Сын"))
        non_standard_questions_hash.merge!(add_relation_questions(@daughters_hash, added_name_id, "Жена", "Мать", "Дочь"))
      else
        "Неизвестно"
    end
    @non_standard_questions_hash = non_standard_questions_hash   #
  end

  # Формирование массива хэшей ближнего круга
  #  для дальнейшего анализа
  # ПОРЯДОК - ВАЖЕН, Т.К. ОПРЕДЕЛЕН ЗАРАНЕЕ!!
  def make_one_array_of_hashes

    # Тестовый исходный circle_as_hash(user_id, profile_id)
    @fathers_hash = {173 => 45 }
    @mothers_hash = {172 => 235 , 174 => 354 }
    @brothers_hash = {190 => 73, 191 => 66 }
    @sisters_hash = {1000 => 233, 1001 => 16}
    @wives_hash = {155 => 292 }
    @husbands_hash = {194 => 111 }
    @sons_hash = {156 => 151 }
    @daughters_hash = {153 => 212, 157 => 214 }

    one_array_of_circle_hashes = []
    one_array_of_circle_hashes << @fathers_hash
    one_array_of_circle_hashes << @mothers_hash
    one_array_of_circle_hashes << @brothers_hash
    one_array_of_circle_hashes << @sisters_hash
    one_array_of_circle_hashes << @wives_hash
    one_array_of_circle_hashes << @husbands_hash
    one_array_of_circle_hashes << @sons_hash
    one_array_of_circle_hashes << @daughters_hash

    return one_array_of_circle_hashes
  end


  # Редакция хэшей ближнего кругав зависимости от ответов на вопросы
  # в нестандартных ситуациях.
  def circle_hash_reduction(non_standard_answers_hash, one_array_of_hashes)
    non_standard_answers_hash.each do |key, val|
      one_array_of_hashes.each do |one_elem_hash|
        #@one_elem_hash = one_elem_hash # DEBUGG_TO_VIEW
        one_elem_hash.each do |k,v|
          one_elem_hash.delete_if {|k, v| k == key && val == false}
        end
      end
    end
    return one_array_of_hashes
  end

  # Получение обратно хэшей ближнего круга из массива сокращенных хэшей
  # в нестандартных ситуациях.
  # ПОРЯДОК - ВАЖЕН, Т.К. ОПРЕДЕЛЕН ЗАРАНЕЕ!!
  def make_circle_hashes_reduced(one_array_of_reduced_hashes)

    one_array_of_reduced_hashes.each_with_index do |elem, index|
      case index
        when 0
          @fathers_hash = elem
        when 1
          @mothers_hash = elem
        when 2
          @brothers_hash = elem
        when 3
          @sisters_hash = elem
        when 4
          @wives_hash = elem
        when 5
          @husbands_hash = elem
        when 6
          @sons_hash = elem
        when 7
          @daughters_hash = elem
        else
          "Nothing"
      end
    end

    @reduced_fathers_hash = @fathers_hash       # DEBUGG_TO_VIEW
    @reduced_mothers_hash = @mothers_hash       # DEBUGG_TO_VIEW
    @reduced_brothers_hash = @brothers_hash     # DEBUGG_TO_VIEW
    @reduced_sisters_hash = @sisters_hash       # DEBUGG_TO_VIEW
    @reduced_wives_hash = @wives_hash           # DEBUGG_TO_VIEW
    @reduced_husbands_hash = @husbands_hash     # DEBUGG_TO_VIEW
    @reduced_sons_hash = @sons_hash             # DEBUGG_TO_VIEW
    @reduced_daughters_hash = @daughters_hash   # DEBUGG_TO_VIEW

  end





end
