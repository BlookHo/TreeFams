class MainController < ApplicationController
 # include MainHelper  #


# Отображение дерева Юзера в табличной форме.
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
  def main_page

    if user_signed_in?
      user_tree = Tree.where(:user_id => current_user.id).select(:id, :profile_id, :relation_id, :connected)

      row_arr = []
      tree_arr = []

      user_tree.each do |tree_row|
        row_arr[0] = tree_row.id              # ID в Дереве
        row_arr[1] = tree_row.profile_id      # ID Профиля
        row_arr[2] = Profile.find(tree_row.profile_id).name_id      # ID Имени Профиля
        row_arr[3] = Name.find(Profile.find(tree_row.profile_id).name_id).name   # Имя Профиля
        row_arr[4] = Profile.find(tree_row.profile_id).sex_id         # Пол Профиля
        row_arr[5] = tree_row.relation_id         # ID Родства Профиля с Автором
        row_arr[6] = tree_row.connected           # Объединено

        tree_arr << row_arr
        row_arr = []

      end

      session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}
      @tree_arr = tree_arr    # DEBUGG TO VIEW

      search_tree_match    # Основной поиск по дереву Автора - Юзера.

    end

  end

  # Получение одного массива для включения в массив триплекс
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_profile_arr(user_id,triplex_arr,relation)
    if user_signed_in?
      one_triplex_arr = []
      if !relation.blank?
        one_triplex_arr[0] = Tree.where(:user_id => user_id, :relation_id => relation)[0][:profile_id]
      else
        one_triplex_arr[0] = User.find(user_id).profile_id
      end
      one_triplex_arr[1] = Profile.find(one_triplex_arr[0]).sex_id
      one_triplex_arr[2] = Profile.find(one_triplex_arr[0]).name_id
      one_triplex_arr[3] = relation
      triplex_arr << one_triplex_arr
    end
  end

  # Получение массива массивов Триплекс: дочь - отец - мать.
  # [profile_id, name_id, relation_id, sex_id]
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def make_one_triplex_arr(user_id,triplex_arr, first_relation, second_relation, third_relation)
    get_profile_arr(user_id,triplex_arr,first_relation)
    get_profile_arr(user_id,triplex_arr,second_relation)
    get_profile_arr(user_id,triplex_arr,third_relation)
  end

  # Поиск id всех жен usera дерева.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_wife_profile_ids(user_id)  #
    user_wife_ids = [] # Массив profile_id жен Юзера
    user_wife_ids << Tree.where(user_id: user_id ).where("relation_id = 8").select(:profile_id).pluck(:profile_id)
    user_wife_ids = user_wife_ids.flatten if !user_wife_ids.blank? # массив объединен
  end
  # Поиск id имен жен usera дерева. АВТОР - зареген
  # @note
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_wife_names_ids(wives_ids)
    if !wives_ids.blank? # если есть жены в дереве usera
      user_wives_names_ids = []
      wives_ids.each do |wife|
        user_wives_names_ids <<  Profile.find(wife).name_id  # массив имен жен usera
      end
    end
    user_wives_names_ids = user_wives_names_ids.sort if !user_wives_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id всех детей usera дерева.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_kids_profile_ids(user_id)  #
    user_kids_ids = [] # Массив profile_id всех детей usera
    user_kids_ids << Tree.where(user_id: user_id ).where("relation_id = 3 OR relation_id = 4").select(:profile_id).pluck(:profile_id)
    user_kids_ids = user_kids_ids.flatten if !user_kids_ids.blank? # массив объединен
  end
  # Поиск id имен детей usera дерева. АВТОР - зареген
  # @note
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_kids_names_ids(kids_ids)
    if !kids_ids.blank? # если есть дети в дереве usera
      user_kids_names_ids = []
      kids_ids.each do |kid|
        user_kids_names_ids <<  Profile.find(kid).name_id  # массив имен детей usera
      end
    end
    user_kids_names_ids = user_kids_names_ids.sort if !user_kids_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id сыновей автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_sons_profile_ids  #
    author_sons_ids = [] # Массив id всех сыновей автора
    author_sons_ids << Tree.where(user_id: current_user.id ).where("relation_id = 3").select(:profile_id).pluck(:profile_id)
    author_sons_ids = author_sons_ids.flatten if !author_sons_ids.blank? # массив объединен
  end

  # Поиск id имен сыновей автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_sons_names_ids(son_ids)
    if !son_ids.blank? # если найдены братья и сестры в дереве автора
      author_sons_names_ids = []
 #     author_br_sis_names_ids << triplex_arr[0][2] if !triplex_arr.blank? # массив id имен братьев и сестер автора
      son_ids.each do |brother|
        author_sons_names_ids <<  Profile.find(brother).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    author_sons_names_ids = author_sons_names_ids.sort if !author_sons_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id дочерей автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_daughters_profile_ids  #
    author_daughters_ids = [] # Массив id всех дочерей автора
    author_daughters_ids << Tree.where(user_id: current_user.id ).where("relation_id = 4").select(:profile_id).pluck(:profile_id)
    author_daughters_ids = author_daughters_ids.flatten if !author_daughters_ids.blank? # массив объединен
  end

  # Поиск id имен дочерей автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_daughters_names_ids(daughter_ids)
    if !daughter_ids.blank? # если найдены братья и сестры в дереве автора
      author_daughters_names_ids = []
      #     author_br_sis_names_ids << triplex_arr[0][2] if !triplex_arr.blank? # массив id имен братьев и сестер автора
      daughter_ids.each do |sister|
        author_daughters_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    author_daughters_names_ids = author_daughters_names_ids.sort if !author_daughters_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id всех братьев автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_profile_ids(user_id)  #
    author_br_ids = [] # Массив id всех братьев
    author_br_ids << Tree.where(user_id: user_id ).where("relation_id = 5").select(:profile_id).pluck(:profile_id)
    author_br_ids = author_br_ids.flatten if !author_br_ids.blank? # массив объединен
  end

  # Поиск имен всех братьев автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_names_ids(bros_ids_arr) #,user_name_id)
    if !bros_ids_arr.blank? # если найдены братья в дереве автора
      br_names_ids = []
    #  br_names_ids << user_name_id #if !triplex_arr.blank? # массив id имен братьев автора
      bros_ids_arr.each do |sister|
        br_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев автора
      end
    end
    br_names_ids = br_names_ids.sort if !br_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id всех братьев и сестер автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_sist_profile_ids(user_id)  #
    author_br_sis_ids = [] # Массив id всех братьев и сестер
    author_br_sis_ids << Tree.where(user_id: user_id ).where("relation_id = 6 OR relation_id = 5").select(:profile_id).pluck(:profile_id)
    author_br_sis_ids = author_br_sis_ids.flatten if !author_br_sis_ids.blank? # массив объединен
  end

  # Поиск имен всех братьев и сестер автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_sist_names_ids(bros_sist_ids_arr,user_name_id)
    if !bros_sist_ids_arr.blank? # если найдены братья и сестры в дереве автора
      br_sis_names_ids = []
      br_sis_names_ids << user_name_id #if !triplex_arr.blank? # массив id имен братьев и сестер автора
      bros_sist_ids_arr.each do |sister|
        br_sis_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    br_sis_names_ids = br_sis_names_ids.sort if !br_sis_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск имен всех братьев и сестер автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_bros_sist_names_ids(bros_sist_ids_arr,triplex_arr)
    if !bros_sist_ids_arr.blank? # если найдены братья и сестры в дереве автора
      author_br_sis_names_ids = []
      author_br_sis_names_ids << triplex_arr[0][2] if !triplex_arr.blank? # массив id имен братьев и сестер автора
      bros_sist_ids_arr.each do |sister|
        author_br_sis_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    author_br_sis_names_ids = author_br_sis_names_ids.sort if !author_br_sis_names_ids.blank? #  # массив имен упорядочен
  end

  # Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_tree_match

    tree_arr = session[:tree_arr][:value] if !session[:tree_arr].blank?

    all_match_arr = []   # Массив совпадений всех родных с Автором
    match_amount = 0     # Кол-во совпадений всех родных с Автором
    @triplex_arr = []
    make_one_triplex_arr(current_user.id,@triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)

    # Поиск массива id имен всех братьев и сестер автора дерева
    @author_bros_sisters_names_ids = get_auther_bros_sist_names_ids(get_bros_sist_profile_ids(current_user.id),@triplex_arr)

    # Поиск массива id имен всех детей автора дерева
    @author_kids_names_ids = get_user_kids_names_ids(get_user_kids_profile_ids(current_user.id))

    if !tree_arr.blank?

      for tree_index in 0 .. tree_arr.length-1

        relation = tree_arr[tree_index][5]  # Выбор очередности поиска в зависимости от relation

        case relation # Определение вида поиска по значению relation

          when 1    # "father"
            @search_relation = "father"   # DEBUGG TO VIEW
            search_farther(@triplex_arr)
            all_match_arr << @father_match_arr if !@father_match_arr.blank?
            match_amount = @match_father_amount if !@match_father_amount.blank?

          when 2    # "mother"
            @search_relation = "mother"   #
            search_mother(@triplex_arr)
            all_match_arr << @mother_match_arr if !@mother_match_arr.blank?
            match_amount = match_amount + @match_mother_amount if !@match_mother_amount.blank?

          when 3   # "son"
            @search_relation = "son"   #
            search_son
            all_match_arr << @son_match_arr if !@son_match_arr.blank?
            match_amount = match_amount + @match_son_amount if !@match_son_amount.blank?

          when 4   # "daughter"
            @search_relation = "daughter"   #
            search_daughter
            all_match_arr << @daughter_match_arr if !@daughter_match_arr.blank?
            match_amount = match_amount + @match_daughter_amount if !@match_daughter_amount.blank?

          when 5  # "brother"
            @search_relation = "brother"   #
            search_brothers

