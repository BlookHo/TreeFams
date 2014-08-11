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

  # Получение массива дерева соединенных Юзеров из Tree
  #  На входе - массив соединенных Юзеров
  # Используется 2 массива для исключения повторов
  def get_connected_tree(connected_users_arr)
    tree_arr = []
    check_tree_arr = [] # "опорный массив" - для удаления повторных элементов при формировании tree_arr
    connected_users_arr.each do |one_user|
      user_tree = Tree.where(:user_id => one_user)
      row_arr = []
      check_row_arr = []

      user_tree.each do |tree_row|
        row_arr[0] = tree_row.user_id              # user_id ID От_Профиля
        row_arr[1] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        row_arr[2] = tree_row.name_id              # name_id ID От_Профиля
        row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        row_arr[4] = tree_row.is_profile_id        # ID К_Профиля
        row_arr[5] = tree_row.is_name_id           # name_id К_Профиля
        row_arr[6] = tree_row.is_sex_id            # sex К_Профиля
        row_arr[7] = tree_row.connected            # Объединено дерево К_Профиля с другим деревом

        check_row_arr[0] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        check_row_arr[1] = tree_row.name_id              # name_id ID От_Профиля
        check_row_arr[2] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        check_row_arr[3] = tree_row.is_profile_id        # ID К_Профиля
        check_row_arr[4] = tree_row.is_name_id           # name_id К_Профиля
        check_row_arr[5] = tree_row.is_sex_id            # sex К_Профиля

        #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.include?(row_arr).inspect}" # == false
        #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.inspect} --- #{row_arr}"
        if !check_tree_arr.include?(check_row_arr) # контроль на наличие повторов
          tree_arr << row_arr
          check_tree_arr << check_row_arr
        end
        row_arr = []
        check_row_arr = []
      end
    end
    return tree_arr
  end





end
