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

      search_tree_match

    end

  end


  # Отображение дерева Юзера в табличной форме.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_tree_match

    if !session[:tree_arr].blank?
      tree_arr = session[:tree_arr][:value]
    end

    @all_match_arr = []   # Массив совпадений всех родных с Автором
    @match_amount = 0     # Кол-во совпадений всех родных с Автором
    if !tree_arr.blank?

      for tree_index in 0 .. tree_arr.length-1

        relation = tree_arr[tree_index][5]  # Ок! первой букве

        @triplex_arr = []
        case relation # Определение вида поиска по значению relation

          when 1    # "father"
            @search_relation = "father"   # DEBUGG TO VIEW
            make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr (nil - отец, 8 - жена, 4 - дочь)
            @fath_triplex_arr = @triplex_arr  # DEBUGG TO VIEW
            search_farther(@triplex_arr)
            @match_amount = @match_father_amount if !@match_father_amount.blank?
            @all_match_arr << @father_match_arr if !@father_match_arr.blank?

          when 2    # "mother"
            @search_relation = "mother"   #
            if !@match_mother_amount.blank?
              @match_amount = @match_amount + @match_mother_amount
            end

          when 3   # "son"
            @search_relation = "son"   #

          when 4   # "daugther"
            @search_relation = "daugther"   #

          when 5   # "brother"
            @search_relation = "brother"   #

            make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr - ready!
            search_bros_sist(@triplex_arr)  # найдены потенциальные братья/сестры
            @match_amount = @match_amount + @match_brothers_amount if !@match_brothers_amount.blank?

            @all_match_arr << @brothers_match_arr if !@brothers_match_arr.blank? #

          when 6   # "sister"
            @search_relation = "sister"   #

            make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr - ready!
            search_bros_sist(@triplex_arr)  # найдены потенциальные братья/сестры
            @all_match_arr << @sisters_match_arr if !@sisters_match_arr.blank? #
            @match_amount = @match_amount + @match_sisters_amount if !@match_sisters_amount.blank?

          when 7   # "husband"
            @search_relation = "husband"   #

          when 8   # "wife"
            @search_relation = "wife"   #
            if !@match_wife_amount.blank?
              @match_amount = @match_amount + @match_wife_amount
            end

          else
            @search_relation = "ERROR: no relation in tree profile"
            # call error_processing

        end

      end

    end

   # @match_amount = @match_father_amount + @match_mother_amount + @match_son_amount + @match_daugther_amount + @match_brother_amount + @match_sister_amount + @match_husband_amount + @match_wife_amount
  end


  # Поиск id всех братьев и сестер автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_bros_sist_ids  #
    author_br_sis_ids = [] # Массив id всех братьев и сестер
    author_br_sis_ids << Tree.where(user_id: current_user.id ).where("relation_id = 6 OR relation_id = 5").select(:profile_id).pluck(:profile_id)
    author_br_sis_ids = author_br_sis_ids.flatten if !author_br_sis_ids.blank? # массив объединен
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

    @found_father = false
    # 1. Массив № 1 = @all_fathers_name_user_ids. Ищем всех отцов father's user_id с именем отца автора && !nil
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

        author_bros_sisters_ids = get_auther_bros_sist_ids  # Поиск массива id всех братьев и сестер автора дерева
        @author_bros_sisters_ids = author_bros_sisters_ids  # DEBUGG TO VIEW

        author_bros_sisters_names_ids = get_auther_bros_sist_names_ids(author_bros_sisters_ids,triplex_arr)  # Поиск массива id имен всех братьев и сестер автора дерева
        @author_bros_sisters_names_ids = author_bros_sisters_names_ids  # DEBUGG TO VIEW


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
            if fathers_kids_name_arr == author_bros_sisters_names_ids # если массивы имен детей отца и массив сестер и братьев автора  - СОВПАДАЮТ
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

  # Поиск БРАТЬЕВ во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_mother(triplex_arr)

    # взять имя брата автора
    # Father_Profile_ID = triplex_arr[1][0])
    # Father_Sex_ID = triplex_arr[1][1])
    # Father_Name_ID = triplex_arr[1][2])
    # Father_Relation_ID = triplex_arr[1][3])

    #   @mothers_name_user_ids = Profile.where.not(user_id: (current_user.id || nil)).where(:name_id => triplex_arr[2][2]).select(:user_id)


    @brothers_search_results = "No brothers results yet!!"


  end
  # Поиск БРАТЬЕВ во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_brothers(triplex_arr)

    # взять имя брата автора
    # Father_Profile_ID = triplex_arr[1][0])
    # Father_Sex_ID = triplex_arr[1][1])
    # Father_Name_ID = triplex_arr[1][2])
    # Father_Relation_ID = triplex_arr[1][3])


    @brothers_search_results = "No brothers results yet!!"


  end

  # Поиск БРАТЬЕВ во всех сущ-х деревьях В КАЧЕСТВЕ АВТОРОВ на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_sisters


    @sisters_search_results = "No sisters results yet!!"


  end

  # Получение одного массива для включения в массив триплекс
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_profile_arr(triplex_arr,relation)
    if user_signed_in?
      one_triplex_arr = []
      if  !relation.blank?
        one_triplex_arr[0] = Tree.where(:user_id => current_user.id, :relation_id => relation)[0][:profile_id]
      else
        one_triplex_arr[0] = current_user.profile_id
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
  def make_one_triplex_arr(triplex_arr, first_relation, second_relation, third_relation)
    get_profile_arr(triplex_arr,first_relation)
    get_profile_arr(triplex_arr,second_relation)
    get_profile_arr(triplex_arr,third_relation)
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
  # todo: ??????? Сделать, чтобы искались не только зарегенные (авторы) братья и сестры ???????
  # todo: Разделить этот метод на БОЛЕЕ МЕЛКИЕ : поиск братьев и поиск сестер
  # @see News
  def search_bros_sist(triplex_arr)

    if user_signed_in?
      # Father_Profile_ID = triplex_arr[1][0])
      # Father_Sex_ID = triplex_arr[1][1])
      # Father_Name_ID = triplex_arr[1][2])
      # Father_Relation_ID = triplex_arr[1][3])

      # Mother_Profile_ID = triplex_arr[2][0])
      # Mother_Sex_ID = triplex_arr[2][1])
      # Mother_Name_ID = triplex_arr[2][2])
      # Mother_Relation_ID = triplex_arr[2][3])

      # НАЧАЛО ПОИСКА ОТЦА - организовать параллельный поиск матери!!! Т.е. ИЩЕМ - ПАРУ!!
      @found_father = false
      @all_fathers_profiles = Tree.where.not(user_id: current_user.id).where(:relation_id => triplex_arr[1][3]).select(:id).select(:profile_id).select(:user_id)
      # все profiles отцов, кроме отца current_user
      @fathers_names_arr = []
      @fathers_trees_arr = []
      @all_fathers_profiles.each do |father_profile|
        @fathers_name = Profile.where(:id => father_profile.profile_id).where(:name_id => triplex_arr[1][2]).select(:id)
        if !@fathers_name.blank?
          @fathers_names_arr << @fathers_name[0].id   # Fathers Profile ID
          @fathers_trees_arr << father_profile.user_id  # Tree Nos (user_id)
        end
      end
      if !@fathers_names_arr.blank?
        @qty_fathers_found = @fathers_names_arr.length
      end
      @found_father = true if !@fathers_names_arr.blank?  # DEBUGG TO VIEW  если найдены профили отцов
      # с таким же именем, что у отца current_user
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
      if !@mothers_names_arr.blank?
        @qty_mothers_found = @mothers_names_arr.length
      end
      @found_mother = true if !@mothers_names_arr.blank?  # DEBUGG TO VIEW если найдены профили матерей
      # с таким же именем, что у матери current_user
      #  КОНЕЦ ПОИСКА МАТЕРИ В ПАРЕ С ОТЦОМ

      # ВЫЯВЛЕНИЕ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР
      # У current_user есть БРАТ/СЕСТРА - ЕСЛИ у них у всех есть ОБЩИЕ ОТЕЦ И МАТЬ - ПАРА
      @brothers_profile_id_arr = []
      @brothers_match_arr = []
      @sisters_profile_id_arr = []
      @sisters_match_arr = []
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
    make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr - ready!

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
