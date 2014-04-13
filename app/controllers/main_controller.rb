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

    @all_match_arr = []

    if !tree_arr.blank?

      for tree_index in 0 .. tree_arr.length-1

        relation = tree_arr[tree_index][5]  # Ок! первой букве

        @triplex_arr = []
        case relation # Определение вида поиска по значению relation

          when 1    # Ок!
            @search_relation = "father"   #
            make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr (nil - отец, 8 - жена, 4 - дочь)
            @fath_triplex_arr = @triplex_arr
            search_farther(@triplex_arr)



          when 2
            @search_relation = "mother"   #

          when 3
            @search_relation = "son"   #

          when 4
            @search_relation = "daugther"   #

          when 5
            @search_relation = "brother"   #

    #        search_brothers # ???

            make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr - ready!
            search_bros_sist(@triplex_arr)  # найдены потенциальные братья/сестры

            @all_match_arr << @brothers_match_arr if !@brothers_match_arr.blank? #

          when 6
            @search_relation = "sister"   #
       #     search_sisters  # ???

            make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr - ready!
            search_bros_sist(@triplex_arr)  # найдены потенциальные братья/сестры
            @all_match_arr << @sisters_match_arr if !@sisters_match_arr.blank? #

          when 7
            @search_relation = "husband"   #

          when 8
            @search_relation = "wife"   #

          else
            @search_relation = "ERROR: no relation in tree profile"
            # call error_processing

        end

      end

    end

  end

  # Поиск БРАТЬЕВ во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_farther(triplex_arr)

    # Father_Profile_ID = triplex_arr[1][0])
    # Father_Sex_ID = triplex_arr[1][1])
    # Father_Name_ID = triplex_arr[1][2])
    # Father_Relation_ID = triplex_arr[1][3])

    # НАЧАЛО ПОИСКА ОТЦА ЮЗЕРА ПО СОВПАДЕНИЯМ ИМЕН ЖЕН И/ИЛИ ДЕТЕЙ
    # 1. Ищем всех отцов
    # 2. У найденных отцов ищем их жен - могут быть указаны
    # 3. У найденных отцов ищем их сынов или дочей (в завис-ти от пола автора - м или ж) - могут быть указаны
    # 4. находим общие для всех трех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
    # 5. По этому массиву - можно формировать вопросы для подтверждения и дальнейщего рукопожатия

    @found_father = false
    # 1. Массив № 1 = @all_fathers_name_user_ids. Ищем всех отцов father's user_id с именем отца автора
    @all_fathers_name_user_ids = Profile.where.not(user_id: (current_user.id || nil)).where(:name_id => triplex_arr[1][2]).select(:user_id).pluck(:user_id)
    if !@all_fathers_name_user_ids.blank? # если такие отцы-Юзеры найдены

      @mothers_profile_ids_arr = []           # массив матерей с совпавшими именами матери автора
      @fathers_mothers_users_ids_arr = []     # Массив № 2. массив user_id отцов с совпавшими матерями автора

      @sons_profile_ids_arr = []               # массив сынов с совпавшими именами автора - пол = м
      @fathers_sons_users_ids_arr = []         # Массив № 3/м

      @daughters_profile_ids_arr = []           # массив дочерей с совпавшими именами автора - пол = ж
      @fathers_daughters_users_ids_arr = []     # Массив № 3/ж

      @all_fathers_name_user_ids.each do |father| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = @fathers_mothers_users_ids_arr.
        # У найденных отцов ищем их жен - могут быть указаны : 1) все жены (8) в деревьях @all_fathers_name_user_ids user_id
        #                           2) имя == имени матери в триплексе автора
        @fathers_wife_profile_id = Tree.where(user_id: father).where(:relation_id => 8).select(:profile_id)[0].profile_id
        if !@fathers_wife_profile_id.blank? # у отца - в принципе есть жена (указана в его дереве)
          # todo: здесь могут быть несколько жен! - делать как с детьми (как ниже)
          @mothers_name = Profile.find(@fathers_wife_profile_id).name_id # находим имя найденной жены одного из отцов
          if !@mothers_name.blank? && @mothers_name == triplex_arr[2][2] # если имя жены отца найдено и оно - такое же, что имя матери автора

            @mothers_profile_ids_arr << @fathers_wife_profile_id
            @fathers_mothers_users_ids_arr << father  # Массив № 2.
            # формирование массива user_id отцов, у кот-х есть жены и их имена совпадают
            # с именем матери автора.

          end
        end

        # 3. Массив № 3 = @all_fathers_name_user_ids.
        # У найденных отцов father ищем их сынов или дочей (в завис-ти от пола автора - м или ж) - могут быть указаны:
        # 3.1) всех сынов (relation = 3) в деревьях отцов father (user_id) + имя == имени автора в триплексе автора
        # ИЛИ
        # 3.2) всех дочей (relation = 4) в деревьях отцов father (user_id) + имя == имени автора в триплексе автора
