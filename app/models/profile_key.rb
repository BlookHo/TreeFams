class ProfileKey < ActiveRecord::Base
  include ProfileKeysGeneration
  include SearchHelper

  belongs_to :profile#, dependent: :destroy
  belongs_to :is_profile, foreign_key: :is_profile_id, class_name: Profile
  belongs_to :user
  belongs_to :name, foreign_key: :is_name_id
  belongs_to :display_name, class_name: Name, foreign_key: :is_display_name_id
  belongs_to :relation, primary_key: :relation_id

  # пересечение 2-х хэшей, у которых - значения = массивы
  def self.intersection(first, other)
    result = {}
    first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
      intersect = other[k] & v
      result.merge!({k => intersect}) if !intersect.blank?
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

      tree_circles = ProfileKey.get_tree_circles(tree_info) # Получаем круги для каждого профиля в дереве
      logger.info "In search_similars 1: tree_circles = #{tree_circles}" if !tree_circles.empty?
      logger.info "In search_similars 2: tree_circles.size = #{tree_circles.size}" if !tree_circles.empty?

      similars = ProfileKey.compare_tree_circles(tree_info, tree_circles) # Сравниваем все круги на похожесть (совпадение)

      return similars

    end

  end

  # Получаем круги для каждого профиля в дереве
  #def self.get_tree_circles(tree_info)
  def self.get_tree_circles(tree_info)

    tree_circles = {}
    tree_info[:tree_is_profiles].each do |profile_id|
      tree_circles.merge!( ProfileKey.get_profile_circle(profile_id, tree_info[:connected_users]) ) # if !profile_circle_hash.empty?
    end
    return tree_circles

  end

  # Получаем один круг для одного профиля в дереве
  def self.get_profile_circle(profile_id, connected_users_arr)

    profile_circle = ProfileKey.where(:user_id => connected_users_arr, :profile_id => profile_id).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
    #logger.info "In get_profile_circle1: profile_circle.size = #{profile_circle.size}" if !profile_circle.blank?

    circle_profiles_arr = ProfileKey.make_arrays_from_circle(profile_circle)  # Ok
    #logger.info "In get_profile_circle2: circle_profiles_arr = #{circle_profiles_arr}" if !circle_profiles_arr.blank?

    profile_circle_hash = ProfileKey.convert_circle_to_hash(circle_profiles_arr)
    #logger.info "In get_profile_circle3: profile_circle_hash = #{profile_circle_hash}" if !profile_circle_hash.empty?

    return profile_id => profile_circle_hash

  end

  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  def self.make_arrays_from_circle(bk_rows)
    circle_array = []
    bk_rows.each do |row|
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
      relation_val, is_name_val, is_profile_val = ProfileKey.get_row_data(one_row_hash)
      name_relation = ProfileKey.get_name_relation(relation_val)
      # Наращиваем круг в виде хэша
      profile_circle_hash = ProfileKey.growing_val_arr(profile_circle_hash, name_relation, is_name_val)
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
    case relation_val
      when 1
        name_relation = "fat" # father
      when 2
        name_relation = "mot" # mother
      when 3
        name_relation = "son" # son
      when 4
        name_relation = "dau" # daughter
      when 5
        name_relation = "bro" # brother
      when 6
        name_relation = "sis" # sister
      when 7
        name_relation = "hus"   # husband
      when 8
        name_relation = "wif"   # wife
      when 91
        name_relation = "gff" # grand father father
      when 92
        name_relation = "gfm" # grand father mother
      when 101
        name_relation = "gmf" # grand mother father
      when 102
        name_relation = "gmm" # grand mother mother
      when 111
        name_relation = "gsf" # grand son father - внук
      when 112
        name_relation = "gsm" # grand son mother - внук
      when 121
        name_relation = "gdf" # grand daughter father - внучка по отцу
      when 122
        name_relation = "gdm" # grand daughter mother - внучка по матери
      when 13
        name_relation = "hfl" # husband father-in-law - свекор
      when 14
        name_relation = "hml" # husband mother-in-law - свекровь
      when 15
        name_relation = "wfl" # wife father-in-law - тесть
      when 16
        name_relation = "wml" # wife mother-in-law - теща
      when 17
        name_relation = "dil" # daughter-in-law - невестка
      when 18
        name_relation = "sil" # son-in-law - зять
      when 191
        name_relation = "ufa" # uncle father - дядя по отцу
      when 192
        name_relation = "umo" # uncle mother - дядя по матери
      when 201
        name_relation = "afa" # aunt father - тетя по отцу
      when 202
        name_relation = "amo" # aunt mother - тетя по матери
      when 211
        name_relation = "nef" # nephew father - племянник по отцу
      when 212
        name_relation = "nem" # nephew mother - племянник по матери
      when 221
        name_relation = "nif" # niece father - племянница по отцу
      when 222
        name_relation = "nim" # niece father - племянница по матери

      else
        logger.info "ERROR: No relation_id in Circle "
    end
    return name_relation
  end

  # No use
  # Получаем новое имя отношения в хэш круга
  def self.get_new_elem_name(circle_keys_arr, name_relation)
    name_qty = ProfileKey.name_next_qty(circle_keys_arr, name_relation)
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

     tree_circles =    # test
    {27=>{"son"=>[122], "wif"=>[449], "dil"=>[82], "gsf"=>[28]},
     13=>{"fat"=>[122], "mot"=>[82], "son"=>[370, 465], "wif"=>[48], "wfl"=>[343], "wml"=>[82], "dil"=>[147], "gff"=>[90], "gmf"=>[449], "gdf"=>[446]},
     11=>{"fat"=>[28], "mot"=>[48], "dau"=>[446], "bro"=>[465], "wif"=>[147], "gff"=>[122], "gfm"=>[343], "gmf"=>[82], "gmm"=>[82], "amo"=>[331]},
     10=>{"fat"=>[343], "mot"=>[82], "sis"=>[48], "nem"=>[370, 465]},
     28=>{"son"=>[122], "hus"=>[90], "dil"=>[82],    "sis"=>[48, 55], "nem"=>[370, 465],    "gsf"=>[28]},

     999=>{"son"=>[122], "hus"=>[90],    "sis"=>[48, 55],   "dil"=>[82], "gsf"=>[28]},
     998=>{"son"=>[122], "hus"=>[90],    "sis"=>[48, 55],   "dil"=>[82], "gsf"=>[28]},

     61=>{"dau"=>[446], "hus"=>[370], "hfl"=>[28], "hml"=>[48]},
     66=>{"dau"=>[446], "hus"=>[370], "hfl"=>[28], "hml"=>[48]},



     9=>{"dau"=>[48, 331], "hus"=>[343], "sil"=>[28], "gsm"=>[370, 465]},
     7=>{"fat"=>[343], "mot"=>[82], "son"=>[370, 465], "sis"=>[331], "hus"=>[28], "hfl"=>[122], "hml"=>[82], "dil"=>[147], "gdf"=>[446]},
     3=>{"son"=>[28], "hus"=>[122], "hfl"=>[90], "hml"=>[449], "dil"=>[48], "gsf"=>[370, 465]},
     12=>{"fat"=>[28], "mot"=>[48], "bro"=>[370], "gff"=>[122], "gfm"=>[343], "gmf"=>[82], "gmm"=>[82], "amo"=>[331], "nif"=>[446]},
     63=>{"fat"=>[370], "mot"=>[147], "gff"=>[28], "gmf"=>[48], "ufa"=>[465]},
     8=>{"dau"=>[48, 331], "wif"=>[82], "sil"=>[28], "gsm"=>[370, 465]},
     2=>{"fat"=>[90], "mot"=>[449], "son"=>[28], "wif"=>[82], "dil"=>[48], "gsf"=>[370, 465]}}
    logger.info "In compare_tree_circles 1: tree_circles = #{tree_circles}" if !tree_circles.empty?
    logger.info "In compare_tree_circles 2: tree_circles.size = #{tree_circles.size}" if !tree_circles.empty?

 #   profiles_arr = tree_info[:tree_is_profiles]  # from tree
     profiles_arr = [27, 13, 11, 10, 28,   999, 998,    61,   66,   9, 7, 3, 12, 63, 8, 2]  # test
    logger.info "In compare_tree_circles 3: profiles_arr = #{profiles_arr}" if !profiles_arr.blank?

    profiles =   # test
                {27=>{:is_name_id=>90, :is_sex_id=>1},
                13=>{:is_name_id=>28, :is_sex_id=>1},
                11=>{:is_name_id=>370, :is_sex_id=>1},
                10=>{:is_name_id=>331, :is_sex_id=>0},
                28=>{:is_name_id=>449, :is_sex_id=>0},

                999=>{:is_name_id=>449, :is_sex_id=>0},
                998=>{:is_name_id=>449, :is_sex_id=>0},

                61=>{:is_name_id=>147, :is_sex_id=>0},
                66=>{:is_name_id=>147, :is_sex_id=>0},

                9=>{:is_name_id=>82, :is_sex_id=>0},
                65=>{:is_name_id=>110, :is_sex_id=>1},
                7=>{:is_name_id=>48, :is_sex_id=>0},
                3=>{:is_name_id=>82, :is_sex_id=>0},
                12=>{:is_name_id=>465, :is_sex_id=>1},
                63=>{:is_name_id=>446, :is_sex_id=>0},
                8=>{:is_name_id=>343, :is_sex_id=>1},
                2=>{:is_name_id=>122, :is_sex_id=>1}}

  #  profiles = tree_info[:profiles]     # from tree


    # Перебор по парам профилей (неповторяющимся) с целью выявления похожих профилей
    similars = [] # Похожие - РЕЗУЛЬТАТ

    c =0  # count ifferent dprofiles pairs
    IDArray.each_pair(profiles_arr) { |a_profile_id, b_profile_id|
      (
      logger.info "In compare_tree_circles 6: one_profile_id: #{a_profile_id} - b_profile_id: #{b_profile_id}"
      c = c + 1; logger.info " c = #{c} "

      if profiles[a_profile_id] == profiles[b_profile_id]
        # сравниваемые хэши кругов профилей и определение их общей части кругов профилей
        common_hash = ProfileKey.intersection(tree_circles[a_profile_id], tree_circles[b_profile_id])
        # Вычисление мощности общей части кругов профилей
        common_power = ProfileKey.common_circle_power(common_hash)
        # Занесение в результат тех пар профилей, у кот. мощность совпадения больше коэфф-та достоверности
        if common_power >= 4
          common_data =
              { first_profile_id:  a_profile_id,
                profile_a_data:  profiles[a_profile_id],
                second_profile_id:  b_profile_id,
                profile_b_data:  profiles[b_profile_id],
                common_hash:  common_hash,
                common_power:  common_power
              }
          one_similars_pair = ProfileKey.get_similars_data(common_data)
          similars << one_similars_pair if !one_similars_pair.empty?  # Похожие - РЕЗУЛЬТАТ
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
      name_a = Name.find(common_data[:profile_a_data][:is_name_id]).name
      one_similars_pair.merge!(:first_name_id => name_a)
      common_data[:profile_a_data][:is_sex_id] == 1 ? sex_a = 'М' : sex_a = 'Ж'
      one_similars_pair.merge!(:first_sex_id => sex_a)

      one_similars_pair.merge!(:second_profile_id => common_data[:second_profile_id])
      name_b = Name.find(common_data[:profile_b_data][:is_name_id]).name
      one_similars_pair.merge!(:second_name_id => name_b)
      common_data[:profile_b_data][:is_sex_id] == 1 ? sex_b = 'М' : sex_b = 'Ж'
      one_similars_pair.merge!(:second_sex_id => sex_b)

      display_commoin_relations = ProfileKey.create_display_common(common_data[:common_hash])
      one_similars_pair.merge!(:common_relations => display_commoin_relations)
      one_similars_pair.merge!(:common_power => common_data[:common_power])

      one_similars_pair

  end

  # Формируем отображение для View Общих отношений 2-х профилей, кот-е Похожие
  def self.create_display_common(common_hash)



    display_common_relations = common_hash



    logger.info "In  self.make_view_data: display_common_relations.size = #{display_common_relations.size}" if !display_common_relations.empty?
    return display_common_relations
  end





end
