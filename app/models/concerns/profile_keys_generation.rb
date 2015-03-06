# Модуль генерации profile_keys при добавлении нового отношени (профиля) в дереов пользователя
module ProfileKeysGeneration
  extend ActiveSupport::Concern

  # ProfileKey

  module ClassMethods


    # Добавление нового профиля для любого профиля дерева
    # Запись во все таблицы
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    # exclusions_hash - по умоланию nil
    # или же, в него передается hash, уточняющий нестандартные свзяи {profile_id => boolean} / {"143" => '0'}
    # профили в exclusions_hash с значение 0/false исключаются из генерации связей
    def add_new_profile(base_sex_id, base_profile,
                        new_profile, new_relation_id,
                        exclusions_hash: nil,
                        tree_ids: tree_ids) # [trees connected] типа [126, 127]

      puts "============ In add_new_profile ==================DDDDDDDD"
      puts "base_sex_id = #{base_sex_id}"
      puts "new_profile = #{new_profile}"
      puts "base_profile.id = #{base_profile.id}"
      puts "new_relation_id = #{new_relation_id}"
      puts "exclusions_hash = #{exclusions_hash}, tree_ids = #{tree_ids},"
      puts "base_profile.tree_id #{base_profile.tree_id}"

      logger.info "============ In add_new_profile ==================DDDDDDDD"
      logger.info "base_sex_id = #{base_sex_id}"
      logger.info "new_profile = #{new_profile}"
      logger.info "base_profile.id = #{base_profile.id}"
      logger.info "new_relation_id = #{new_relation_id}"
      logger.info "exclusions_hash = #{exclusions_hash}, tree_ids = #{tree_ids},"
      logger.info "base_profile.tree_id #{base_profile.tree_id}"
      # base_profile.tree_id - id дерева, которому принадлежит профиль, к которому добавляем новый

      get_bk_relative_names(tree_ids, base_profile.id, exclusions_hash)   # Получить от Алексея
      # сбор circles

      @profile_id = base_profile.id # DEBUGG_TO_VIEW
      @display_name_id = base_profile.display_name_id # DEBUGG_TO_VIEW
      @sex_id = base_profile.sex_id # DEBUGG_TO_VIEW
      @name_id = base_profile.name_id # DEBUGG_TO_VIEW
      @new_relation_id = new_relation_id # DEBUGG_TO_VIEW
      @new_profile_id = new_profile.id # DEBUGG_TO_VIEW
      @new_profile_name_id = new_profile.name_id # DEBUGG_TO_VIEW
      @new_profile_is_display_name_id = new_profile.display_name_id # DEBUGG_TO_VIEW
      @new_profile_sex = new_profile.sex_id # DEBUGG_TO_VIEW

      add_row_to_tree = save_new_tree_row(base_profile, new_relation_id, new_profile)
      # add_row_to_tree - это рабочий массив с данными для формирования рядов в таблице ProfileKey.

      # в поле tree_id записать для нового профиля, в каком дереве профиль создали

      @add_row_to_tree = add_row_to_tree # DEBUGG_TO_VIEW
      logger.info "add_row_to_tree = #{add_row_to_tree} "
      logger.info "Before: make_profilekeys_rows:: base_profile.tree_id = #{base_profile.tree_id}, tree_ids = #{tree_ids} "
      make_profilekeys_rows(base_sex_id,
                            base_profile.tree_id,
                            add_row_to_tree)

      logger.info "======= add_new_profile = END ================"
    end


    # Сохранение нового ряда для добавленного профиля в таблице Tree.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see
    # def save_new_tree_row(add_row_to_tree)
    #def save_new_tree_row(base_profile_id, base_sex_id,
    #    base_display_name_id,
    #                      base_name_id,
    #                      new_relation_id,
    #                      new_profile_id, new_profile_name_id, new_profile_sex,
    #    new_prf_disp_name_id,
    #                      tree_id)
    def save_new_tree_row(base_profile, new_relation_id, new_profile)

      logger.info "== In save_new_tree_row: base_profile.id = #{base_profile.id}  ============"
      logger.info "== In save_new_tree_row: new_profile.id = #{new_profile.id}  ============"

          base_profile_id = base_profile.id
          base_sex_id = base_profile.sex_id
          base_display_name_id = base_profile.display_name_id
          base_name_id = base_profile.name_id
          tree_id = base_profile.tree_id

          new_profile_id = new_profile.id
          new_profile_name_id = new_profile.name_id
          new_profile_sex = new_profile.sex_id
          new_prf_disp_name_id = new_profile.display_name_id

        new_tree = Tree.new
          # Базовый профиль = base_profile - профиль, к которому добавляем новый профиль
          new_tree.user_id            = tree_id          # base_profile.tree_id - id дерева, которому принадлежит профиль, к которому добавляем новый (user_id ID От_Профиля (From_Profile))
          new_tree.profile_id         = base_profile_id  # base_profile.id - profile_id базового профиля # От_Профиля
          new_tree.name_id            = base_name_id     # base_profile.name_id   # name_id базового профиля # От_Профиля
          new_tree.display_name_id    = base_display_name_id     # base_profile.display_name_id   # name_id базового профиля # От_Профиля

          new_tree.relation_id        = new_relation_id  # ID добавляемого Родства - кого добавляем (отца, сына, жену и т.д.) От_Профиля с К_Профилю

          new_tree.is_profile_id      = new_profile_id      # is_profile_id нового К_Профиля
          new_tree.is_name_id         = new_profile_name_id # is_name_id нового К_Профиля
          new_tree.is_sex_id          = new_profile_sex     # is_sex_id нового К_Профиля
          new_tree.is_display_name_id = new_prf_disp_name_id     # is_display_name_id   # name_id базового профиля # От_Профиля
  #########################
        new_tree.save
  #########################

        add_row_to_tree = [ #author_user.id, # Главный автор= юзер на сайте -- не иcп-ся
                 base_profile_id, base_sex_id, base_name_id, base_display_name_id, # 0, 1, 2, 3
                 new_relation_id.to_i,                                             # 4,
                 new_profile_id, new_profile_name_id, new_prf_disp_name_id         # 5, 6, 7
                           ]
      logger.info "== In save_new_tree_row: add_row_to_tree = #{add_row_to_tree}  ============"

      return add_row_to_tree
     end

     # Добавление нового ряда в таблицу ProfileKey
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    def add_new_ProfileKey_row(base_profile_tree_id, profile_id, name_id, display_name_id, new_relation_id, new_profile_id, new_profile_name_id, is_display_name_id)
       #add_new_ProfileKey_row(base_profile_tree_id, profile_id, name_id, display_name_id, new_relation_id, new_profile_id, new_profile_name_id, new_prf_disp_name_id)
       #add_new_ProfileKey_row(base_profile_tree_id, new_profile_id, new_profile_name_id, new_prf_disp_name_id, @reverse_relation_id, profile_id, name_id, display_name_id)

        new_profile_key_row = ProfileKey.new
        new_profile_key_row.user_id = base_profile_tree_id           # @current_user_id            # - from cycle:
        new_profile_key_row.profile_id = profile_id                  # profile_id
        new_profile_key_row.name_id = name_id                        # name_id
        new_profile_key_row.display_name_id = display_name_id        # display_name_id
