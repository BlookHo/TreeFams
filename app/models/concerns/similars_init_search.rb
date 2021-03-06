module SimilarsInitSearch
  extend ActiveSupport::Concern
  # in User model

  module ClassMethods

    # Метод - модуль вывяления похожих профилей в одном дереве
    # 1. Собираем круги для каждого профиля
    # 2. Сравниваем все круги - находим похожие профили
    # 3. Готовим данные для отображения
    def similars_init_search(tree_info)
      logger.info "In similars_init_search"
      unless tree_info.empty?  # Исходные данные
        tree_circles = get_tree_circles(tree_info) # Получаем круги для каждого профиля в дереве
        # logger.info "In similars_init_search 11111: tree_circles = #{tree_circles}" unless tree_circles.empty?
        compare_tree_circles(tree_info, tree_circles) # Сравниваем все круги на похожесть (совпадение)
        # compare_tree_circles returns similars
      end
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # Получаем круги для каждого профиля в дереве
    def get_tree_circles(tree_info)
      tree_circles = {}
      tree_info[:tree_is_profiles].each do |profile_id|
        tree_circles.merge!( get_profile_circle(profile_id, tree_info[:connected_users]) ) #
      end
      tree_circles
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # Получаем один круг для одного профиля в дереве
    def get_profile_circle(profile_id, connected_users_arr)
      profile_circle = ProfileKey.where(:user_id => connected_users_arr, :profile_id => profile_id, :deleted => 0)
                           .order('relation_id','is_name_id')
                           .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
                           .distinct
      #logger.info "In get_profile_circle1: profile_circle.size = #{profile_circle.size}" if !profile_circle.blank?
      circle_profiles_arr = make_arrays_from_circle(profile_circle)  # Ok
      #logger.info "In get_profile_circle2: circle_profiles_arr = #{circle_profiles_arr}" if !circle_profiles_arr.blank?
      profile_circle_hash = convert_circle_to_hash(circle_profiles_arr)
      #logger.info "In get_profile_circle3: profile_circle_hash = #{profile_circle_hash}" if !profile_circle_hash.empty?
      {profile_id => profile_circle_hash}
    end

    # todo: перенести этот метод в Operational - для нескольких моделей
    # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
    # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
    def make_arrays_from_circle(circle_rows)
      circle_array = []
      circle_rows.each do |row|
        circle_array << row.attributes.except('id','user_id','profile_id','created_at','updated_at')
      end
      circle_array
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
    # input: circle_arr
    # На выходе: profile_circle_hash = {'f1' => 58, 'f2' => 100, 'm1' => 59, 'b1' => 60, 'b2' => 61, 'w1' => 62 }
    def convert_circle_to_hash(circle_arr)
      profile_circle_hash = {}
      circle_arr.each do |one_row_hash|
        # relation_val, is_name_val, is_profile_val = get_row_data(one_row_hash)
        relation_val, is_name_val = get_row_data(one_row_hash)
        code_relation = get_name_relation(relation_val)[:code_relation]
        # Наращиваем круг в виде хэша
        profile_circle_hash = growing_val_arr(profile_circle_hash, code_relation, is_name_val)
      end
      profile_circle_hash
    end

    # todo: перенести этот метод в Operational - для нескольких моделей
    # Наращивание массива значений Хаша для одного ключа
    # Если ключ - новый, то формирование новой пары.
    def growing_val_arr(hash, other_key, other_val )
      hash.keys.include?(other_key) ? hash[other_key] << other_val : hash.merge!({other_key => [other_val]})
      hash
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # МЕТОД Получения Круга профиля в виде Хэша: { профиль => хэш круга }
    def make_profile_circle(profile_id, profile_circle_hash)
      profile_circle = {}
      profile_circle.merge!( profile_id => profile_circle_hash ) unless profile_circle_hash.empty?
      profile_circle
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    def get_row_data(one_row_hash)
      unless one_row_hash.empty?
        relation_val = one_row_hash.values_at('relation_id')[0]
        # is_profile_val = one_row_hash.values_at('is_profile_id')[0]
        is_name_val = one_row_hash.values_at('is_name_id')[0]
      end
      return relation_val, is_name_val #, is_profile_val
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    def get_name_relation(relation_val)
      name_relation = ""
      code_relation = ""
      case relation_val
        when 1
          code_relation = "Отец" #"fat" # father
          name_relation = "Отец"
        when 2
          code_relation = "Мама" #"mot" # mother
          name_relation = "Мама" # mother
        when 3
          code_relation = "Сын" #
          name_relation = "Сын" # son
        when 4
          code_relation = "Дочь" #"dau" # daughter
          name_relation = "Дочь" # daughter
        when 5
          code_relation = "Брат" # brother
          name_relation = "Брат" # brother
        when 6
          code_relation = "Сестра" # sister
          name_relation = "Сестра" # sister
        when 7
          code_relation = "Муж" # husband
          name_relation = "Муж" # husband
        when 8
          code_relation = "Жена" # wife
          name_relation = "Жена" # wife
        when 91
          code_relation = "Дед-о" #"gff" # grand father father
          name_relation = "Дед" # grand father father
        when 92
          code_relation = "Дед-м" #"gfm" # grand father mother
          name_relation = "Дед" # grand father mother
        when 101
          code_relation = "Бабка-о"  #"gmf" # grand mother father
          name_relation = "Бабка" # grand mother father
        when 102
          code_relation = "Бабка-м" #"gmm" # grand mother mother
          name_relation = "Бабка" # grand mother mother
        when 111
          code_relation = "Внук-о" # grand son father - внук
          name_relation = "Внук" # grand son father - внук
        when 112
          code_relation = "Внук-м" #
          name_relation = "Внук" # grand son mother - внук
        when 121
          code_relation = "Внучка-о" #
          name_relation = "Внучка" # grand daughter father - внучка по отцу
        when 122
          code_relation = "Внучка-м" #
          name_relation = "Внучка" # grand daughter mother - внучка по матери
        when 13
          code_relation = "Свекор" #
          name_relation = "Свекор" # husband father-in-law - свекор
        when 14
          code_relation = "Свекровь" #
          name_relation = "свекровь" # husband mother-in-law - свекровь
        when 15
          code_relation = "Тесть" #
          name_relation = "Тесть" # wife father-in-law - тесть
        when 16
          code_relation = "Теща" #
          name_relation = "Теща" # wife mother-in-law - теща
        when 17
          code_relation = "Невестка" #
          name_relation = "Невестка" # daughter-in-law - невестка
        when 18
          code_relation = "Зять" #
          name_relation = "Зять" # son-in-law - зять
        when 191
          code_relation = "Дядя-о" #
          name_relation = "Дядя" # uncle father - дядя по отцу
        when 192
          code_relation = "Дядя-м" #
          name_relation = "Дядя" # uncle mother - дядя по матери
        when 201
          code_relation = "Тетя-о" #
          name_relation = "Тетя" # aunt father - тетя по отцу
        when 202
          code_relation = "Тетя-м" #
          name_relation = "Тетя" # aunt mother - тетя по матери
        when 211
          code_relation = "Племянник-о" #
          name_relation = "Племянник" # nephew father - племянник по отцу
        when 212
          code_relation = "Племянник-м" #
          name_relation = "Племянник" # nephew mother - племянник по матери
        when 221
          code_relation = "Племянница-о" #
          name_relation = "Племянница" # niece father - племянница по отцу
        when 222
          code_relation = "Племянница-м" #
          name_relation = "Племянница" # niece father - племянница по матери

        else
          # logger.info "ERROR: No relation_id in Circle "
          flash.now[:alert] = "Alert from server! В круге профиля - отсутствует <relation_val>. "
      end

      { code_relation: code_relation, name_relation: name_relation  }

    end


    # Служебный метод для отладки - для LOGGER
    # todo: перенести этот метод в Operational - для нескольких моделей
    # Показывает массив в logger
    def show_in_logger(arr_to_log, string_to_add)
      row_no = 0  # DEBUGG_TO_LOGG
      arr_to_log.each do |row| # DEBUGG_TO_LOGG
        row_no += 1
        logger.debug "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
      end  # DEBUGG_TO_LOGG
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # Вычисление мощности общей части (пересечения) хэшей кругов профилей
    # т.е. по скольким отношениям они (профили) - совпадают
    def common_circle_power(common_hash)
      common_power = 0
      common_hash.each { |k,v| common_power = common_power + v.size }
      common_power
    end

    # Сравниваем все круги на похожесть (совпадение)
    # compare_tree_circles returns similars
    def compare_tree_circles(tree_info, tree_circles)

      # logger.info "In compare_tree_circles 1: tree_circles = #{tree_circles}" if !tree_circles.empty?
      # logger.info "In compare_tree_circles 2: tree_circles.size = #{tree_circles.size}" if !tree_circles.empty?

      profiles_arr = tree_info[:tree_is_profiles]
      # logger.info "In compare_tree_circles 3: profiles_arr = #{profiles_arr}" if !profiles_arr.blank?

      profiles = tree_info[:profiles]     # from tree
      # logger.info "==== In compare_tree_circles 4: profiles = #{profiles}" if !profiles.blank?

      # Перебор по парам профилей (неповторяющимся) с целью выявления похожих профилей
      similars = [] # Похожие - РЕЗУЛЬТАТ

      c =0  # count different profiles pairs DEBUG
      IDArray.each_pair(profiles_arr) { |a_profile_id, b_profile_id|
        (
        # c = c + 1;logger.info "In compare_tree_circles ITERATION = #{c}: one_profile_id: #{a_profile_id} - b_profile_id: #{b_profile_id}"

        data_a_to_compare = [profiles[a_profile_id][:is_name_id], profiles[a_profile_id][:is_sex_id]]
        data_b_to_compare = [profiles[b_profile_id][:is_name_id], profiles[b_profile_id][:is_sex_id]]

        if data_a_to_compare == data_b_to_compare
          # logger.info "*** compare profiles: data_a_to_compare (is_name, is_sex): #{data_a_to_compare},  - data_b_to_compare: #{data_b_to_compare}"
          # сравниваемые хэши кругов профилей и определение их общей части кругов профилей
          common_hash = intersection(tree_circles[a_profile_id], tree_circles[b_profile_id])
          logger.info "*** compare profiles: one_profile_id = #{a_profile_id}: #{data_a_to_compare} <--> b_profile_id = #{b_profile_id}: #{data_b_to_compare}"
          # logger.info "*** compare hashes: tree_circles[a_profile_id]: #{tree_circles[a_profile_id]}"
          # logger.info "*** compare hashes: tree_circles[b_profile_id]: #{tree_circles[b_profile_id]}"
          logger.info "*** common_hash: #{common_hash}"
          # logger.info "*** compare hashes: common_hash: #{common_hash}"
          # logger.warn "*** compare hashes: common_hash: #{common_hash}"
          # logger.error "*** compare hashes: common_hash: #{common_hash}"
          # logger.fatal "*** compare hashes: common_hash: #{common_hash}"
          # logger.unknown "*** compare hashes: common_hash: #{common_hash}"

          unless common_hash.empty?

            data_for_check = { a_profile_circle:  tree_circles[a_profile_id],
                               b_profile_circle:  tree_circles[b_profile_id],
                               common_hash:  common_hash  }

            ############ call of User.module ############################################
            unsimilar_sign, inter_relations = check_similars_exclusions(data_for_check)
            #############################################################################
            # Проверка условия исключения похожести
            if unsimilar_sign #
              # Если признак непохожести = true
              # значит эта пара профилей - точно НЕПОХОЖИЕ
              # по признаку - есть необщие отношения, которые не могут отличаться у одного и того же чела
              # Должны совпадать обязательно: отцы, матери, деды, бабки
              # все остальные отношения могут отличаться (сыны, жены, братья и т.д.)
              # Если признак непохожести = false, то можно и не вычислять мощность общности совпавших отношений
              # т.к. два сравниваемых профиля - заведомо различные несмотря на совпадения других их отношений (многодетные семьи).

              # Вычисление мощности общей части кругов профилей
              common_power = common_circle_power(common_hash)
              # Занесение в результат тех пар профилей, у кот. мощность совпадения больше коэфф-та достоверности

              #############################################################
              # certain_koeff_for_connect ||= WeafamSetting.first.certain_koeff
              certain_koeff_for_connect = CERTAIN_KOEFF
              #############################################################

              if common_power >= certain_koeff_for_connect
                common_data =
                    { first_profile_id:  a_profile_id,
                      profile_a_data:  profiles[a_profile_id],
                      second_profile_id:  b_profile_id,
                      profile_b_data:  profiles[b_profile_id],
                      common_hash:  common_hash,
                      common_power:  common_power,
                      inter_relations:  inter_relations
                    }

                one_similars_pair = get_similars_data(common_data)
                similars << one_similars_pair unless one_similars_pair.empty?  # Похожие - РЕЗУЛЬТАТ
              end

            end

          end

        end
        ) }

      logger.info "After compare_tree_circles : similars = #{similars}"
      logger.info "similars.size = #{similars.size}" unless similars.empty?

      similars
    end


    # Формирование данных об одной паре похожих профилей для отображения в view
    def get_similars_data(common_data)

      one_similars_pair = {}

      one_similars_pair.merge!(:first_profile_id => common_data[:first_profile_id])
      one_similars_pair.merge!(:first_name_id => get_name(common_data[:first_profile_id]))
      one_similars_pair.merge!(:first_relation_id => get_name_relation(common_data[:profile_a_data][:relation_id])[:name_relation] ) #common_data[:profile_a_data][:relation_id])
      one_similars_pair.merge!(:name_first_relation_id => inflect_name(get_name(common_data[:profile_a_data][:profile_id]), 1))

      common_data[:profile_a_data][:is_sex_id] == 1 ? sex_a = 'М' : sex_a = 'Ж'
      one_similars_pair.merge!(:first_sex_id => sex_a)

      one_similars_pair.merge!(:second_profile_id => common_data[:second_profile_id])
      one_similars_pair.merge!(:second_name_id => get_name(common_data[:second_profile_id]))
      one_similars_pair.merge!(:second_relation_id => get_name_relation(common_data[:profile_b_data][:relation_id])[:name_relation] ) #
      one_similars_pair.merge!(:name_second_relation_id => inflect_name(get_name(common_data[:profile_b_data][:profile_id]), 1))

      common_data[:profile_b_data][:is_sex_id] == 1 ? sex_b = 'М' : sex_b = 'Ж'
      one_similars_pair.merge!(:second_sex_id => sex_b)

      display_commoin_relations = create_display_common(common_data[:common_hash])
      one_similars_pair.merge!(:common_relations => display_commoin_relations)
      one_similars_pair.merge!(:common_power => common_data[:common_power])
      one_similars_pair.merge!(:inter_relations => common_data[:inter_relations])

      one_similars_pair
    end


    # todo: перенести этот метод в SimilarsHelper - для нескольких моделей
    # Формируем отображение для View Общих отношений 2-х профилей, кот-е Похожие
    def create_display_common(common_hash)

      display_common_relations = common_hash

      logger.info "In  self.make_view_data: display_common_relations.size = #{display_common_relations.size}" if !display_common_relations.empty?
      return display_common_relations
    end


    # todo: перенести этот метод в Operational - для нескольких моделей
    # Извлечение имени профиля
    def get_name(profile_id)
      #profile = Profile.find(profile_id)
      #name_id = profile.name_id
      #Name.find(name_id).name
      Name.find(Profile.find(profile_id).name_id).name
    end

    # todo: перенести этот метод в CommonViewHelper - для нескольких моделей
    # Склонение имени по падежу == padej
    def inflect_name(text_data_name, padej)
      text_data_name != "" ? inflected_name = YandexInflect.inflections(text_data_name)[padej]["__content__"] : inflected_name = ""
      inflected_name
    end

    # todo: перенести этот метод в Operational - для нескольких моделей
    # пересечение 2-х хэшей, у которых - значения = массивы
    def intersection(first, other)
      result = {}
      first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
        intersect = other[k] & v
        result.merge!({k => intersect}) unless intersect.blank?
      end
      result
    end



  end


end