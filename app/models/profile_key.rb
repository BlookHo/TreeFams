class ProfileKey < ActiveRecord::Base
  include ProfileKeysGeneration

 # include SimilarsInitSearch # методы поиска стартовых пар похожих
 # include SimilarsExclusions # методы учета отношений исключений

  include SearchHelper

  belongs_to :profile#, dependent: :destroy
  belongs_to :is_profile, foreign_key: :is_profile_id, class_name: Profile
  belongs_to :user
  belongs_to :name, foreign_key: :is_name_id
  belongs_to :display_name, class_name: Name, foreign_key: :is_display_name_id
  belongs_to :relation, primary_key: :relation_id


  def full_name
    [self.display_name.name, self.is_profile.last_name].join(' ')
  end

  # todo: перенести этот метод в Operational - для нескольких моделей
  # пересечение 2-х хэшей, у которых - значения = массивы
  def self.intersection(first, other)
    result = {}
    first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
      intersect = other[k] & v
      result.merge!({k => intersect}) if !intersect.blank?
    end
    result
  end

  # todo: перенести этот метод в Operational - для нескольких моделей
  # пересечение 2-х хэшей, у которых - значения = массивы
  def self.unintersection(first, other)
    result = {}
    first.reject { |k, v| (other.include?(k)) }.each do |k, v|
     # intersect = other[k] & v
      result.merge!({k => v}) #if !intersect.blank?
    end
    result
  end

  # Наращивание массива значений Хаша для одного ключа
  # Если ключ - новый, то формирование новой пары.
  def self.growing_val_arr(hash, other_key, other_val )
    hash.keys.include?(other_key) ? hash[other_key] << other_val : hash.merge!({other_key => [other_val]})
    hash
  end

  # Метод - модуль вывяления похожих профилей в одном дереве
  # 1. Собираем круги для каждого профиля
  # 2. Сравниваем все круги - находим похожие профили
  # 3. Готовим данные для отображения
  def self.search_similars(tree_info)
    if !tree_info.empty?  # Исходные данные
      tree_circles = get_tree_circles(tree_info) # Получаем круги для каждого профиля в дереве
      #logger.info "In search_similars 1: tree_circles = #{tree_circles}" if !tree_circles.empty?
      #logger.info "In search_similars 2: tree_circles.size = #{tree_circles.size}" if !tree_circles.empty?
      similars = compare_tree_circles(tree_info, tree_circles) # Сравниваем все круги на похожесть (совпадение)
      return similars
    end
  end

  # Получаем круги для каждого профиля в дереве
  #def self.get_tree_circles(tree_info)
  def self.get_tree_circles(tree_info)
    tree_circles = {}
    tree_info[:tree_is_profiles].each do |profile_id|
      tree_circles.merge!( get_profile_circle(profile_id, tree_info[:connected_users]) ) # if !profile_circle_hash.empty?
    end
    return tree_circles
  end

  # Получаем один круг для одного профиля в дереве
  def self.get_profile_circle(profile_id, connected_users_arr)
    profile_circle = ProfileKey.where(:user_id => connected_users_arr, :profile_id => profile_id).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
    #logger.info "In get_profile_circle1: profile_circle.size = #{profile_circle.size}" if !profile_circle.blank?
    circle_profiles_arr = make_arrays_from_circle(profile_circle)  # Ok
    #logger.info "In get_profile_circle2: circle_profiles_arr = #{circle_profiles_arr}" if !circle_profiles_arr.blank?
    profile_circle_hash = convert_circle_to_hash(circle_profiles_arr)
    #logger.info "In get_profile_circle3: profile_circle_hash = #{profile_circle_hash}" if !profile_circle_hash.empty?
    return profile_id => profile_circle_hash
  end

  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  def self.make_arrays_from_circle(circle_rows)
    circle_array = []
    circle_rows.each do |row|
      circle_array << row.attributes.except('id','user_id','profile_id','created_at','updated_at')
    end
    return circle_array
  end

  # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
  # input: circle_arr
  # На выходе: profile_circle_hash = {'f1' => 58, 'f2' => 100, 'm1' => 59, 'b1' => 60, 'b2' => 61, 'w1' => 62 }
  def self.convert_circle_to_hash(circle_arr)
    profile_circle_hash = {}
    circle_arr.each do |one_row_hash|
      relation_val, is_name_val, is_profile_val = get_row_data(one_row_hash)
      name_relation = get_name_relation(relation_val)[:code_relation]
      # Наращиваем круг в виде хэша
      profile_circle_hash = growing_val_arr(profile_circle_hash, name_relation, is_name_val)
    end
    return profile_circle_hash
  end

  # МЕТОД Получения Круга профиля в виде Хэша: { профиль => хэш круга }
  def self.make_profile_circle(profile_id, profile_circle_hash)
    profile_circle = {}
    profile_circle.merge!( profile_id => profile_circle_hash )  if !profile_circle_hash.empty?
    return profile_circle
  end

  def self.get_row_data(one_row_hash)
    if !one_row_hash.empty?
      relation_val = one_row_hash.values_at('relation_id')[0]
      is_profile_val = one_row_hash.values_at('is_profile_id')[0]
      is_name_val = one_row_hash.values_at('is_name_id')[0]
    end
    return relation_val, is_name_val, is_profile_val
  end

  # No use
  def self.get_name_relation(relation_val)
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
        code_relation = "bro" # brother
        name_relation = "брат" # brother
      when 6
        code_relation = "sis" # sister
        name_relation = "сестра" # sister
      when 7
        code_relation = "hus" # husband
        name_relation = "муж" # husband
      when 8
        code_relation = "wif" # wife
        name_relation = "жена" # wife
      when 91
        code_relation = "Дед-о" #"gff" # grand father father
        name_relation = "дед" # grand father father
      when 92
        code_relation = "Дед-м" #"gfm" # grand father mother
        name_relation = "дед" # grand father mother
      when 101
        code_relation = "Бабка-о"  #"gmf" # grand mother father
        name_relation = "бабка" # grand mother father
      when 102
        code_relation = "Бабка-м" #"gmm" # grand mother mother
        name_relation = "бабка" # grand mother mother
      when 111
        code_relation = "gsf" # grand son father - внук
        name_relation = "внук" # grand son father - внук
      when 112
        code_relation = "gsm" #
        name_relation = "внук" # grand son mother - внук
      when 121
        code_relation = "gdf" #
        name_relation = "внучка" # grand daughter father - внучка по отцу
      when 122
        code_relation = "gdm" #
        name_relation = "внучка" # grand daughter mother - внучка по матери
      when 13
        code_relation = "hfl" #
        name_relation = "свекор" # husband father-in-law - свекор
      when 14
        code_relation = "hml" #
        name_relation = "свекровь" # husband mother-in-law - свекровь
      when 15
        code_relation = "wfl" #
        name_relation = "тесть" # wife father-in-law - тесть
      when 16
        code_relation = "wml" #
        name_relation = "теща" # wife mother-in-law - теща
      when 17
        code_relation = "dil" #
        name_relation = "невестка" # daughter-in-law - невестка
      when 18
        code_relation = "sil" #
        name_relation = "зять" # son-in-law - зять
      when 191
        code_relation = "ufa" #
        name_relation = "дядя" # uncle father - дядя по отцу
      when 192
        code_relation = "umo" #
        name_relation = "дядя" # uncle mother - дядя по матери
      when 201
        code_relation = "afa" #
        name_relation = "тетя" # aunt father - тетя по отцу
      when 202
        code_relation = "amo" #
        name_relation = "тетя" # aunt mother - тетя по матери
      when 211
        code_relation = "nef" #
        name_relation = "племянник" # nephew father - племянник по отцу
      when 212
        code_relation = "nem" #
        name_relation = "племянник" # nephew mother - племянник по матери
      when 221
        code_relation = "nif" #
        name_relation = "племянница" # niece father - племянница по отцу
      when 222
        code_relation = "nim" #
        name_relation = "племянница" # niece father - племянница по матери

      else
        logger.info "ERROR: No relation_id in Circle "
    end

    { code_relation: code_relation,
      name_relation: name_relation

    }

   # return code_relation, name_relation
  end

  # No use
  # Получаем новое имя отношения в хэш круга
  def self.get_new_elem_name(circle_keys_arr, name_relation)
    name_qty = name_next_qty(circle_keys_arr, name_relation)
    new_name = name_relation.concat(name_qty.to_s)
    #logger.info "In get_new_elem_name: new_name = #{new_name} "
    return new_name
  end

  # No use
  # Получаем кол-во для нового имени отношения в хэш круга
  # длина имени отношения - 3 символа. можно изменить в: one_name_key[0, 3 ]
  def self.name_next_qty(circle_keys_arr, name_relation)
    name_qty = 0
    circle_keys_arr.each do |one_name_key|
      name_qty += 1 if one_name_key[0,3] == name_relation
    end
    name_qty += 1
    return name_qty
  end

  # Служебный метод для отладки - для LOGGER
  # Показывает массив в logger
  def self.show_in_logger(arr_to_log, string_to_add)
    row_no = 0  # DEBUGG_TO_LOGG
    arr_to_log.each do |row| # DEBUGG_TO_LOGG
      row_no += 1
      logger.debug "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
    end  # DEBUGG_TO_LOGG
  end

  # Вычисление мощности общей части (пересечения) хэшей кругов профилей
  # т.е. по скольким отношениям они (профили) - совпадают
  def self.common_circle_power(common_hash)
    common_power = 0
    common_hash.each { |k,v| common_power = common_power + v.size }
    common_power
  end

  # Сравниваем все круги на похожесть (совпадение)
  def self.compare_tree_circles(tree_info, tree_circles)

   #  tree_circles =    # test 1 Алексей
    {27=>{"Сын"=>[122], "wif"=>[449], "dil"=>[82], "gsf"=>[28]},
     13=>{"Отец"=>[122], "Мама"=>[82], "Сын"=>[370, 465], "wif"=>[48], "wfl"=>[343], "wml"=>[82], "dil"=>[147], "Дед-о"=>[90], "Бабка-о"=>[449], "gdf"=>[446]},
     11=>{"Отец"=>[28], "Мама"=>[48], "Дочь"=>[446], "bro"=>[465], "wif"=>[147], "wfl"=>[110], "wml"=>[97], "Дед-о"=>[122], "Дед-м"=>[343], "Бабка-о"=>[82], "Бабка-м"=>[82], "amo"=>[331]},
     10=>{"Отец"=>[343], "Мама"=>[82], "sis"=>[48], "nem"=>[370, 465]},

     28=>{"Сын"=>[122], "hus"=>[90], "dil"=>[82], "gsf"=>[28],              "hml"=>[480], "Дочь"=>[3420]  ,"Отец"=>[343], "Мама"=>[82]  },   # from balda

     ########################
     35=>{"Сын"=>[122], "hus"=>[90], "dil"=>[82], "gsf"=>[28],         "hfl"=>[28,35], "hml"=>[490, 49], "Дочь"=>[340]  },  # from balda
    ########################

     61=>{"Отец"=>[110], "Мама"=>[97], "Дочь"=>[446], "hus"=>[370], "hfl"=>[28], "hml"=>[48]},
     66=>{"Дочь"=>[147], "hus"=>[110], "sil"=>[370], "gdm"=>[446]},

     9=>{"Дочь"=>[48, 331], "hus"=>[343], "sil"=>[28], "gsm"=>[370, 465]},

     65=>{"Дочь"=>[147], "wif"=>[97], "sil"=>[370], "gdm"=>[446]},
     7=>{"Отец"=>[343], "Мама"=>[82], "Сын"=>[370, 465], "sis"=>[331], "hus"=>[28], "hfl"=>[122], "hml"=>[82], "dil"=>[147], "gdf"=>[446]},

     3=>{"Сын"=>[28], "hus"=>[122], "hfl"=>[90], "hml"=>[449], "dil"=>[48], "gsf"=>[370, 465]},

     12=>{"Отец"=>[28], "Мама"=>[48], "bro"=>[370], "Дед-о"=>[122], "Дед-м"=>[343], "Бабка-о"=>[82], "Бабка-м"=>[82], "amo"=>[331], "nif"=>[446]},
     63=>{"Отец"=>[370], "Мама"=>[147], "Дед-о"=>[28], "Дед-м"=>[110], "Бабка-о"=>[48], "Бабка-м"=>[97], "ufa"=>[465]},
     8=>{"Дочь"=>[48, 331], "wif"=>[82], "sil"=>[28], "gsm"=>[370, 465]},
     2=>{"Отец"=>[90], "Мама"=>[449], "Сын"=>[28], "wif"=>[82], "dil"=>[48], "gsf"=>[370, 465]}}

    logger.info "In compare_tree_circles 1: tree_circles = #{tree_circles}" if !tree_circles.empty?
    logger.info "In compare_tree_circles 2: tree_circles.size = #{tree_circles.size}" if !tree_circles.empty?

    profiles_arr = tree_info[:tree_is_profiles]
  #  profiles_arr =
        [27, 13, 11, 10, 28,  35,   61, 66, 9, 65, 7, 3, 12, 63, 8, 2] # from tree 1
     #   [27, 13, 11, 10, 28,        61, 66, 9, 65, 7, 3, 12, 63, 8, 2]
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

    logger.info "==== In compare_tree_circles 4: profiles = #{profiles}" if !profiles.blank?


    # Перебор по парам профилей (неповторяющимся) с целью выявления похожих профилей
    similars = [] # Похожие - РЕЗУЛЬТАТ

    c =0  # count different profiles pairs
    IDArray.each_pair(profiles_arr) { |a_profile_id, b_profile_id|
      (
      logger.info "In compare_tree_circles 6: one_profile_id: #{a_profile_id} - b_profile_id: #{b_profile_id}"
      c = c + 1; logger.info " c = #{c} "

      data_a_to_compare = [profiles[a_profile_id][:is_name_id], profiles[a_profile_id][:is_sex_id]]
      data_b_to_compare = [profiles[b_profile_id][:is_name_id], profiles[b_profile_id][:is_sex_id]]

      #if profiles[a_profile_id] == profiles[b_profile_id]
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

          unsimilar_sign, inter_relations = check_similars_exclusion(data_for_check)
          # Проверка условия исключения похожести
      #    if ProfileKey.check_similars_exclusion(data_for_check)
      #    if check_similars_exclusion(data_for_check)
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
            # todo: брать коэфф-т из таблицы WeafamSettings
            #  certain_koeff_for_connect = get_certain_koeff #3 4  from appl.cntrler
            #############################################################
            certain_koeff_for_connect = 3
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
              similars << one_similars_pair if !one_similars_pair.empty?  # Похожие - РЕЗУЛЬТАТ
            end

          end

        end

      end
      ) }

    logger.info "In compare_tree_circles 9: similars = #{similars}"
    logger.info "In compare_tree_circles 10: similars.size = #{similars.size}" if !similars.empty?

    similars
  end

  # Формирование данных об одной паре похожих профилей для отображения в view
  def self.get_similars_data(common_data)

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

  # Формируем отображение для View Общих отношений 2-х профилей, кот-е Похожие
  def self.create_display_common(common_hash)



    display_common_relations = common_hash



    logger.info "In  self.make_view_data: display_common_relations.size = #{display_common_relations.size}" if !display_common_relations.empty?
    return display_common_relations
  end

  # Извлечение имени профиля
  def self.get_name(profile_id)
    #profile = Profile.find(profile_id)
    #name_id = profile.name_id
    #Name.find(name_id).name
    Name.find(Profile.find(profile_id).name_id).name

  end

  # Склонение имени по падежу == padej
  def self.inflect_name(text_data_name, padej)
    text_data_name != "" ? inflected_name = YandexInflect.inflections(text_data_name)[padej]["__content__"] : inflected_name = ""
    inflected_name
  end


  ######################################################################
  # МЕТОДЫ ПРОВЕРКИ УСЛОВИЯ ИСКЛЮЧЕНИЯ ПОХОЖЕСТИ
  ######################################################################
  # Стартовый Метод определения факта исключения похожести двух профилей.
  # Независимо от мощноти общности их кругов
  # На основе проверки существования отношений исключения похожести
  # в необщих частях 2-х кругов.
  def self.check_similars_exclusion(data_for_check)
    uncommon_hash_a, uncommon_hash_b = get_uncommons(data_for_check[:a_profile_circle], data_for_check[:b_profile_circle], data_for_check[:common_hash])
    inter_relations = common_of_uncommons(uncommon_hash_a, uncommon_hash_b)
    sim_exlude_relations = [ "Отец", "Мама", "Дед-о", "Дед-м", "Бабка-о","Бабка-м"   ] # ++ "Отец",
    # todo: поместить и брать массив exlude_relations из таблицы WeafamSettings
    unsimilar_sign = check_relations_exclusion(inter_relations, sim_exlude_relations)
    logger.info "*** In check_similars_exclusion 78: unsimilar_sign: #{unsimilar_sign}, inter_relations: #{inter_relations}"
    return unsimilar_sign, inter_relations
  end

  # get_uncommons
  # Получение не общих частей кругов профилей а и б
  def self.get_uncommons(a_profile_circle, b_profile_circle, common_hash)
    uncommon_hash_a = self.unintersection(a_profile_circle, common_hash)
    uncommon_hash_b = self.unintersection(b_profile_circle, common_hash)
    #logger.info "*** In get_uncommons 74: uncommon_hash_a: #{uncommon_hash_a}"
    #logger.info "*** In get_uncommons 75: uncommon_hash_b: #{uncommon_hash_b}"
    return uncommon_hash_a, uncommon_hash_b
  end

  # get_commons_of_uncommons relations
  # Получение пересечения (общей части) не общих частей кругов профилей а и б
  def self.common_of_uncommons(uncommon_hash_a, uncommon_hash_b)
    relations_a = uncommon_hash_a.keys
    relations_b = uncommon_hash_b.keys
    inter_relations = relations_a & relations_b
    #logger.info "*** In common_of_uncommons 76: inter_relations: #{inter_relations}"
    inter_relations
  end

  # check relations exclusion
  # Установка значения признака в завис-ти от того, существуют ли среди пересечения inter_relations необщих частей кругов
  # двух профилей а и б какие-либо из отношений, входящие в массив Отношений-Исключений = exlude_relations.
  # Если существует, значит среди пересечения необщих частей кругов есть отношения Отец, Мать, Дед, Бабка.
  # Наличие таких отношений, которые тем не менее не совпали по именам, говорит о том, что эти 2 профиля -
  # разные люди. Следовательно, нет необходимости далее вычислять мощность общности общей части.
  def self.check_relations_exclusion(inter_relations, exlude_relations)
    unsimilar_sign = true # Исх.знач-е
    inter_relations.each do |relation|
      unsimilar_sign = false if exlude_relations.include?(relation) # Значит - точно непохожие
      #logger.info "*** In check_rels_ each 77-1: relation: #{relation}, exlude_relations.include?(relation) = #{exlude_relations.include?(relation)}, exlude_relations = #{exlude_relations} "
      #logger.info "*** In check_relations_exclusion 77-2: unsimilar_sign: #{unsimilar_sign}"
    end
    #logger.info "*** In check_relations_exclusion 77: unsimilar_sign: #{unsimilar_sign}"
    unsimilar_sign  # передача значения признака (true/false)
  end







end
