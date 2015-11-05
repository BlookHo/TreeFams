
# From search_helper.rb


# СБОР ВСЕХ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ДЕРЕВЬЯМ
def collect_trees_profiles(start_hash)

  results = {}
  start_hash.each do |key, value|
    value.each do |k, v|
      if results.has_key? k
        results[k].push v
      else
        results[k] = [v]
      end

      # results.has_key? k ? results[k].push v : results[k] = [v]

    end
  end
  results

end


# NO USE !!!
# todo: перенести этот метод в Operational - для нескольких моделей
# Метод суммы двух хэшей без уничтожения значений при совпадениях ключей
# hash_one = {17=>27, 16=>28, 20=>29, 19=>30, 18=>24}
# hash_two = {16=>28, 23=>35, 21=>34}
# sum_hash = {17=>27, 16=>[28, 28], 20=>29, 19=>30, 18=>24, 23=>35, 21=>34}
def sun_two_hashes(hash_one, hash_two)
  sum_hash = hash_one.merge(hash_two){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
  return sum_hash
end

# NO USE !!!
# todo: перенести этот метод в Operational - для нескольких моделей
# Метод сортировки массива хэшей по нескольким ключам
def sort_hash_array(hash_arr_to_sort)
  sorted_hash_arr = hash_arr_to_sort.sort_by {|h| [ h['name_id'],h['relation_id'],h['is_name_id'] ]}
  return sorted_hash_arr
end

# NO USE!!!!
# todo: перенести этот метод в CirclesMethods - для нескольких моделей
# МЕТОД Вявления дубликатов в Круге
# NB !! Вставить проверку и действия ЕСЛИ В БК ЕСТЬ СОВЕРШЕННО
# ОДИНАКОВЫЕ ЭЛ-ТЫ: ИМЯ - ОТНОШЕНИЕ - ИМЯ
# Например, два одинаковых по имени брата и т.п.
# Действия: Отловить, Сформировать хэш дубликатов, Вытащить его наружу
# И прекратить объединение деревьев !
# !
# ИСп-ся в Жестком поиске - в hard_complete_search
def find_circle_duplicates(circle)
  logger.info " in find_circle_duplicates"
  diplicates_hash = {}
  circle.each do |k,v|
    #logger.info " k = in find_circle_duplicates"

  end
  logger.info " diplicates_hash: #{diplicates_hash}"

  return diplicates_hash
end


# NO USE !!!
# todo: перенести этот метод в Operational - для нескольких моделей
# метод получения массива значений одного поля = key в массиве хэшей
# На входе:         bk_arr_w_profiles  = [
#    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>28, "is_name_id"=>123},
#    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>29, "is_name_id"=>125},
#    .... ]
# На выходе: field_arr = [28, 29, 30, 24]
def get_field_array(bk_arr_w_profiles, field_name_str)
  field_values_arr = bk_arr_w_profiles.map{|x| x[field_name_str]}
  #   logger.info "Массив значений хэшей с  key= is_profile_id : field_values_arr = #{field_values_arr}     "
  return field_values_arr
end


# NO USE !!!
# todo: перенести этот метод в Operational - для нескольких моделей
# Автоматическое наполнение хэша сущностями и
# количеством появлений каждой сущности.
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see Place = main_contrl.,
################# FILLING OF HASH WITH KEYS AND/OR VALUES
def fill_hash(one_hash, elem) # Filling of hash with keys and values, according to key occurance
  if elem.blank? or elem == "" or elem == nil
    one_hash['Не найдено'] += 1
  else
    test = one_hash.key?(elem) # Is  elem in one_hash?
    if test == false #  "NOT Found in hash"
      one_hash.merge!({elem => 1}) # include elem with val=1 in hash
    else  #  "Found in hash"
      one_hash[elem] += 1 # increase (+1) val of occurance of elem
    end
  end
end

# todo: перенести этот метод в Tree Methods - для нескольких моделей
# Used in Search & MainController
# ИСПОЛЬЗУЕТСЯ В ПОИСКЕ И МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
# Получение массива дерева соединенных Юзеров из Tree
# На входе - массив соединенных Юзеров
def get_connected_tree(connected_users_arr)
  Tree.where(:user_id => connected_users_arr).select(:profile_id,:name_id,:relation_id,:is_profile_id,:is_name_id,:is_sex_id).distinct
end

# NO USE !!!
# todo: перенести этот метод в Operational - для нескольких моделей
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
  final_merged_hash
end

# No USE
# todo: перенести этот метод в Operational - для нескольких моделей
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
  final_hash_arr
end

# NO USE !!!
# todo: перенести этот метод в Operational - для нескольких моделей
# Подсчет количества найденных Профилей в массиве Хэшей
# На входе: массив Хэшей профилей input_arr_hash
# На выходе: amount_found Кол-во
def count_profiles_in_hash(input_arr_hash)
  amount_found = 0
  input_arr_hash.each do |k|
    amount_found = amount_found + k.values.flatten.size
  end
  amount_found
end

# No USE
# todo: перенести этот метод в Operational - для нескольких моделей
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
    unless user_found_id.blank?
      @count += 1
      @users_ids_arr << user_found_id.id  # user_id среди найденных профилей
    end
  end
end

