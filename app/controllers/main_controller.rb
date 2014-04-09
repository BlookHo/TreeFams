class MainController < ApplicationController
 # include MainHelper  #


# Отображение дерева Юзера .
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
  def main_page

    if !session[:profiles_array].blank?                    # DEBUGG
      @profiles_array = session[:profiles_array][:value]       # DEBUGG
    end
    if !session[:profile_arr].blank?                    # DEBUGG
      @profile_arr = session[:profile_arr][:value]      # DEBUGG
    end

    if user_signed_in?
      @user_tree = Tree.where(:user_id => current_user.id).select(:id, :profile_id, :relation_id, :connected)

      @row_arr = []
      @tree_arr = []

      @user_tree.each do |tree_row|
        @row_arr[0] = tree_row.id
        @row_arr[1] = tree_row.profile_id
        @row_arr[2] = tree_row.relation_id
        @row_arr[3] = tree_row.connected

        @tree_arr << @row_arr
        @row_arr = []

      end
    end


  end

  # Отображение дерева Юзера .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def main_display_tree

    if !session[:profiles_array].blank?                        # DEBUGG
      @profiles_array = session[:profiles_array][:value]       # DEBUGG
    end








  end


  # Отображение меню действий для родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def relative_menu

    @menu_choice = "No choice yet - in Relative_menu"

  end

  # Подтверждение совпадения родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def match_approval

    @new_approved_qty = 3
    @total_approved_qty = @@approved_match_qty + @new_approved_qty
    @rest_to_approve = @@match_qty - @total_approved_qty


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

    @triplex_arr = []
    make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr - ready!

    # Поиск братьев/сестер по триплекс-массиву
    # У братьев/сестер - те же отец и мать.
    # [profile_id, sex_id, name_id, relation_id]
    # @triplex_arr: [[22, 0, 506, nil], [23, 1, 45, 1], [24, 0, 453, 2]]
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
      #  @us_id = 2    #    IS DISTINCT FROM 2        # TRY RAILS 4 DEBUGG
        @found_father = false
        @all_fathers_profiles = Tree.where.not(user_id: current_user.id).select(:profile_id).where(:relation_id => triplex_arr[1][3])
        # все profiles отцов, кроме отца current_user
        @fathers_names_arr = []
        @all_fathers_profiles.each do |father_profile|
          @fathers_name = Profile.where(:id => father_profile.profile_id).where(:name_id => triplex_arr[1][2]).select(:id)
          @fathers_names_arr << @fathers_name if !@fathers_name.blank?
          # профили отцов с таким же именем, что у отца current_user
          # т.е. у возможных братьев/сестер.
        end
        if !@fathers_names_arr.blank?
          @qty_fathers_found = @fathers_names_arr.length
        end
        @found_father = true if !@fathers_names_arr.blank?  # если найдены профили отцов
        # с таким же именем, что у отца current_user
        #  КОНЕЦ ПОИСКА ОТЦА

        # НАЧАЛО ПОИСКА МАТЕРИ В ПАРЕ С ОТЦОМ
        @found_mother = false
        @all_mothers_profiles = Tree.where.not(user_id: current_user.id).select(:profile_id).where(:relation_id => triplex_arr[2][3])
        # все profiles матерей, кроме матери current_user
        @mothers_names_arr = []
        @all_mothers_profiles.each do |mother_profile|
          @mothers_name = Profile.where(:id => mother_profile.profile_id).where(:name_id => triplex_arr[2][2]).select(:id)
          @mothers_names_arr << @mothers_name if !@mothers_name.blank?
          # профили отцов с таким же именем, что у отца current_user
          # т.е. у возможных братьев/сестер.
        end
        if !@mothers_names_arr.blank?
          @qty_mothers_found = @mothers_name.length
        end
        @found_mother = true if !@mothers_names_arr.blank?  # если найдены профили отцов
      # с таким же именем, что у отца current_user





        #  КОНЕЦ ПОИСКА МАТЕРИ В ПАРЕ С ОТЦОМ



        # ВЫЯВЛЕНИЕ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР
        # У current_user есть БРАТ/СЕСТРА - ЕСЛИ у них у всех ОБЩИЕ ОТЕЦ И МАТЬ - ПАРА



        #  КОНЕЦ ВЫЯВЛЕНИЯ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР

        #  ГОТОВ МАССИВ ПРОФИЛЕЙ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР

      end

    end

    search_bros_sist(@triplex_arr)  # найдены общие отцы с потенциальными братьями/сестрами








  end




end