#        @fathers_sons_profile_ids = Tree.where(user_id: father).where(:relation_id => 3).select(:profile_id).pluck(:profile_id)  # DEBUGG TO VIEW
        if triplex_arr[0][1] == 1
          @fathers_sons_profile_ids = Tree.where(user_id: father).where(:relation_id => 3).select(:profile_id).pluck(:profile_id)  #[0].profile_id
          # ищем всех сыновей в дереве отца, если автор - м
          if !@fathers_sons_profile_ids.blank? # если найдены сыны у отца
            @fathers_sons_profile_ids.each do |son|
              @fathers_son_name = Profile.find(son).name_id # находим имя найденного сына одного из отцов
              if !@fathers_son_name.blank? && @fathers_son_name == triplex_arr[0][2] # если имя сына отца найдено и оно - такое же, что имя автора (пол = м)
                @sons_profile_ids_arr << son  # Массив № 3Sons.
                @fathers_sons_users_ids_arr << father  # Массив № 3S.
                # формирование массива user_id отцов, у кот-х есть сыны и их имена совпадают
                # с именем автора (пол автора = м).
              end
            end
          end

        else
          @fathers_daughters_profile_ids = Tree.where(user_id: father).where(:relation_id => 4).select(:profile_id).pluck(:profile_id) #[0].profile_id
          # ищем всех дочерей в дереве отца, если автор - ж
          if !@fathers_daughters_profile_ids.blank? # если найдены дочи у отца
            @fathers_daughters_profile_ids.each do |daughter|
              @fathers_daughter_name = Profile.find(daughter).name_id # находим имя найденной дочи одного из отцов
              if !@fathers_daughter_name.blank? && @fathers_daughter_name == triplex_arr[0][2] # если имя дочи отца найдено и оно - такое же, что имя автора (пол = ж)
                @daughters_profile_ids_arr << daughter   # Массив № 3Daughters.
                @fathers_daughters_users_ids_arr << father  # Массив № 3D.
                # формирование массива user_id отцов, у кот-х есть дочи и их имена совпадают
                # с именем автора (пол автора = ж).
              end
            end
          end

        end



      end

      # 4. находим общие для всех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения Отцов, Жен и (Сынов или Дочей)
      # В @common_father_arr - общие user_id = номера trees
      # Это - основа для предложения рукопожатия
      #
      if triplex_arr[0][1] == 1
        @common_father_arr = @all_fathers_name_user_ids & @fathers_mothers_users_ids_arr & @fathers_sons_users_ids_arr #
        # Итоговый массив ОТЦА если автор = сын
      else
        @common_father_arr = @all_fathers_name_user_ids & @fathers_mothers_users_ids_arr  & @fathers_daughters_users_ids_arr #
        # Итоговый массив ОТЦА если автор = дочь
      end
      ##  КОНЕЦ ПОИСКА ОТЦА

      if !@common_father_arr.blank? # если найдены
        @search_msg = "Найден твой Отец на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."
      else
        @search_msg = "Твоего Отца не найдено на сайте. Пригласи его!"
      end

    else
      @search_msg = "Твоего Отца не найдено на сайте. Пригласи его!"
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