#            search_bros_sist(@triplex_arr)  # найдены потенциальные братья

            all_match_arr << @brothers_match_arr if !@brothers_match_arr.blank? #
            match_amount = match_amount + @match_brothers_amount if !@match_brothers_amount.blank?

          when 6   # "sister"
            @search_relation = "sister"   #
            #search_bros_sist(@triplex_arr)  # найдены потенциальные сестры
            #all_match_arr << @sisters_match_arr if !@sisters_match_arr.blank? #
            #match_amount = match_amount + @match_sisters_amount if !@match_sisters_amount.blank?

          when 7   # "husband"
            @search_relation = "husband"   #

          when 8   # "wife"
            @search_relation = "wife"   #

            match_amount = match_amount + @match_wife_amount if !@match_wife_amount.blank?

          else
            @search_relation = "ERROR: no relation in tree profile"
            # TODO: call error_processing

        end

      end

    end

    @match_amount = match_amount # DEBUGG TO VIEW
    @all_match_arr = all_match_arr # DEBUGG TO VIEW

  end


  # Поиск ОТЦА ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # НАЧАЛО ПОИСКА ОТЦА ЮЗЕРА ПО СОВПАДЕНИЯМ ИМЕНИ ОТЦА, ИМЕНИ ЖЕНЫ И/ИЛИ ИМЕН ДЕТЕЙ (БРАТЬЕВ И СЕСТЕР АВТОРА)
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # 1. Ищем всех отцов
  # 2. У найденных отцов ищем их жен - могут быть указаны
  # 3. У найденных отцов ищем их детей - могут быть указаны
  # 4. находим общие для всех трех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
  # 5. По этому массиву - можно формировать вопросы для подтверждения и дальнейщего рукопожатия
  # Father_Profile_ID = triplex_arr[1][0])
  # Father_Sex_ID = triplex_arr[1][1])
  # Father_Name_ID = triplex_arr[1][2])
  # Father_Relation_ID = triplex_arr[1][3])
  def search_farther(triplex_arr)

    #@found_father = false
    # 1. Массив № 1 = @all_fathers_name_user_ids. Ищем всех отцов father's user_id с именем отца автора
    all_fathers_name_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => triplex_arr[1][2]).select(:user_id).pluck(:user_id)

    @all_fathers_name_len = all_fathers_name_user_ids.length  if !all_fathers_name_user_ids.blank? #  # DEBUGG TO VIEW
    @all_fathers_name_user_ids = all_fathers_name_user_ids  # DEBUGG TO VIEW

    if !all_fathers_name_user_ids.blank? # если такие отцы-Юзеры найдены

      @mothers_profile_ids_arr = []           # массив матерей с совпавшими именами матери автора
      fathers_mothers_users_ids_arr = []     # Массив № 2. массив user_id отцов с совпавшими матерями автора
      @kids_profile_ids_arr = []           # # DEBUGG TO VIEW
      fathers_kids_users_ids_arr = []     # Массив № 3/ж

      all_fathers_name_user_ids.each do |father| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = fathers_mothers_users_ids_arr.
        # У найденных отцов ищем их жен - могут быть указаны в дереве: 1) все жены (8) в деревьях @all_fathers_name_user_ids user_id
        # 2) имя == имени матери в триплексе автора
        fathers_wife_profile_id = Tree.where(user_id: father).where(:relation_id => 8).select(:profile_id)[0].profile_id
        if !fathers_wife_profile_id.blank? # у отца - в принципе есть жена (указана в его дереве)
          # todo: здесь могут быть несколько жен! - делать как с детьми (как ниже)
          @mothers_name = Profile.find(fathers_wife_profile_id).name_id # находим имя найденной жены одного из отцов
          if !@mothers_name.blank? && @mothers_name == triplex_arr[2][2] # если имя жены отца найдено и оно - такое же, что имя матери автора
            @mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
            fathers_mothers_users_ids_arr << father  # Массив № 2.
            # формирование массива user_id отцов, у кот-х есть жены и их имена совпадают с именем матери автора.
            @fathers_mothers_users_ids_arr = fathers_mothers_users_ids_arr  # DEBUGG TO VIEW
          end
        end

        # У найденных отцов father ищем fathers_kids_profile_ids - их детей: всех сынов (relation = 3), всех дочей (relation = 4)
        fathers_kids_profile_ids = Tree.where(user_id: father).where("relation_id = 3 OR relation_id = 4").select(:profile_id).pluck(:profile_id) #[0].profile_id
        @fathers_kids_profile_ids = fathers_kids_profile_ids     # DEBUGG TO VIEW
        # ищем всех детей в дереве отца
        if !fathers_kids_profile_ids.blank? # если найдены дети у отца
          fathers_kids_name_arr = []
          fathers_kids_profile_ids.each do |daughter|
            fathers_kids_name_arr << Profile.find(daughter).name_id # находим имя найденного ребенка отца и формируем массив id имен детей отца
          end
          @fathers_kids_name_arr = fathers_kids_name_arr     # DEBUGG TO VIEW

          if !fathers_kids_name_arr.blank?
            fathers_kids_name_arr.sort
            if fathers_kids_name_arr == @author_bros_sisters_names_ids
              # если массивы имен детей отца и массив сестер и братьев автора  - СОВПАДАЮТ
              # Если массивы совпадают, то у них вероятно общий отец. Заносим его user_id в массив id найденных отцов
              @kids_profile_ids_arr << fathers_kids_name_arr   # # DEBUGG TO VIEW Массив № 3Kids.
              fathers_kids_users_ids_arr << father  # Массив № 3.
              # заполнение массива user_id отцов, у кот-х есть дети и их имена совпадают с именем автора и именами братьев и сестер автора.
              @fathers_kids_users_ids_arr = fathers_kids_users_ids_arr     # DEBUGG TO VIEW
            end
          end
        end

      end

      # 4. находим общие для всех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id всех Отцов, отцов с совпавшими женами (матерью автора) и с совпавшими детьми Отца с братьями сестрами автора
      # Это - основа для предложения рукопожатия
      @father_match_arr = all_fathers_name_user_ids & fathers_mothers_users_ids_arr  & fathers_kids_users_ids_arr #
      ##  КОНЕЦ ПОИСКА ОТЦА

      if !@father_match_arr.blank? # если найдены
        @match_father_amount = @father_match_arr.length
        @msg_father = "Найден твой Отец на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."
      else
        @msg_father = "Твой Отец не найден на сайте. Пригласи его!"
      end

    else
      @msg_father = "Твой Отец не найден на сайте. Пригласи его!"
    end

  end

  # Поиск матери ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # НАЧАЛО ПОИСКА матери ЮЗЕРА ПО СОВПАДЕНИЯМ ИМЕНИ матери, ИМЕНИ мужа И/ИЛИ ИМЕН ДЕТЕЙ (БРАТЬЕВ И СЕСТЕР АВТОРА)
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_mother(triplex_arr)

    # взять имя матери автора
    # Mother_Profile_ID = triplex_arr[2][0])
    # Mother_Sex_ID = triplex_arr[2][1])
    # Mother_Name_ID = triplex_arr[2][2])
    # Mother_Relation_ID = triplex_arr[2][3])

    @found_mother = false
    # 1. Массив № 1 = @all_mothers_name_user_ids. Ищем всех отцов father's user_id с именем отца автора && !nil
    all_mothers_name_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => triplex_arr[2][2]).select(:user_id).pluck(:user_id)
    @all_mothers_name_len = all_mothers_name_user_ids.length  if !all_mothers_name_user_ids.blank? #  # DEBUGG TO VIEW
    @all_mothers_name_user_ids = all_mothers_name_user_ids  # DEBUGG TO VIEW

    if !all_mothers_name_user_ids.blank? # если такие отцы-Юзеры найдены

      @fathers_profile_ids_arr = []           # массив отцов с совпавшими именами отца автора
      mothers_fathers_users_ids_arr = []     # Массив № 2. массив user_id матерей с совпавшими отцами автора
      @kids_profile_ids_arr = []           # # DEBUGG TO VIEW
      mothers_kids_users_ids_arr = []     # Массив № 3

      all_mothers_name_user_ids.each do |mother| # для каждого из найденных матерей - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = mothers_mothers_users_ids_arr.
        # У найденных матерей ищем их мужей - могут быть указаны в дереве: 1) все мужья (7) в деревьях @all_mothers_name_user_ids user_id
        # 2) имя == имени отца в триплексе автора
        mothers_wife_profile_id = Tree.where(user_id: mother).where(:relation_id => 7).select(:profile_id)[0].profile_id
        if !mothers_wife_profile_id.blank? # у отца - в принципе есть жена (указана в его дереве)
          # todo: здесь могут быть несколько жен! - делать как с детьми (как ниже)
          @fathers_name = Profile.find(mothers_wife_profile_id).name_id # находим имя найденного мужа одной из матерей
          if !@fathers_name.blank? && @fathers_name == triplex_arr[1][2] # если имя жены отца найдено и оно - такое же, что имя матери автора
            @fathers_profile_ids_arr << mothers_wife_profile_id  # DEBUGG TO VIEW
            mothers_fathers_users_ids_arr << mother  # Массив № 2.
            # формирование массива user_id отцов, у кот-х есть жены и их имена совпадают с именем матери автора.
            @mothers_fathers_users_ids_arr = mothers_fathers_users_ids_arr  # DEBUGG TO VIEW
          end
        end

        # У найденных матерей father ищем fathers_kids_profile_ids - их детей: всех сынов (relation = 3), всех дочей (relation = 4)
        mothers_kids_profile_ids = Tree.where(user_id: mother).where("relation_id = 3 OR relation_id = 4").select(:profile_id).pluck(:profile_id) #[0].profile_id
        @mothers_kids_profile_ids = mothers_kids_profile_ids     # DEBUGG TO VIEW
        # ищем всех детей в дереве матерей
        if !mothers_kids_profile_ids.blank? # если найдены дети у отца
          mothers_kids_name_arr = []
          mothers_kids_profile_ids.each do |daughter|
            mothers_kids_name_arr << Profile.find(daughter).name_id # находим имя найденного ребенка отца и формируем массив id имен детей отца
          end
          @mothers_kids_name_arr = mothers_kids_name_arr     # DEBUGG TO VIEW

          if !mothers_kids_name_arr.blank?
            mothers_kids_name_arr.sort
            if mothers_kids_name_arr == @author_bros_sisters_names_ids
              # если массивы имен детей матерей и массив сестер и братьев автора  - СОВПАДАЮТ
              # Если массивы совпадают, то у них вероятно общяя мать. Заносим его user_id в массив id найденных отцов
              @kids_profile_ids_arr << mothers_kids_name_arr   # # DEBUGG TO VIEW Массив № 3Kids.
              mothers_kids_users_ids_arr << mother  # Массив № 3.
              # заполнение массива user_id матерей, у кот-х есть дети и их имена совпадают с именем автора и именами братьев и сестер автора.
              @mothers_kids_users_ids_arr = mothers_kids_users_ids_arr     # DEBUGG TO VIEW
            end
          end
        end

      end

      # 4. находим общие для всех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id всех Отцов, отцов с совпавшими женами (матерью автора) и с совпавшими детьми Отца с братьями сестрами автора
      # Это - основа для предложения рукопожатия
      @mother_match_arr = all_mothers_name_user_ids & mothers_fathers_users_ids_arr  & mothers_kids_users_ids_arr #
      ##  КОНЕЦ ПОИСКА ОТЦА

      if !@mother_match_arr.blank? # если найдены
        @match_mother_amount = @father_match_arr.length
        @msg_mother = "Найдена твоя Мать на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ней."
      else
        @msg_mother = "Твоя Мать не найдена на сайте. Пригласи её!"
      end

    else
      @msg_mother = "Твоя Мать не найдена на сайте. Пригласи её!"
    end

  #  @brothers_search_results = "No brothers results yet!!"


  end

  # Поиск БРАТЬЕВ во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_brothers #(triplex_arr)

    # Father_Profile_ID = triplex_arr[1][0])
    # Father_Sex_ID = triplex_arr[1][1])
    # Father_Name_ID = triplex_arr[1][2])
    # Father_Relation_ID = triplex_arr[1][3])
    # 1.Находим всех братьев-сестер Автора.
    # 2.Массив № 1. взять имена братьев автора и найти всех Братьев-Юзеров
    # 3. Для каждого Брата-Юзера находим его Отца и Мать. Сравниваем с отцом и матерью Автора.
    # 4. Для каждого Брата-Юзера находим его братьев-сестер. Сравниваем с братьями-сестрами Автора.\

    # 1. Массив № 1 = @author_son_names_ids.
    # Ищем всех братьев-сестер автора = user_id с именем братьев-сестер автора
    all_authors_bros_profile_ids = get_bros_profile_ids(current_user.id)

    @all_authors_bros_profiles_len = all_authors_bros_profile_ids.length  if !all_authors_bros_profile_ids.blank? #  # DEBUGG TO VIEW
    @all_authors_bros_profile_ids = all_authors_bros_profile_ids  # DEBUGG TO VIEW
    @author_bros_names_ids = get_bros_names_ids(all_authors_bros_profile_ids) #,@triplex_arr[0][2])  # Поиск массива id имен всех братьев и сестер автора дерева

    if !all_authors_bros_profile_ids.blank? # если такие братья-Юзеры найдены

      @brothers_match_arr = []

      #son_br_sis_kids_users_ids_arr = []     # Check-Массив № 3
      #son_father_users_ids_arr = []     # Check-Массив № 3/ж
      #son_mother_users_ids_arr = []     # Check-Массив № 3/ж

      @author_bros_names_ids.each do |bros_profile_id| # для каждого из найденных братьев - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = @sons_user_ids - массив сынов = user_ids с именем, равным сыну Автора.
        # Среди профилей сынов ищем Users с именем, равным сыну Автора
        bros_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => bros_profile_id).select(:user_id).pluck(:user_id)
        if !bros_user_ids.blank? # 1. у автора - в принципе есть сыны (указаны в его дереве)
           @bros_user_ids = bros_user_ids #  # # DEBUGG TO VIEW
           bros_user_ids.each do |bros_user_id|

            # 3. CHECK SON'S BROS AND SISTERS WITH AUTHOR'S KIDS - ALL NAMES
            # 3. найти всех братов и сестер этого сына
      #      @son_br_sis_profile_ids = get_bros_sist_profile_ids(son_user_id) #
      #      @son_user_name_id = Profile.where(user_id: son_user_id).select(:name_id)[0].name_id
      #      @son_br_sis_names_ids = get_bros_sist_names_ids(@son_br_sis_profile_ids,@son_user_name_id)
      #      if !@son_br_sis_names_ids.blank? && @son_br_sis_names_ids == @author_kids_names_ids # если имена братьев и сестер сына совпадают с именами детей отца-автора
      #        #@mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
      #        son_br_sis_kids_users_ids_arr << son_user_id  # Массив № 3.
      #        # формирование массива user_id сынов, у кот-х есть братья и сестры  и их имена совпадают с именами детей отца-автора.
      #        @son_br_sis_kids_users_ids_arr = son_br_sis_kids_users_ids_arr  # DEBUGG TO VIEW
      #      end

            # 4. CHECK SON'S father AND Mother WITH AUTHOR'S father AND Mother NAMES
            # 4. найти отца и мать этого сына и сравнить их имена с именами отца и матери автора.
            # имена отца и матери автора - triplex_arr
            # имена отца и матери сына - @son_triplex_arr

            @bros_triplex_arr = []
            make_one_triplex_arr(bros_user_id,@bros_triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)
            # 4.1. CHECK? BROS'S father = Author
      #      if @triplex_arr[0][2] == @bros_triplex_arr[1][2]  # имена отца сына и автора - совпадают,
      #        # этот сын - возможно сын автора\
      #        son_father_users_ids_arr << son_user_id
      #        @son_father_users_ids_arr = son_father_users_ids_arr     # DEBUGG TO VIEW
      #      end

            # 4.2. CHECK? BROS'S mother = Author's WIFE
            # find Author's WIFE
            # ЗДЕСЬ ЖЕНЫ АВТОРА - ЭТО МАССИВ. НА СЛУЧАЙ, КОГДА БЫЛИ ЕЩЕ ЖЕНЫ И ОНИ УКАЗАНЫ В ДЕРЕВЕ АВТОРА,
            # ПРИ ЭТОМ, БЫВШАЯ ЖЕНА АВТОРА - МАТЬ СЫНА
      #      authors_wives_names_ids = get_user_wife_names_ids(get_user_wife_profile_ids(current_user.id))
      #      @authors_wives_names_ids = authors_wives_names_ids     # DEBUGG TO VIEW
      #      if !authors_wives_names_ids.blank? # если есть жены в дереве автора
      #        authors_wives_names_ids.each do |wife|
      #          if wife == @son_triplex_arr[2][2]  # имена матери сына и жены автора - совпадают,
      #            # этот сын - возможно сын автора\
      #            son_mother_users_ids_arr << son_user_id  # хотя бы одна из жен автора = мать потенциального сына
      #            @son_mother_users_ids_arr = son_mother_users_ids_arr     # DEBUGG TO VIEW
      #          end
      #        end
      #      end

           end
         end

      end

      # 4. находим общие для всех поисков ИД Юзеров - сынов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id Сына автора с братьями и сестрами сына автора, сынов с совпавшими отцом и матерью автора и с совпавшими детьми автора
      # Это - основа для предложения рукопожатия
      @brothers_match_arr = @bros_user_ids #& son_br_sis_kids_users_ids_arr & son_father_users_ids_arr & son_mother_users_ids_arr #

      if !@brothers_match_arr.blank? # если найдены
        @match_brothers_amount = @brothers_match_arr.length
        @msg_brother = "Найден твой Брат на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."

      else
        @msg_brother = "Твой Брат не найден на сайте. Пригласи его!"
      end

    else
      @msg_brother = "Твой Брат не найден на сайте. Пригласи его!"
    end




  #  @brothers_search_results = "No brothers results yet!!"


  end

  # Поиск БРАТЬЕВ во всех сущ-х деревьях В КАЧЕСТВЕ АВТОРОВ на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_sisters


    @sisters_search_results = "No sisters results yet!!"


  end

  # Поиск братьев/сестер по триплекс-массиву
  # У братьев/сестер - те же отец и мать.
  # [profile_id, sex_id, name_id, relation_id]
  # @triplex_arr: [[22, 0, 506, nil], [23, 1, 45, 1], [24, 0, 453, 2]]
  # @fathers_names_arr - профили отцов с таким же именем, что у отца current_user, т.е. у возможных братьев/сестер.
  # @fathers_trees_arr - номера СД отцов (user_id) с таким же именем, что у отца current_user, т.е. у возможных братьев/сестер.
  # @mothers_names_arr - профили матерей с таким же именем, что у матери current_user, т.е. у возможных братьев/сестер.
  # @mothers_trees_arr - номера СД матерей с таким же именем, что у матери current_user, т.е. у возможных братьев/сестер.
  # todo: Разделить этот метод на 2: поиск братьев и поиск сестер
  # @see News
  def search_bros_sist(triplex_arr)
    @sisters_match_arr = []

      # Father_Profile_ID = triplex_arr[1][0])
      # Father_Sex_ID = triplex_arr[1][1])
      # Father_Name_ID = triplex_arr[1][2])
      # Father_Relation_ID = triplex_arr[1][3])

      # Mother_Profile_ID = triplex_arr[2][0])
      # Mother_Sex_ID = triplex_arr[2][1])
      # Mother_Name_ID = triplex_arr[2][2])
      # Mother_Relation_ID = triplex_arr[2][3])

      # НАЧАЛО ПОИСКА ОТЦА - организовать параллельный поиск матери!!! Т.е. ИЩЕМ - ПАРУ!!
      #@found_father = false
      @all_fathers_profiles = Tree.where.not(user_id: current_user.id).where(:relation_id => triplex_arr[1][3]).select(:id).select(:profile_id).select(:user_id)
      # все profiles отцов, кроме отца current_user
  #    all_fathers_name_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => triplex_arr[1][2]).select(:user_id).pluck(:user_id)

      @fathers_names_arr = []
      @fathers_trees_arr = []
      @all_fathers_profiles.each do |father_profile|
        @fathers_name = Profile.where(:id => father_profile.profile_id).where(:name_id => triplex_arr[1][2]).select(:id)
        if !@fathers_name.blank?
          @fathers_names_arr << @fathers_name[0].id   # Fathers Profile ID
          @fathers_trees_arr << father_profile.user_id  # Tree Nos (user_id)
        end
      end

      @qty_fathers_found = @fathers_names_arr.length if !@fathers_names_arr.blank?
      @found_father = true if !@fathers_names_arr.blank?  # DEBUGG TO VIEW  если найдены профили отцов
      # Profiles с таким же именем, что у отца current_user
      #  КОНЕЦ ПОИСКА ОТЦА

      # НАЧАЛО ПОИСКА МАТЕРИ В ПАРЕ С ОТЦОМ
      @found_mother = false
      @all_mothers_profiles = Tree.where.not(user_id: current_user.id).where(:relation_id => triplex_arr[2][3]).select(:id).select(:profile_id).select(:user_id)
      # все profiles матерей, кроме матери current_user
      @mothers_names_arr = []
      @mothers_trees_arr = []
      @all_mothers_profiles.each do |mother_profile|
        @mothers_name = Profile.where(:id => mother_profile.profile_id).where(:name_id => triplex_arr[2][2]).select(:id)
        if !@mothers_name.blank?
          @mothers_names_arr << @mothers_name[0].id   # Mothers Profile ID
          @mothers_trees_arr << mother_profile.user_id  # Tree Nos (user_id)
        end
      end

      @qty_mothers_found = @mothers_names_arr.length if !@mothers_names_arr.blank?
      @found_mother = true if !@mothers_names_arr.blank?  # DEBUGG TO VIEW если найдены профили матерей
      # с таким же именем, что у матери current_user
      #  КОНЕЦ ПОИСКА МАТЕРИ В ПАРЕ С ОТЦОМ

      # ВЫЯВЛЕНИЕ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР
      # У current_user есть БРАТ/СЕСТРА - ЕСЛИ у них у всех есть ОБЩИЕ ОТЕЦ И МАТЬ - ПАРА
      @brothers_profile_id_arr = []
      @brothers_match_arr = []
      @sisters_profile_id_arr = []
      #@sisters_match_arr = []
      @common_trees_arr = @fathers_trees_arr & @mothers_trees_arr # Пересечение массивов - общие номера trees
      # ID Users = No Tree.
      if !@common_trees_arr.blank?

        @common_trees_arr.each do |tree|
          @child_profile = Profile.find_by_user_id(tree)

          if @child_profile.sex_id == 1
            @brothers_match_arr << tree   # Массив ID TREES БРАТЬЕВ к current_user
            @brothers_profile_id_arr << User.find(tree).profile_id   # Массив ID PROFILES БРАТЬЕВ к current_user
            @nm = Name.find(@child_profile.name_id).name  # определение имени брата
            @msg_brother = "Твой брат ".concat(@nm).concat(" также есть на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним.") # формирование сообщения о найденном брате
          else
            @sisters_match_arr << tree    # Массив ID СЕСТЕР к current_user
            @sisters_profile_id_arr << User.find(tree).profile_id   # Массив ID PROFILES СЕСТЕР к current_user
            @nm = Name.find(@child_profile.name_id).name  # определение имени сестры
            @msg_sister = "Твоя сестра ".concat(@nm).concat(" также есть на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ним.") # формирование сообщения о найденной сестре
          end

          if !@brothers_match_arr.blank? # если найдены
            @match_brothers_amount = @brothers_match_arr.length
            @msg_brother = "Найден твой брат на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."
          else
            @msg_brother = "Твой брат не найден на сайте. Пригласи его!"
          end
          if !@sisters_match_arr.blank? # если найдены
            @match_sisters_amount = @sisters_match_arr.length
            @msg_sister = "Найдена твоя сестра на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ней."
          else
            @msg_sister = "Твоя сестра не найдена на сайте. Пригласи её!"
          end

        end
      end
      #  КОНЕЦ ВЫЯВЛЕНИЯ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР

      #  ГОТОВ МАССИВ ПРОФИЛЕЙ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР


  end

  # Поиск СЫНА АВТОРА-ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # 1. Ищем всех детей=сынов автора
  # 3. найти всех братов и сестер этого сына
  # 4. найти отца и мать этого сына и сравнить их имена с именами отца и матери автора.

  def search_son

    # 1. Массив № 1 = @author_son_names_ids.
    # Ищем всех сынов автора = user_id с именем сынов автора
    all_authors_son_profile_ids = get_auther_sons_profile_ids

    @all_authors_son_profiles_len = all_authors_son_profile_ids.length  if !all_authors_son_profile_ids.blank? #  # DEBUGG TO VIEW
    @all_authors_son_profile_ids = all_authors_son_profile_ids  # DEBUGG TO VIEW
    @author_son_names_ids = get_auther_sons_names_ids(all_authors_son_profile_ids)  # Поиск массива id имен всех братьев и сестер автора дерева

    if !all_authors_son_profile_ids.blank? # если такие отцы-Юзеры найдены

      son_br_sis_kids_users_ids_arr = []     # Check-Массив № 3
      son_father_users_ids_arr = []     # Check-Массив № 3/ж
      son_mother_users_ids_arr = []     # Check-Массив № 3/ж

      @author_son_names_ids.each do |son_profile_id| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = @sons_user_ids - массив сынов = user_ids с именем, равным сыну Автора.
        # Среди профилей сынов ищем Users с именем, равным сыну Автора
         sons_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => son_profile_id).select(:user_id).pluck(:user_id)
         if !sons_user_ids.blank? # 1. у автора - в принципе есть сыны (указаны в его дереве)
           @sons_user_ids = sons_user_ids #  # # DEBUGG TO VIEW
           sons_user_ids.each do |son_user_id|

             # 3. CHECK SON'S BROS AND SISTERS WITH AUTHOR'S KIDS - ALL NAMES
             # 3. найти всех братов и сестер этого сына
             @son_br_sis_profile_ids = get_bros_sist_profile_ids(son_user_id) #
             @son_user_name_id = Profile.where(user_id: son_user_id).select(:name_id)[0].name_id
             @son_br_sis_names_ids = get_bros_sist_names_ids(@son_br_sis_profile_ids,@son_user_name_id)
             if !@son_br_sis_names_ids.blank? && @son_br_sis_names_ids == @author_kids_names_ids # если имена братьев и сестер сына совпадают с именами детей отца-автора
               #@mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
               son_br_sis_kids_users_ids_arr << son_user_id  # Массив № 3.
               # формирование массива user_id сынов, у кот-х есть братья и сестры  и их имена совпадают с именами детей отца-автора.
               @son_br_sis_kids_users_ids_arr = son_br_sis_kids_users_ids_arr  # DEBUGG TO VIEW
             end

             # 4. CHECK SON'S father AND Mother WITH AUTHOR'S father AND Mother NAMES
             # 4. найти отца и мать этого сына и сравнить их имена с именами отца и матери автора.
             # имена отца и матери автора - triplex_arr
             # имена отца и матери сына - @son_triplex_arr

             @son_triplex_arr = []
             make_one_triplex_arr(son_user_id,@son_triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)
             # 4.1. CHECK? SON'S father = Author
             if @triplex_arr[0][2] == @son_triplex_arr[1][2]  # имена отца сына и автора - совпадают,
               # этот сын - возможно сын автора\
               son_father_users_ids_arr << son_user_id
               @son_father_users_ids_arr = son_father_users_ids_arr     # DEBUGG TO VIEW
             end

             # 4.2. CHECK? SON'S mother = Author's WIFE
             # find Author's WIFE
             # ЗДЕСЬ ЖЕНЫ АВТОРА - ЭТО МАССИВ. НА СЛУЧАЙ, КОГДА БЫЛИ ЕЩЕ ЖЕНЫ И ОНИ УКАЗАНЫ В ДЕРЕВЕ АВТОРА,
             # ПРИ ЭТОМ, БЫВШАЯ ЖЕНА АВТОРА - МАТЬ СЫНА
             authors_wives_names_ids = get_user_wife_names_ids(get_user_wife_profile_ids(current_user.id))
             @authors_wives_names_ids = authors_wives_names_ids     # DEBUGG TO VIEW
             if !authors_wives_names_ids.blank? # если есть жены в дереве автора
               authors_wives_names_ids.each do |wife|
                 if wife == @son_triplex_arr[2][2]  # имена матери сына и жены автора - совпадают,
                   # этот сын - возможно сын автора\
                   son_mother_users_ids_arr << son_user_id  # хотя бы одна из жен автора = мать потенциального сына
                   @son_mother_users_ids_arr = son_mother_users_ids_arr     # DEBUGG TO VIEW
                 end
               end
             end

           end
         end

      end

      # 4. находим общие для всех поисков ИД Юзеров - сынов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id Сына автора с братьями и сестрами сына автора, сынов с совпавшими отцом и матерью автора и с совпавшими детьми автора
      # Это - основа для предложения рукопожатия
      @son_match_arr = @sons_user_ids & son_br_sis_kids_users_ids_arr & son_father_users_ids_arr & son_mother_users_ids_arr #
      ##  КОНЕЦ ПОИСКА ОТЦА

      if !@son_match_arr.blank? # если найдены
        @match_son_amount = @son_match_arr.length
        @msg_son = "Найден твой Сын на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."

      else
        @msg_son = "Твой Сын не найден на сайте. Пригласи его!"
      end

    else
      @msg_son = "Твой Сын не найден на сайте. Пригласи его!"
    end

  end

  # Поиск ДОЧЕРИ АВТОРА-ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # 1. Ищем всех детей=дочей автора
  # 3. найти всех братов и сестер этой дочи
  # 4. найти отца и мать этой дочи и сравнить их имена с именами отца и матери автора.

  def search_daughter

    # 1. Массив № 1 = @@author_daughter_names_ids.
    # Ищем всех дочей автора = user_id с именем дочей автора
    all_authors_daughter_profile_ids = get_auther_daughters_profile_ids

    @all_authors_daughter_profiles_len = all_authors_daughter_profile_ids.length  if !all_authors_daughter_profile_ids.blank? #  # DEBUGG TO VIEW
    @all_authors_daughter_profile_ids = all_authors_daughter_profile_ids  # DEBUGG TO VIEW
    @author_daughter_names_ids = get_auther_daughters_names_ids(all_authors_daughter_profile_ids)  # Поиск массива id имен всех братьев и сестер автора дерева

    if !all_authors_daughter_profile_ids.blank? # если такие отцы-Юзеры найдены

      daughter_br_sis_kids_users_ids_arr = []     # Check-Массив № 3
      daughter_father_users_ids_arr = []     # Check-Массив № 3/ж
      daughter_mother_users_ids_arr = []     # Check-Массив № 3/ж

      @author_daughter_names_ids.each do |daughter_profile_id| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = @daughters_user_ids - массив дочей = user_ids с именем, равным доче Автора.
        # Среди профилей дочей ищем Users с именем, равным доче Автора
        daughters_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => daughter_profile_id).select(:user_id).pluck(:user_id)
        if !daughters_user_ids.blank? # 1. у автора - в принципе есть дочи (указаны в его дереве)
          @daughters_user_ids = daughters_user_ids #  # # DEBUGG TO VIEW
          daughters_user_ids.each do |daughter_user_id|

            # 3. CHECK daughter'S BROS AND SISTERS WITH AUTHOR'S KIDS - ALL NAMES
            # 3. найти всех братов и сестер этой дочи
            @daughter_br_sis_profile_ids = get_bros_sist_profile_ids(daughter_user_id) #
            @daughter_user_name_id = Profile.where(user_id: daughter_user_id).select(:name_id)[0].name_id
            @daughter_br_sis_names_ids = get_bros_sist_names_ids(@daughter_br_sis_profile_ids,@daughter_user_name_id)
            if !@daughter_br_sis_names_ids.blank? && @daughter_br_sis_names_ids == @author_kids_names_ids # если имена братьев и сестер дочи совпадают с именами детей отца-автора
              #@mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
              daughter_br_sis_kids_users_ids_arr << daughter_user_id  # Массив № 3.
              # формирование массива user_id дочей, у кот-х есть братья и сестры  и их имена совпадают с именами детей отца-автора.
              @daughter_br_sis_kids_users_ids_arr = daughter_br_sis_kids_users_ids_arr  # DEBUGG TO VIEW
            end

            # 4. CHECK daughter'S father AND Mother WITH AUTHOR'S father AND Mother NAMES
            # 4. найти отца и мать этой дочи и сравнить их имена с именами отца и матери автора.
            # имена отца и матери автора - triplex_arr
            # имена отца и матери дочи - @daughter_triplex_arr

            @daughter_triplex_arr = []
            make_one_triplex_arr(daughter_user_id,@daughter_triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)
            # 4.1. CHECK? daughter'S father = Author
            if @triplex_arr[0][2] == @daughter_triplex_arr[1][2]  # имена отца дочи и автора - совпадают,
              # этa дочь - возможно дочь автора\
              daughter_father_users_ids_arr << daughter_user_id
              @daughter_father_users_ids_arr = daughter_father_users_ids_arr     # DEBUGG TO VIEW
            end

            # 4.2. CHECK? daughter'S mother = Author's WIFE
            # find Author's WIFE
            # ЗДЕСЬ ЖЕНЫ АВТОРА - ЭТО МАССИВ. НА СЛУЧАЙ, КОГДА БЫЛИ ЕЩЕ ЖЕНЫ И ОНИ УКАЗАНЫ В ДЕРЕВЕ АВТОРА,
            # ПРИ ЭТОМ, БЫВШАЯ ЖЕНА АВТОРА - МАТЬ ДОЧЕРИ
            authors_wives_names_ids = get_user_wife_names_ids(get_user_wife_profile_ids(current_user.id))
            @authors_wives_names_ids = authors_wives_names_ids     # DEBUGG TO VIEW
            if !authors_wives_names_ids.blank? # если есть жены в дереве автора
              authors_wives_names_ids.each do |wife|
                if wife == @daughter_triplex_arr[2][2]  # имена матери дочи и жены автора - совпадают,
                  # этa дочь - возможно дочь автора\
                  daughter_mother_users_ids_arr << daughter_user_id  # хотя бы одна из жен автора = мать потенциальной дочи
                  @daughter_mother_users_ids_arr = daughter_mother_users_ids_arr     # DEBUGG TO VIEW
                end
              end
            end

          end
        end

      end

      # 4. находим общие для всех поисков ИД Юзеров - дочей. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id Дочи автора, с братьями и сестрами дочи автора, дочей с совпавшими отцом и матерью автора и с совпавшими детьми автора
      # Это - основа для предложения рукопожатия
      @daughter_match_arr = @daughters_user_ids & daughter_br_sis_kids_users_ids_arr & daughter_father_users_ids_arr & daughter_mother_users_ids_arr #
      ##  КОНЕЦ ПОИСКА ОТЦА

      if !@daughter_match_arr.blank? # если найдены
        @match_daughter_amount = @daughter_match_arr.length
          @msg_daughter = "Найдена твоя Дочь на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ней."

      else
        @msg_daughter = "Твоя Дочь не найдена на сайте. Пригласи её!"
      end

    else
      @msg_daughter = "Твоя Дочь не найдена на сайте. Пригласи её!"
    end

  end


  # Подтверждение совпадения родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def match_approval

    @session_id = request.session_options[:id]    # ?


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

  # Отображение меню действий для родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def relative_menu

    @menu_choice = "No choice yet - in Relative_menu"

  end




end
