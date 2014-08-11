module SearchHelper

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






end
