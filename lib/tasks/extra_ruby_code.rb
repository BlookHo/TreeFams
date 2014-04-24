class ExtraCode

  # Ввод одного профиля древа. Проверка Имя-Пол.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  def enter_profile_bk(profile_name)    # NO USE
    # проверка, действ-но ли введено женское имя?
    if !profile_name.blank?
      if !check_sex_by_name(profile_name)
        name_correct = true
      else
        name_correct = false
      end
    end
    return name_correct
  end



  MainController

  #  @us_id = 2    #    IS DISTINCT FROM 2        # TRY RAILS 4 DEBUGG

  # ПОИСК С ПОМОЩЬЮ СГЕНЕРИРОВАННОЙ СТРОКИ sql
  # search_str = "relation_id = #{@all_fathers_relations_arr[0]} "
  #for str in 1 .. @all_fathers_relations_arr.length-1
  #  add_str = " OR relation_id = #{@all_fathers_relations_arr[str]} " #where( "#{search_str}" )
  #  search_str = search_str.concat(add_str)
  #end
  #@search_relations_str = search_str








  Hash

         @fathers_hash = Hash.new  # { Tree No (user_id) =>  Father Profile ID }
             arr_terms = terms_hash.keys  #           arr_freqs = terms_hash.values
             @fathers_hash.merge!({father_profile.user_id  => @fathers_name[0].id}) #
 # @fathers_hash = { Tree No (user_id) =>  Father Profile ID }.

 #           @mothers_hash.merge!({mother_profile.user_id  => @mothers_name[0].id}) #
 # @@others_hash - профили матерей с таким же именем, что у матери current_user, т.е. у возможных братьев/сестер
 # @mothers_hash = { Tree No (user_id) =>  Mother Profile ID }.


HASH ЭШИ - Merge

# склеивание 2-х хэшей  без потери элементов
  @hash1 = {2=>8, 3=>15}
  @hash2 = {2=>9, 3=>18}

  @hash2.each_key do |key|
    if ( @hash1.has_key?(key) )
      @hash1[ "hash2-originated-#{key}" ] = @hash2[key]
    else
      @hash1[key]=@hash2[key]
    end
  end

  # result: @hash1: {2=>8, 3=>15, "hash2-originated-2"=>9, "hash2-originated-3"=>18}

#####################################

# MERGE TWO HASHES. при этом значения для одинаковых ключей собираются в массивы
  @nhash1 = {2=>8, 3=>15}
  @nhash2 = {2=>9, 3=>18}
  @nhash4 = {2=>7, 3=>19}

  @nhash3 = @nhash1.merge(@nhash2){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }

  @nhash5 = @nhash3.merge(@nhash4){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
########################################################################

# h.values_at("cow", "cat")


ARRAYS  FGF

   @all_match_arr_sorted = @all_match_arr.sort_by!{ |elem| elem[0]}




  StartController

  def store_profile(id,relation,name,sex)

    tree_profile_arr = []

    tree_profile_arr[0] = id              # id Profile
    tree_profile_arr[1] = relation        # Relation
    tree_profile_arr[2] = name            # Name
    tree_profile_arr[3] = sex             # Sex

    return tree_profile_arr

  end


  def process_questions

    @navigation_var = "Navigation переменная - START контроллер/process_questions метод"

    @tree_array = []  # Финальный массив стартового дерева
    @id_profile = 1

    ##### MYSELF ##########
    @user_name = params[:name_select] #
    # извлечение пола из введенного имени
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name

      @tree_profile_arr = store_profile(@id_profile,nil,@user_name,@user_sex)
      @tree_array << @tree_profile_arr
    end


    ##### FATHER ##########
    @father_name = params[:father_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # sex by name
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
      @id_profile += 1

      @tree_profile_arr = store_profile(@id_profile,1,@father_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### MOTHER ##########
    @mother_name = params[:mother_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@mother_name.blank?
      @user_sex = check_sex_by_name(@mother_name) # sex by name
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,2,@mother_name,@user_sex)
      @tree_array << @tree_profile_arr

    end




    ##### BROTHER ##########
    @brother_name = params[:brother_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@brother_name.blank?
      @user_sex = check_sex_by_name(@brother_name) # sex by name
      if check_sex_by_name(@brother_name)
        @brother_name_correct = true
      else
        @brother_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,3,@brother_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### SISTER ##########
    @sister_name = params[:sister_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@sister_name.blank?
      @user_sex = check_sex_by_name(@sister_name) # sex by name
      if !check_sex_by_name(@sister_name)
        @sister_name_correct = true
      else
        @sister_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,4,@sister_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### SON ##########
    @son_name = params[:son_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@son_name.blank?
      @user_sex = check_sex_by_name(@son_name) # sex by name
      if !check_sex_by_name(@son_name)
        @son_name_correct = true
      else
        @son_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,5,@son_name,@user_sex)
      @tree_array << @tree_profile_arr
    end


    ##### DAUGTER ##########
    @daugter_name = params[:daugter_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@daugter_name.blank?
      @user_sex = check_sex_by_name(@daugter_name) # sex by name
      if check_sex_by_name(@daugter_name)
        @daugter_name_correct = true
      else
        @daugter_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,6,@daugter_name,@user_sex)
      @tree_array << @tree_profile_arr
    end

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}

    redirect_to show_start_tree_path

  end




end