# display_name_id
        new_profile_key_row.relation_id = new_relation_id            # relation_id
        new_profile_key_row.is_profile_id = new_profile_id           # is_profile_id
        new_profile_key_row.is_name_id = new_profile_name_id         # is_name_id
        new_profile_key_row.is_display_name_id = is_display_name_id  # is_display_name_id
# is_display_name_id

 #########################
      new_profile_key_row.save
 #########################

      one_profile_key_arr = []
      one_profile_key_arr[0] = base_profile_tree_id # @@current_user_id
      one_profile_key_arr[1] = profile_id
      one_profile_key_arr[2] = name_id
      one_profile_key_arr[3] = display_name_id  # display_name_id

      one_profile_key_arr[4] = new_relation_id
      one_profile_key_arr[5] = new_profile_id
      one_profile_key_arr[6] = new_profile_name_id
      one_profile_key_arr[7] = is_display_name_id  # is_display_name_id

      @one_profile_key_arr = one_profile_key_arr   # DEBUGG_TO_VIEW
      logger.info "== In add_new_ProfileKey_row:: one_profile_key_arr = #{one_profile_key_arr}, base_profile_tree_id = #{base_profile_tree_id}   ============"

    end

    # Добавление нового ряда в таблицу ProfileKey
    # @note GET /
    def add_two_main_ProfileKeys_rows(base_profile_tree_id, profile_id, sex_id, name_id, new_relation_id, add_relation_data ) # new_profile_id, new_profile_name_id, display_name_id, new_prf_disp_name_id)
      #add_two_main_ProfileKeys_rows(base_profile_tree_id, profile_id, sex_id, name_id, display_name_id, new_relation_id, new_profile_id, new_profile_name_id, new_prf_display_name_id)
      #add_two_main_ProfileKeys_rows(base_profile_tree_id, profile_id, sex_id, name_id, new_relation_id, add_relation_data ) # new_profile_id, new_profile_name_id, display_name_id, new_prf_disp_name_id)

      new_profile_id          = add_relation_data[:new_profile_id]
      new_profile_name_id     = add_relation_data[:new_profile_name_id]
      display_name_id         = add_relation_data[:display_name_id]
      new_prf_display_name_id = add_relation_data[:new_prf_display_name_id]

      @reverse_relation_id = Relation.where(:relation_id => new_relation_id, :origin_profile_sex_id => sex_id)[0].reverse_relation_id
      # Отношение_Обратное_Новому

      # Добавить ряд Профиль_К_Кому_Добавили - Новое_Отношение - Новый_профиль
      #add_new_ProfileKey_row(base_profile_tree_id, profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id)
      add_new_ProfileKey_row(base_profile_tree_id, profile_id, name_id, display_name_id, new_relation_id, new_profile_id, new_profile_name_id, new_prf_display_name_id)
      @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW
      # Добавить ряд Новый_профиль - Отношение_Обратное_Новому - Профиль_К_Кому_Добавили
      add_new_ProfileKey_row(base_profile_tree_id, new_profile_id, new_profile_name_id, new_prf_display_name_id, @reverse_relation_id, profile_id, name_id, display_name_id)
      #add_new_ProfileKey_row(base_profile_tree_id, profile_id, name_id, display_name_id, new_relation_id, new_profile_id, new_profile_name_id, is_display_name_id)
      @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW

    end

    # Добавление Комбинации рядов родства любого вида в ProfileKeys при вводе нового профиля
    # (Хэш_родста, профиль_Кого_добавляем, имя_Кого_добавляем, Пол_родства_того_С_Кем_делаем_новый_ряд)
    # @note GET /
    # @see News
    def fill_relation_rows(base_profile_tree_id, relation_name_hash, sex_id, relation_id, add_relation_data ) # new_profile_id, new_profile_name_id, display_name_id, new_prf_disp_name_id)
      if !relation_name_hash.blank?
        # Если существуют члены БК с родством relation_name_hash к Профилю,
        # к кот. добавляем Новый_Профиль

        new_profile_id          = add_relation_data[:new_profile_id]
        new_profile_name_id     = add_relation_data[:new_profile_name_id]
        #display_name_id         = add_relation_data[:display_name_id]
        #new_prf_display_name_id = add_relation_data[:new_prf_display_name_id]

        profiles_arr = relation_name_hash.keys  # profile_id array
        @fathers_profiles_arr = profiles_arr   # DEBUGG_TO_VIEW
        names_arr = relation_name_hash.values  # name_id array
        @fathers_names_arr = names_arr   # DEBUGG_TO_VIEW
        if !names_arr.blank?
          for arr_ind in 0 .. names_arr.length - 1

            # извлечение полей display_name_id для обоих профилей
            disp_name_id = Profile.find(profiles_arr[arr_ind]).display_name_id
            is_disp_name_id = Profile.find(new_profile_id).display_name_id

            # запись с прямым отношением
            add_new_ProfileKey_row(base_profile_tree_id, profiles_arr[arr_ind], names_arr[arr_ind], disp_name_id, relation_id, new_profile_id, new_profile_name_id, is_disp_name_id)
            @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW

            # извлечение обратного отношения
            current_reverse_relation_id = Relation.where(:relation_id => relation_id, :origin_profile_sex_id => sex_id)[0].reverse_relation_id

            # запись c обратным отношением
            logger.info "== In fill_relation_rows:: current_reverse_relation_id = #{current_reverse_relation_id}, relation_id = #{relation_id} , sex_id = #{sex_id}  ============"
            add_new_ProfileKey_row(base_profile_tree_id, new_profile_id, new_profile_name_id, is_disp_name_id, current_reverse_relation_id, profiles_arr[arr_ind], names_arr[arr_ind], disp_name_id)
            @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW
          end
        end
      end
    end

    # Добавить ряды в ProfileKeys при вводе Отца
    # в первом элементе мессива - данные об Авторе
    # в последнем элементе мессива - данные о Отца
    # @note GET /
    # @see News
    def add_father_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)

      #new_profile_id          = add_relation_data[:new_profile_id]
      #new_profile_name_id     = add_relation_data[:new_profile_name_id]
      #display_name_id         = add_relation_data[:display_name_id]
      #new_prf_display_name_id = add_relation_data[:new_prf_display_name_id]

      # Хэш_родста, Пол_родства_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 7, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 1, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 1, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard

      logger.info "== In add_father_to_ProfileKeys:: base_sex_id = #{base_sex_id.inspect}"

      # new relations
      if base_sex_id == 1 # добавляем к мужику, т.е. к Отцу или Автору-М
        # Дед по Отцу 91
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 91, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 91, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      end
      if base_sex_id == 0 # добавляем к женщине, т.е. к Матери или Автору-Ж
        # Дед по Матери 92
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 92, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 92, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      end

      fill_relation_rows(base_profile_tree_id, @wives_hash, 0, 13, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      fill_relation_rows(base_profile_tree_id, @husbands_hash, 1, 15, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###


    end

    # Добавить ряды в ProfileKeys при вводе Матери
    # в первом элементе мессива - данные об Авторе
    # в последнем элементе мессива - данные о Матери
    # @note GET /
    # @see News
    def add_mother_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_с_Добавляемым, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 8, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard

      # new relations
      logger.info "== In add_mother_to_ProfileKeys:: base_sex_id = #{base_sex_id.inspect}"
      if base_sex_id == 1
        # Бабка по Отцу 101
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 101, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 101, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      end
      if base_sex_id == 0
        # Бабка по Матери 102
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 102, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 102, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      end

      fill_relation_rows(base_profile_tree_id, @wives_hash, 0, 14, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      fill_relation_rows(base_profile_tree_id, @husbands_hash, 1, 16, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###


    end

    # Добавить ряды в ProfileKeys при вводе Сына   ## OK
    # в первом элементе мессива - данные об Авторе
    # @note GET /
    # @see News
    def add_son_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @wives_hash, 0, 3, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)      ### NonStandard
      fill_relation_rows(base_profile_tree_id, @husbands_hash, 1, 3, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)   ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 5, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 5, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)

      # new relations
      if base_sex_id == 1
        # Внук по Отцу 111
        fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 111, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 111, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        # Племянник по Отцу 211
        fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 211, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
        fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 211, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      end
      if base_sex_id == 0
        # Внук по Матери  112
        fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 112, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 112, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        # Племянник по Матери 212
        fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 212, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
        fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 212, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      end

    end

    # Добавить ряды в ProfileKeys при вводе Дочи
    # в первом элементе мессива - данные об Авторе    ## OK
    # @note GET /
    # @see News
    def add_daugther_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @wives_hash, 0, 4, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @husbands_hash, 1, 4, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 6, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 6, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)

      # new relations
      logger.info "== In add_mother_to_ProfileKeys:: base_sex_id = #{base_sex_id.inspect}"

      if base_sex_id == 1
        # Внучка по Отцу  121
        fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 121, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 121, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        # Племянница по Отцу  221
        fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 221, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
        fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 221, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      end
      if base_sex_id == 0
        # Внучка по Матери  122
        fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 122, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 122, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
        # Племянница по Матери  222
        fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 222, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
        fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 222, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      end

    end

    # Добавить ряды в ProfileKeys при вводе Брата
    # в первом элементе мессива - данные об Авторе
    # @note GET /
    # @see News
    def add_brother_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 3, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 3, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 5, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 5, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard

      # new relations
      if base_sex_id == 1
        # Дядя по Отцу  191
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 191, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 191, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      end
      if base_sex_id == 0
        # Дядя по Матери  192
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 192, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 192, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      end

    end

    # Добавить ряды в ProfileKeys при вводе Сестры
    # в первом элементе мессива - данные об Авторе
    # @note GET /
    # @see News
    def add_sister_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 4, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 4, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 6, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 6, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard

      # new relations
      if base_sex_id == 1
        # Тетя по Отцу  201
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 201, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 201, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      end
      if base_sex_id == 0
        # Тетя по Матери  202
        fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 202, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
        fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 202, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      end

    end

    # Добавить ряды в ProfileKeys при вводе Мужа
    # в первом элементе мессива - данные об Авторе
    # @note GET /
    # @see News
    def add_husband_to_ProfileKeys(base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @wives_hash, 0, 7, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 1, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 1, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard

      # new relations
      fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 18, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 18, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###

    end

    # Добавить ряды в ProfileKeys при вводе Жены
    # в первом элементе мессива - данные об Авторе
    # @note GET /
    # @see News
    def add_wife_to_ProfileKeys(base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @husbands_hash, 1, 8, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)

      # new relations
      fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 17, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 17, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###

    end


    # Добавление новых рядов по профилю в таблицу ProfileKey
    # @note GET /
    def  make_profilekeys_rows(base_sex_id, base_profile_tree_id, add_row_to_tree)

      #add_row_to_tree = [
      #    base_profile_id, base_sex_id, base_name_id, base_display_name_id, # 0, 1, 2, 3
      #    new_relation_id.to_i,                                             # 4,
      #    new_profile_id, new_profile_name_id, new_prf_display_name_id         # 5, 6, 7
      #]

      profile_id              = add_row_to_tree[0] # base_profile_id
      sex_id                  = add_row_to_tree[1]  # base_sex_id - исп-ся для определения обратного relation в завис-ти от пола базового профиля, к кому добавляем
      name_id                 = add_row_to_tree[2]  # base_name_id
      display_name_id         = add_row_to_tree[3]  # display_name_id

      new_relation_id         = add_row_to_tree[4]

      new_profile_id          = add_row_to_tree[5] # new_profile_id
      new_profile_name_id     = add_row_to_tree[6] # new_profile_name_id
      new_prf_display_name_id = add_row_to_tree[7] # is_display_name_id


      add_relation_data = {
          new_profile_id:          new_profile_id,            # add_row_to_tree[5]
          new_profile_name_id:     new_profile_name_id,       # add_row_to_tree[6]
          display_name_id:         display_name_id,           # add_row_to_tree[3]
          new_prf_display_name_id: new_prf_display_name_id    # add_row_to_tree[7]
      }

      @profile_key_arr_added = [] #
      #add_two_main_ProfileKeys_rows(base_profile_tree_id, profile_id, sex_id, name_id, display_name_id, new_relation_id, new_profile_id, new_profile_name_id, new_prf_display_name_id)
      add_two_main_ProfileKeys_rows(base_profile_tree_id, profile_id, sex_id, name_id, new_relation_id, add_relation_data ) # new_profile_id, new_profile_name_id, display_name_id, new_prf_disp_name_id)


      case new_relation_id
        when 1
          add_father_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data)
        when 2
          add_mother_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data) # new_profile_id, new_profile_name_id)
         when 3
          add_son_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data) # new_profile_id, new_profile_name_id)
        when 4
          add_daugther_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data) # new_profile_id, new_profile_name_id)
        when 5
          add_brother_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data) # new_profile_id, new_profile_name_id)
        when 6
          add_sister_to_ProfileKeys(base_sex_id, base_profile_tree_id, add_relation_data) # new_profile_id, new_profile_name_id)
        when 7
          add_husband_to_ProfileKeys(base_profile_tree_id, add_relation_data) # new_profile_id, new_profile_name_id)
        when 8
          add_wife_to_ProfileKeys(base_profile_tree_id, add_relation_data) # new_profile_id, new_profile_name_id)
        else
          logger.info "No add to ProfileKeys: new_relation_id = #{new_relation_id} "
      end

    end


    # @note GET /
    # определяются массивы имен всех существующих членов БК
    # @see News tree_ids
    # @see News
    def get_bk_relative_names(tree_ids, base_profile_id, exclusions_hash)

      logger.info "============ In get_bk_relative_names ================= DDDDDDDD"
      logger.info "tree_ids = #{tree_ids}, base_profile_id = #{base_profile_id}, exclusions_hash = #{exclusions_hash},"

      @fathers_hash = Profile.find(base_profile_id).fathers_hash(tree_ids)
      @mothers_hash = Profile.find(base_profile_id).mothers_hash(tree_ids)
      @brothers_hash = Profile.find(base_profile_id).brothers_hash(tree_ids)
      @sisters_hash = Profile.find(base_profile_id).sisters_hash(tree_ids)
      @wives_hash = Profile.find(base_profile_id).wives_hash(tree_ids)
      @husbands_hash = Profile.find(base_profile_id).husbands_hash(tree_ids)
      @sons_hash = Profile.find(base_profile_id).sons_hash(tree_ids)
      @daughters_hash = Profile.find(base_profile_id).daughters_hash(tree_ids)

      if exclusions_hash
        @fathers_hash = proceed_exclusions_profile(@fathers_hash, exclusions_hash)
        @mothers_hash = proceed_exclusions_profile(@mothers_hash, exclusions_hash)
        @brothers_hash = proceed_exclusions_profile(@brothers_hash, exclusions_hash)
        @sisters_hash = proceed_exclusions_profile(@sisters_hash, exclusions_hash)
        @wives_hash = proceed_exclusions_profile(@wives_hash, exclusions_hash)
        @husbands_hash = proceed_exclusions_profile(@husbands_hash, exclusions_hash)
        @sons_hash = proceed_exclusions_profile(@sons_hash, exclusions_hash)
        @daughters_hash = proceed_exclusions_profile(@daughters_hash, exclusions_hash)
      end

      logger.info Profile.find(base_profile_id).circle_as_hash(tree_ids)
      logger.info "============ Out get_bk_relative_names =============="
    end


    # Редакция хэшей ближнего кругав зависимости от ответов на вопросы
    # в нестандартных ситуациях.
    def proceed_exclusions_profile(members_hash, exclusions_hash)
      logger.info "============================== DDDDDDDD"
      logger.info exclusions_hash
      logger.info "============================== DDDDDDDD"
      exclusions_hash.each do |key, val|
          members_hash.each do |k,v|
            members_hash.delete_if {|k, v| k.to_i == key.to_i && val.to_i == 0.to_i}
          end
      end
      return members_hash
    end



  end

end
