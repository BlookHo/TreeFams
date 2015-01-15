module SimilarsInitSearch
  extend ActiveSupport::Concern
  # in User model

  module ClassMethods

    # Метод - модуль вывяления похожих профилей в одном дереве
    # 1. Собираем круги для каждого профиля
    # 2. Сравниваем все круги - находим похожие профили
    # 3. Готовим данные для отображения
    def similars_init_search(tree_info)
      if !tree_info.empty?  # Исходные данные
        tree_circles = get_tree_circles(tree_info) # Получаем круги для каждого профиля в дереве
        #logger.info "In search_similars 1: tree_circles = #{tree_circles}" if !tree_circles.empty?
        #logger.info "In search_similars 2: tree_circles.size = #{tree_circles.size}" if !tree_circles.empty?
        similars, unsimilars = compare_tree_circles(tree_info, tree_circles) # Сравниваем все круги на похожесть (совпадение)
        return similars, unsimilars
      end
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # Получаем круги для каждого профиля в дереве
    #def self.get_tree_circles(tree_info)
    def get_tree_circles(tree_info)
      tree_circles = {}
      tree_info[:tree_is_profiles].each do |profile_id|
        tree_circles.merge!( get_profile_circle(profile_id, tree_info[:connected_users]) ) # if !profile_circle_hash.empty?
      end
      return tree_circles
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # Получаем один круг для одного профиля в дереве
    def get_profile_circle(profile_id, connected_users_arr)
      profile_circle = ProfileKey.where(:user_id => connected_users_arr, :profile_id => profile_id).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
      #logger.info "In get_profile_circle1: profile_circle.size = #{profile_circle.size}" if !profile_circle.blank?
      circle_profiles_arr = make_arrays_from_circle(profile_circle)  # Ok
      #logger.info "In get_profile_circle2: circle_profiles_arr = #{circle_profiles_arr}" if !circle_profiles_arr.blank?
      profile_circle_hash = convert_circle_to_hash(circle_profiles_arr)
      #logger.info "In get_profile_circle3: profile_circle_hash = #{profile_circle_hash}" if !profile_circle_hash.empty?
      return profile_id => profile_circle_hash
    end

    # todo: перенести этот метод в Operational - для нескольких моделей
    # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
    # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
    def make_arrays_from_circle(circle_rows)
      circle_array = []
      circle_rows.each do |row|
        circle_array << row.attributes.except('id','user_id','profile_id','created_at','updated_at')
      end
      return circle_array
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
    # input: circle_arr
    # На выходе: profile_circle_hash = {'f1' => 58, 'f2' => 100, 'm1' => 59, 'b1' => 60, 'b2' => 61, 'w1' => 62 }
    def convert_circle_to_hash(circle_arr)
      profile_circle_hash = {}
      circle_arr.each do |one_row_hash|
        relation_val, is_name_val, is_profile_val = get_row_data(one_row_hash)
        code_relation = get_name_relation(relation_val)[:code_relation]
        # Наращиваем круг в виде хэша
        profile_circle_hash = growing_val_arr(profile_circle_hash, code_relation, is_name_val)
      end
      return profile_circle_hash
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
      profile_circle.merge!( profile_id => profile_circle_hash )  if !profile_circle_hash.empty?
      return profile_circle
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    def get_row_data(one_row_hash)
      if !one_row_hash.empty?
        relation_val = one_row_hash.values_at('relation_id')[0]
        is_profile_val = one_row_hash.values_at('is_profile_id')[0]
        is_name_val = one_row_hash.values_at('is_name_id')[0]
      end
      return relation_val, is_name_val, is_profile_val
    end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # No use
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
          logger.info "ERROR: No relation_id in Circle "
      end

      { code_relation: code_relation,
        name_relation: name_relation
      }

    end

    # todo: уточнить необходимость и место исп-я
    # todo: перенести этот метод в Operational - для нескольких моделей
    # No use
    # Получаем новое имя отношения в хэш круга
    #def get_new_elem_name(circle_keys_arr, name_relation)
    #  name_qty = name_next_qty(circle_keys_arr, name_relation)
    #  new_name = name_relation.concat(name_qty.to_s)
    #  #logger.info "In get_new_elem_name: new_name = #{new_name} "
    #  return new_name
    #end

    # todo: перенести этот метод в CirclesMethods - для нескольких моделей
    # No use
    # Получаем кол-во для нового имени отношения в хэш круга
    # длина имени отношения - 3 символа. можно изменить в: one_name_key[0, 3 ]
    #def name_next_qty(circle_keys_arr, name_relation)
    #  name_qty = 0
    #  circle_keys_arr.each do |one_name_key|
    #    name_qty += 1 if one_name_key[0,3] == name_relation
    #  end
    #  name_qty += 1
    #  return name_qty
    #end

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
    def compare_tree_circles(tree_info, tree_circles)

      # tree_circles =    # test 1 Алексей
      {27=>{"Сын"=>[122], "Жена"=>[449], "Невестка"=>[82], "Внук"=>[28]},
       13=>{"Отец"=>[122], "Мама"=>[82], "Сын"=>[370, 465], "Жена"=>[48], "Тесть"=>[343], "Теща"=>[82], "Невестка"=>[147], "Дед-о"=>[90], "Бабка-о"=>[449], "Внучка-о"=>[446]},
       11=>{"Отец"=>[28], "Мама"=>[48], "Дочь"=>[446], "Брат"=>[465], "Жена"=>[147], "Тесть"=>[110], "Теща"=>[97], "Дед-о"=>[122], "Дед-м"=>[343], "Бабка-о"=>[82], "Бабка-м"=>[82], "Тетя-м"=>[331]},
       10=>{"Отец"=>[343], "Мама"=>[82], "Сестра"=>[48], "Племянник-м"=>[370, 465]},

       28=>{"Сын"=>[122], "Муж"=>[90], "Невестка"=>[82], "Внук"=>[28],              "Свекровь"=>[480], "Дочь"=>[3420]  ,"Отец"=>[343], "Мама"=>[82]  },   # from balda

       ########################
       35=>{"Сын"=>[122], "Муж"=>[90], "Невестка"=>[82], "Внук"=>[28],         "Свекор"=>[28,35], "Свекровь"=>[490, 49], "Дочь"=>[340]  },  # from balda
       ########################

       61=>{"Отец"=>[110], "Мама"=>[97], "Дочь"=>[446], "Муж"=>[370], "Свекор"=>[28], "Свекровь"=>[48]},
       66=>{"Дочь"=>[147], "Муж"=>[110], "Зять"=>[370], "Внучка-м"=>[446]},

       9=>{"Дочь"=>[48, 331], "Муж"=>[343], "Зять"=>[28], "Внук-м"=>[370, 465]},

       65=>{"Дочь"=>[147], "Жена"=>[97], "Зять"=>[370], "Внучка-м"=>[446]},
       7=>{"Отец"=>[343], "Мама"=>[82], "Сын"=>[370, 465], "Сестра"=>[331], "Муж"=>[28], "Свекор"=>[122], "Свекровь"=>[82], "Невестка"=>[147], "Внучка-о"=>[446]},

       3=>{"Сын"=>[28], "Муж"=>[122], "Свекор"=>[90], "Свекровь"=>[449], "Невестка"=>[48], "Внук"=>[370, 465]},

       12=>{"Отец"=>[28], "Мама"=>[48], "Брат"=>[370], "Дед-о"=>[122], "Дед-м"=>[343], "Бабка-о"=>[82], "Бабка-м"=>[82], "Тетя-м"=>[331], "Племянница-м"=>[446]},
       63=>{"Отец"=>[370], "Мама"=>[147], "Дед-о"=>[28], "Дед-м"=>[110], "Бабка-о"=>[48], "Бабка-м"=>[97], "Дядя-о"=>[465]},
       8=>{"Дочь"=>[48, 331], "Жена"=>[82], "Зять"=>[28], "Внук-м"=>[370, 465]},
       2=>{"Отец"=>[90], "Мама"=>[449], "Сын"=>[28], "Жена"=>[82], "Невестка"=>[48], "Внук"=>[370, 465]}}


      #  tree_circles =      # from tree 8
      {84=>{"Сын"=>[523], "Жена"=>[528], "Невестка"=>[529], "Внук"=>[522, 524, 525], "Внучка-о"=>[530, 531]},
       81=>{"Отец"=>[523], "Мама"=>[529], "Брат"=>[522, 524, 525], "Сестра"=>[530], "Дед-о"=>[526], "Бабка-о"=>[528]},
       89=>{"Отец"=>[523], "Мама"=>[533], "Брат"=>[524, 525], "Сестра"=>[530, 532]},
       79=>{"Отец"=>[523], "Мама"=>[529], "Брат"=>[522, 525], "Сестра"=>[530, 531], "Дед-о"=>[526], "Бабка-о"=>[528]},
       82=>{"Отец"=>[523], "Мама"=>[529], "Брат"=>[522, 524, 525], "Сестра"=>[531], "Дед-о"=>[526], "Бабка-о"=>[528]},
       88=>{"Отец"=>[523], "Мама"=>[533], "Брат"=>[524], "Сестра"=>[530, 531, 532]},
       77=>{"Отец"=>[526], "Мама"=>[528], "Сын"=>[522, 524, 525], "Дочь"=>[530, 531], "Жена"=>[529], "Невестка"=>[532]},
       80=>{"Отец"=>[523], "Мама"=>[529], "Брат"=>[522, 524], "Сестра"=>[530, 531], "Дед-о"=>[526], "Бабка-о"=>[528]},
       85=>{"Сын"=>[523], "Муж"=>[526], "Невестка"=>[529], "Внук"=>[522, 524, 525], "Внучка-о"=>[530, 531]},
       87=>{"Отец"=>[523], "Мама"=>[533], "Брат"=>[524, 525], "Сестра"=>[531, 532]},
       92=>{"Сын"=>[524, 525], "Дочь"=>[530, 531, 532], "Муж"=>[523], "Зять"=>[522]},
       86=>{"Отец"=>[523], "Мама"=>[533], "Брат"=>[525], "Сестра"=>[530, 531, 532]},
       83=>{"Отец"=>[523], "Мама"=>[533], "Брат"=>[524, 525], "Сестра"=>[530, 531], "Муж"=>[522], "Свекор"=>[523], "Свекровь"=>[529]},
       78=>{"Сын"=>[522, 524, 525], "Дочь"=>[530, 531], "Муж"=>[523], "Свекор"=>[526], "Свекровь"=>[528], "Невестка"=>[532]},
       91=>{"Сын"=>[524, 525], "Дочь"=>[530, 531, 532], "Жена"=>[533], "Зять"=>[522]}}

      logger.info "In compare_tree_circles 1: tree_circles = #{tree_circles}" if !tree_circles.empty?
      logger.info "In compare_tree_circles 2: tree_circles.size = #{tree_circles.size}" if !tree_circles.empty?

      profiles_arr = tree_info[:tree_is_profiles]
      #  profiles_arr =
      [27, 13, 11, 10, 28,  35,   61, 66, 9, 65, 7, 3, 12, 63, 8, 2] # from tree 1
      #  profiles_arr =

      [84, 81, 89, 79, 82, 88, 77, 80, 85, 87, 92, 86, 83, 78, 91]  # from tree 8

      logger.info "In compare_tree_circles 3: profiles_arr = #{profiles_arr}" if !profiles_arr.blank?

      profiles = tree_info[:profiles]     # from tree
      #  profiles =   # test # from tree 1
      {27=>{:is_name_id=>90, :is_sex_id=>1, :profile_id=>2, :relation_id=>1},
       13=>{:is_name_id=>28, :is_sex_id=>1, :profile_id=>7, :relation_id=>7},
       11=>{:is_name_id=>370, :is_sex_id=>1, :profile_id=>7, :relation_id=>3},
       10=>{:is_name_id=>331, :is_sex_id=>0, :profile_id=>7, :relation_id=>6},
       28=>{:is_name_id=>449, :is_sex_id=>0, :profile_id=>2, :relation_id=>2},

       35=>{:is_name_id=>449, :is_sex_id=>0, :profile_id=>7, :relation_id=>3}, # from balda


       61=>{:is_name_id=>147, :is_sex_id=>0, :profile_id=>11, :relation_id=>8},
       66=>{:is_name_id=>97, :is_sex_id=>0, :profile_id=>61, :relation_id=>2},

       9=>{:is_name_id=>82, :is_sex_id=>0, :profile_id=>7, :relation_id=>2},

       65=>{:is_name_id=>110, :is_sex_id=>1, :profile_id=>61, :relation_id=>1},
       7=>{:is_name_id=>48, :is_sex_id=>0, :profile_id=>13, :relation_id=>8},

       3=>{:is_name_id=>82, :is_sex_id=>0, :profile_id=>13, :relation_id=>2},

       12=>{:is_name_id=>465, :is_sex_id=>1, :profile_id=>7, :relation_id=>3},
       63=>{:is_name_id=>446, :is_sex_id=>0, :profile_id=>11, :relation_id=>4},
       8=>{:is_name_id=>343, :is_sex_id=>1, :profile_id=>7, :relation_id=>1},
       2=>{:is_name_id=>122, :is_sex_id=>1, :profile_id=>13, :relation_id=>1}}


      #  profiles =   # test # from tree 8
      {84=>{:is_name_id=>526, :is_sex_id=>1, :profile_id=>77, :relation_id=>1},
       81=>{:is_name_id=>531, :is_sex_id=>0, :profile_id=>76, :relation_id=>6},
       89=>{:is_name_id=>531, :is_sex_id=>0, :profile_id=>83, :relation_id=>6},
       79=>{:is_name_id=>524, :is_sex_id=>1, :profile_id=>76, :relation_id=>5},
       82=>{:is_name_id=>530, :is_sex_id=>0, :profile_id=>76, :relation_id=>6},
       88=>{:is_name_id=>525, :is_sex_id=>1, :profile_id=>83, :relation_id=>5},
       77=>{:is_name_id=>523, :is_sex_id=>1, :profile_id=>76, :relation_id=>1},
       80=>{:is_name_id=>525, :is_sex_id=>1, :profile_id=>76, :relation_id=>5},
       85=>{:is_name_id=>528, :is_sex_id=>0, :profile_id=>77, :relation_id=>2},
       87=>{:is_name_id=>530, :is_sex_id=>0, :profile_id=>83, :relation_id=>6},
       92=>{:is_name_id=>533, :is_sex_id=>0, :profile_id=>83, :relation_id=>2},
       86=>{:is_name_id=>524, :is_sex_id=>1, :profile_id=>83, :relation_id=>5},
       83=>{:is_name_id=>532, :is_sex_id=>0, :profile_id=>76, :relation_id=>8},
       78=>{:is_name_id=>529, :is_sex_id=>0, :profile_id=>76, :relation_id=>2},
       91=>{:is_name_id=>523, :is_sex_id=>1, :profile_id=>83, :relation_id=>1}}


      logger.info "==== In compare_tree_circles 4: profiles = #{profiles}" if !profiles.blank?


      # Перебор по парам профилей (неповторяющимся) с целью выявления похожих профилей
      similars = [] # Похожие - РЕЗУЛЬТАТ
      unsimilars = [] # НЕ Похожие - параллельный РЕЗУЛЬТАТ

      c =0  # count different profiles pairs
      IDArray.each_pair(profiles_arr) { |a_profile_id, b_profile_id|
        (
        logger.info "In compare_tree_circles 6: one_profile_id: #{a_profile_id} - b_profile_id: #{b_profile_id}"
        c = c + 1; logger.info " c = #{c} "

        data_a_to_compare = [profiles[a_profile_id][:is_name_id], profiles[a_profile_id][:is_sex_id]]
        data_b_to_compare = [profiles[b_profile_id][:is_name_id], profiles[b_profile_id][:is_sex_id]]

        if data_a_to_compare == data_b_to_compare
          logger.info "*** In compare_tree_circles 71: data_a_to_compare: #{data_a_to_compare},  - data_b_to_compare: #{data_b_to_compare}"
          # сравниваемые хэши кругов профилей и определение их общей части кругов профилей
          common_hash = intersection(tree_circles[a_profile_id], tree_circles[b_profile_id])
          logger.info "*** In compare_tree_circles 72a: tree_circles[a_profile_id]: #{tree_circles[a_profile_id]}"
          logger.info "*** In compare_tree_circles 72b: tree_circles[b_profile_id]: #{tree_circles[b_profile_id]}"
          logger.info "*** In compare_tree_circles 72: common_hash: #{common_hash}"

          if !common_hash.empty?

            data_for_check = {
                a_profile_circle:  tree_circles[a_profile_id],
                b_profile_circle:  tree_circles[b_profile_id],
                common_hash:  common_hash
            }

            ############ call of User.module ############################################
            unsimilar_sign, inter_relations = check_similars_exclusions(data_for_check)
            #############################################################################
          #  unsimilar_sign = true
            # Проверка условия исключения похожести
            if unsimilar_sign #check_similars_exclusion(data_for_check)

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
              certain_koeff_for_connect ||= WeafamSetting.first.certain_koeff
             # certain_koeff_for_connect = 3
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

                #profiles_pair = [a_profile_id, b_profile_id]
                #if !unsimilars.include?(profiles_pair)
                one_similars_pair = get_similars_data(common_data)
                similars << one_similars_pair if !one_similars_pair.empty?  # Похожие - РЕЗУЛЬТАТ
                #
                #else
                #  unsimilars = collect_unsimilars(a_profile_id, b_profile_id, unsimilars)
                #end

                #else
                #  unsimilars = collect_unsimilars(a_profile_id, b_profile_id, unsimilars)
              end

              #else
              #  unsimilars = collect_unsimilars(a_profile_id, b_profile_id, unsimilars)
            end

            #else
            #  unsimilars = collect_unsimilars(a_profile_id, b_profile_id, unsimilars)
          end

          #else
          #  unsimilars = collect_unsimilars(a_profile_id, b_profile_id, unsimilars)

        end
        ) }

      logger.info "In compare_tree_circles 9: similars = #{similars}"
      logger.info "In compare_tree_circles 10: similars.size = #{similars.size}" if !similars.empty?

      return similars, unsimilars
    end

    # No use
    def self.collect_unsimilars(a_profile_id, b_profile_id, unsimilars)
      unsimilars << [a_profile_id, b_profile_id]
      logger.info "In compare_tree_circles 8: unsimilars = #{unsimilars}"
      unsimilars
    end


    # Формирование данных об одной паре похожих профилей для отображения в view
    def get_similars_data(common_data)

      one_similars_pair = {}

      one_similars_pair.merge!(:first_profile_id => common_data[:first_profile_id])
      one_similars_pair.merge!(:first_relation_id => get_name_relation(common_data[:profile_a_data][:relation_id])[:name_relation] ) #common_data[:profile_a_data][:relation_id])

      one_similars_pair.merge!(:name_first_relation_id => inflect_name(get_name(common_data[:profile_a_data][:profile_id]), 1))
      #    one_similars_pair.merge!(:name_first_relation_id => ProfileKey.inflect_name(get_name(common_data[:profile_a_data][:profile_id]), 1))
      one_similars_pair.merge!(:first_name_id => get_name(common_data[:first_profile_id]))

      common_data[:profile_a_data][:is_sex_id] == 1 ? sex_a = 'М' : sex_a = 'Ж'
      one_similars_pair.merge!(:first_sex_id => sex_a)

      one_similars_pair.merge!(:second_profile_id => common_data[:second_profile_id])
      one_similars_pair.merge!(:second_relation_id => get_name_relation(common_data[:profile_b_data][:relation_id])[:name_relation] ) #

      one_similars_pair.merge!(:name_second_relation_id => inflect_name(get_name(common_data[:profile_b_data][:profile_id]), 1))
      one_similars_pair.merge!(:second_name_id => get_name(common_data[:second_profile_id]))

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
        result.merge!({k => intersect}) if !intersect.blank?
      end
      result
    end



  end


end