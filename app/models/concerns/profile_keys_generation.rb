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
    def add_new_profile(base_sex_id, base_profile, new_profile, new_relation_id,
                        exclusions_hash: nil, tree_ids: tree_ids) # [trees connected] типа [126, 127]

      # Получит хэши имен ближнего круга
      # вокруг базового профиля с учетом хэша исключений - от нестандартных ответов.

    get_bk_relative_names(tree_ids, base_profile.id, exclusions_hash)

      # base_profile.tree_id - id дерева, которому принадлежит профиль, к которому добавляем новый

    make_profilekeys_rows(base_sex_id, base_profile.tree_id, save_new_tree_row(base_profile, new_relation_id, new_profile))

      # # logger.info "In add_new_profile: Before create_add_log"
      # current_log_type = 1  #  # add: rollback == delete. Тип = добавление нового профиля при rollback
      # new_log_number = CommonLog.new_log_id(base_profile.tree_id, current_log_type)
      # # logger.info "In add_new_profile: Before common_log_data   new_log_number = #{new_log_number}"
      # common_log_data = { user_id: base_profile.tree_id, log_type: current_log_type,
      #                     log_id:  new_log_number, profile_id: new_profile.id,
      #                     base_profile_id: base_profile.id,
      #                     new_relation_id: new_relation_id }
      # CommonLog.create_common_log(common_log_data)

    end


    # Сохранение нового ряда для добавленного профиля в таблице Tree.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see
    # add_row_to_tree - это рабочий массив с данными для формирования рядов в таблице ProfileKey.
    def save_new_tree_row(base_profile, new_relation_id, new_profile)

      base_profile_id       = base_profile.id
      base_sex_id           = base_profile.sex_id
      # base_display_name_id  = base_profile.display_name_id
      base_name_id          = base_profile.name_id

      tree_id               = base_profile.tree_id   # было base_profile до 29.6.15

      new_profile_id        = new_profile.id
      new_profile_name_id   = new_profile.name_id
      new_profile_sex       = new_profile.sex_id
      # new_prf_disp_name_id  = new_profile.display_name_id

      new_tree = Tree.new
        # Базовый профиль = base_profile - профиль, к которому добавляем новый профиль
        new_tree.user_id            = tree_id          # id дерева, которому принадлежит профиль
        # base_profile.tree_id - id дерева, которому принадлежит профиль, к которому добавляем новый (user_id ID От_Профиля (From_Profile))
        new_tree.profile_id         = base_profile_id  # base_profile.id - profile_id базового профиля # От_Профиля
        new_tree.name_id            = base_name_id     # base_profile.name_id   # name_id базового профиля # От_Профиля
        # new_tree.display_name_id    = base_display_name_id     # base_profile.display_name_id   # name_id базового профиля # От_Профиля

        new_tree.relation_id        = new_relation_id  # ID добавляемого Родства - кого добавляем (отца, сына, жену и т.д.) От_Профиля с К_Профилю

        new_tree.is_profile_id      = new_profile_id      # is_profile_id нового К_Профиля
        new_tree.is_name_id         = new_profile_name_id # is_name_id нового К_Профиля
        new_tree.is_sex_id          = new_profile_sex     # is_sex_id нового К_Профиля
        # new_tree.is_display_name_id = new_prf_disp_name_id     # is_display_name_id   # name_id базового профиля # От_Профиля
    #########################
      new_tree.save
    #########################
      # puts "In save_new_tree_row: new_relation_id = #{new_relation_id}"

      # [ base_profile_id, base_sex_id, base_name_id, base_display_name_id, # 0, 1, 2, 3
      #    new_relation_id.to_i,                                             # 4,
      #    new_profile_id, new_profile_name_id, new_prf_disp_name_id  ]      # 5, 6, 7
      [ base_profile_id, base_sex_id, base_name_id, # 0, 1, 2, 3
        new_relation_id.to_i,                                             # 4,
        new_profile_id, new_profile_name_id  ]      # 5, 6, 7
    end


    # Добавление новых рядов по профилю в таблицу ProfileKey
    # @note GET /
    #add_row_to_tree = [
    #    base_profile_id, base_sex_id, base_name_id, base_display_name_id, # 0, 1, 2, 3
    #    new_relation_id.to_i,                                             # 4,
    #    new_profile_id, new_profile_name_id, new_prf_display_name_id         # 5, 6, 7
    #]
    # base_profile.tree_id - id дерева, которому принадлежит профиль, к которому добавляем новый
    # base_sex_id - исп-ся для определения обратного relation в завис-ти от пола базового профиля, к кому добавляем
    def  make_profilekeys_rows(base_sex_id, base_profile_tree_id, add_row_to_tree)

      profile_id              = add_row_to_tree[0] # base_profile_id
      sex_id                  = add_row_to_tree[1] # base_sex_id  ?
      # todo: уточнить с sex_id == base_sex_id ??
      name_id                 = add_row_to_tree[2] # base_name_id
      # display_name_id         = add_row_to_tree[3]
      new_relation_id         = add_row_to_tree[4]
      new_profile_id          = add_row_to_tree[5]
      new_profile_name_id     = add_row_to_tree[6]
      # new_prf_display_name_id = add_row_to_tree[7]

      add_data = { sex_id:            sex_id,                # add_row_to_tree[1]
                   base_tree_id:      base_profile_tree_id,
                   left_profile_id:   profile_id,            # add_row_to_tree[0]
                   left_name_id:      name_id,               # add_row_to_tree[2]
                   new_relation_id:   new_relation_id }      # add_row_to_tree[4]

      add_relation_data = { new_profile_id:          new_profile_id,            # add_row_to_tree[5]
                            new_profile_name_id:     new_profile_name_id,       # add_row_to_tree[6]
                            # display_name_id:         display_name_id,           # add_row_to_tree[3]
                            # new_prf_display_name_id: new_prf_display_name_id  # add_row_to_tree[7]
                            }

      add_main_pkeys_rows(add_data, add_relation_data)

      case new_relation_id
        when 1
          add_father_p_keys(base_sex_id, base_profile_tree_id, add_relation_data)
        when 2
          add_mother_p_keys(base_sex_id, base_profile_tree_id, add_relation_data)
        when 3
          add_son_p_keys(base_sex_id, base_profile_tree_id, add_relation_data)
        when 4
          add_daugther_p_keys(base_sex_id, base_profile_tree_id, add_relation_data)
        when 5
          add_brother_p_keys(base_sex_id, base_profile_tree_id, add_relation_data)
        when 6
          add_sister_p_keys(base_sex_id, base_profile_tree_id, add_relation_data)
        when 7
          add_husband_p_keys(base_profile_tree_id, add_relation_data)
        when 8
          add_wife_p_keys(base_profile_tree_id, add_relation_data)
        else
          flash.now[:alert] = "Alert from server! Добавление нового профиля не произошло:
                               отсутствует новое отношение нового профиля <new_relation_id>. "
      end

    end


    # Добавление нового ряда в таблицу ProfileKey
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    def add_profile_key_row(add_row_data)

      if Profile.check_profiles_exists?(add_row_data[:left_profile_id], add_row_data[:rigth_profile_id])
        new_profile_key_row = ProfileKey.new
        new_profile_key_row.user_id             = add_row_data[:base_tree_id]  # @current_user_id
        new_profile_key_row.profile_id          = add_row_data[:left_profile_id]
        new_profile_key_row.name_id             = add_row_data[:left_name_id]
        # new_profile_key_row.display_name_id     = add_row_data[:left_display_name_id]
        new_profile_key_row.relation_id         = add_row_data[:new_relation_id]
        new_profile_key_row.is_profile_id       = add_row_data[:rigth_profile_id]
        new_profile_key_row.is_name_id          = add_row_data[:rigth_profile_name_id]
        # new_profile_key_row.is_display_name_id  = add_row_data[:rigth_display_name_id]
        ########################
        new_profile_key_row.save
        # puts "= add_row = #{add_row_data.inspect}" # Для показа в Тесте
      end
    end

    # Добавление 2-x новых БАЗОВЫХ рядов в таблицу ProfileKey
    # @note GET /
    # def add_two_main_ProfileKeys_rows(base_profile_tree_id, profile_id, sex_id, name_id, new_relation_id, add_relation_data )
    def add_main_pkeys_rows(add_data, add_relation_data )

      sex_id                = add_data[:sex_id]
      base_profile_tree_id  = add_data[:base_tree_id]
      profile_id            = add_data[:left_profile_id]
      name_id               = add_data[:left_name_id]
      new_relation_id       = add_data[:new_relation_id]

      new_profile_id          = add_relation_data[:new_profile_id]
      new_profile_name_id     = add_relation_data[:new_profile_name_id]
      # display_name_id         = add_relation_data[:display_name_id]
      # new_prf_display_name_id = add_relation_data[:new_prf_display_name_id]

      @reverse_relation_id = Relation.where(:relation_id => new_relation_id, :origin_profile_sex_id => sex_id)[0].reverse_relation_id
      # Отношение_Обратное_Новому

      # Добавить ряд Профиль_К_Кому_Добавили - Новое_Отношение - Новый_профиль
      add_data_1row = {  base_tree_id: base_profile_tree_id,
                         left_profile_id: profile_id,
                         left_name_id: name_id,
                         # left_display_name_id: display_name_id,
                         new_relation_id: new_relation_id,
                         rigth_profile_id: new_profile_id,
                         rigth_profile_name_id: new_profile_name_id
                         # rigth_display_name_id: new_prf_display_name_id
                          }
      add_profile_key_row(add_data_1row)

      # Добавить ряд Новый_профиль - Отношение_Обратное_Новому - Профиль_К_Кому_Добавили
      add_data_2row = { base_tree_id: base_profile_tree_id,
                        left_profile_id: new_profile_id,
                        left_name_id: new_profile_name_id,
                        # left_display_name_id: new_prf_display_name_id,
                        new_relation_id: @reverse_relation_id,
                        rigth_profile_id: profile_id,
                        rigth_profile_name_id: name_id
                        # rigth_display_name_id: display_name_id
                        }
      add_profile_key_row(add_data_2row)

    end

    # Добавление Комбинации рядов родства любого вида в ProfileKeys при вводе нового профиля
    # (Хэш_родста, профиль_Кого_добавляем, имя_Кого_добавляем, Пол_родства_того_С_Кем_делаем_новый_ряд)
    # @note GET /
    # @see News
    def fill_relation_rows(base_profile_tree_id, relation_name_hash, sex_id, relation_id, add_relation_data ) # new_profile_id, new_profile_name_id, display_name_id, new_prf_disp_name_id)
      unless relation_name_hash.blank?
        # Если существуют члены БК с родством relation_name_hash к Профилю, к кот. добавляем Новый_Профиль
        new_profile_id          = add_relation_data[:new_profile_id]
        new_profile_name_id     = add_relation_data[:new_profile_name_id]

        profiles_arr = relation_name_hash.keys  # profile_id array
        names_arr = relation_name_hash.values   # name_id array
        unless names_arr.blank?
          for arr_ind in 0 .. names_arr.length - 1

            # извлечение полей display_name_id для обоих профилей
            # disp_name_id = Profile.find(profiles_arr[arr_ind]).display_name_id
            # is_disp_name_id = Profile.find(new_profile_id).display_name_id

            # запись с прямым отношением
            add_data_1row = {  base_tree_id: base_profile_tree_id,
                               left_profile_id: profiles_arr[arr_ind],
                               left_name_id: names_arr[arr_ind],
                               # left_display_name_id: disp_name_id,
                               new_relation_id: relation_id,
                               rigth_profile_id: new_profile_id,
                               rigth_profile_name_id: new_profile_name_id
                               # rigth_display_name_id: is_disp_name_id
                               }
            add_profile_key_row(add_data_1row)

            # извлечение обратного отношения
            current_reverse_relation_id = Relation.where(:relation_id => relation_id, :origin_profile_sex_id => sex_id)[0].reverse_relation_id

            # запись c обратным отношением
            add_data_2row = { base_tree_id: base_profile_tree_id,
                              left_profile_id: new_profile_id,
                              left_name_id: new_profile_name_id,
                              # left_display_name_id: is_disp_name_id,
                              new_relation_id: current_reverse_relation_id,
                              rigth_profile_id: profiles_arr[arr_ind],
                              rigth_profile_name_id: names_arr[arr_ind]
                              # rigth_display_name_id: disp_name_id
                              }
            add_profile_key_row(add_data_2row)

          end
        end
      end
    end

    # Добавить ряды в ProfileKeys при вводе Отца
    # в первом элементе мессива - данные об Авторе
    # в последнем элементе мессива - данные о Отца
    # @note GET /
    # @see News
    def add_father_p_keys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # puts "== In add_father_to_ProfileKeys:: @daughters_hash = #{@daughters_hash.inspect}"
      # puts "== In add_father_to_ProfileKeys:: @sons_hash = #{@sons_hash.inspect}"
      # puts "== In add_father_to_ProfileKeys:: @brothers_hash = #{@brothers_hash.inspect}"

      #new_profile_id          = add_relation_data[:new_profile_id]
      #new_profile_name_id     = add_relation_data[:new_profile_name_id]
      #display_name_id         = add_relation_data[:display_name_id]
      #new_prf_display_name_id = add_relation_data[:new_prf_display_name_id]

      # Хэш_родста, Пол_родства_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 7, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 1, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 1, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard

      # puts "== In add_father_to_ProfileKeys:: base_sex_id = #{base_sex_id.inspect}"

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
    def add_mother_p_keys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_с_Добавляемым, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 8, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @brothers_hash, 1, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sisters_hash, 0, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard

      # new relations
      # logger.info "== In add_mother_to_ProfileKeys:: base_sex_id = #{base_sex_id.inspect}"
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
    def add_son_p_keys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
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
    def add_daugther_p_keys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @wives_hash, 0, 4, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @husbands_hash, 1, 4, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ### NonStandard
      fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 6, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 6, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)

      # new relations
      # logger.info "== In add_mother_to_ProfileKeys:: base_sex_id = #{base_sex_id.inspect}"

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
    def add_brother_p_keys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
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
    def add_sister_p_keys(base_sex_id, base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
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
    def add_husband_p_keys(base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
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
    def add_wife_p_keys(base_profile_tree_id, add_relation_data ) #new_profile_id, new_profile_name_id)
      # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
      fill_relation_rows(base_profile_tree_id, @husbands_hash, 1, 8, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @sons_hash, 1, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)
      fill_relation_rows(base_profile_tree_id, @daughters_hash, 0, 2, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)

      # new relations
      fill_relation_rows(base_profile_tree_id, @fathers_hash, 1, 17, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###
      fill_relation_rows(base_profile_tree_id, @mothers_hash, 0, 17, add_relation_data ) #new_profile_id, new_profile_name_id, display_name_id, new_prf_display_name_id)  ###

    end


    # @note GET /
    # определяются массивы имен всех существующих членов БК
    # @see News tree_ids
    # Сбор Хэшей имен вокруг базового профиля - для работы генерации profile_keys
    # Получит хэши имен ближнего круга
    # вокруг базового профиля с учетом хэша исключений - от нестандартных ответов.
    def get_bk_relative_names(tree_ids, base_profile_id, exclusions_hash)
      # puts "============ In get_bk_relative_names ==== exclusions_hash: #{exclusions_hash}"

      @fathers_hash = Profile.find(base_profile_id).fathers_hash(tree_ids)
      # puts "== @fathers_hash = #{@fathers_hash}"
      @mothers_hash = Profile.find(base_profile_id).mothers_hash(tree_ids)
      # puts "== @mothers_hash = #{@mothers_hash}"
      @brothers_hash = Profile.find(base_profile_id).brothers_hash(tree_ids)
      # puts "== @brothers_hash = #{@brothers_hash}"
      @sisters_hash = Profile.find(base_profile_id).sisters_hash(tree_ids)
      # puts "== @sisters_hash = #{@sisters_hash}"
      @wives_hash = Profile.find(base_profile_id).wives_hash(tree_ids)
      # puts "== @wives_hash = #{@wives_hash}"
      @husbands_hash = Profile.find(base_profile_id).husbands_hash(tree_ids)
      # puts "== @husbands_hash = #{@husbands_hash}"
      @sons_hash = Profile.find(base_profile_id).sons_hash(tree_ids)
      # puts "== @sons_hash = #{@sons_hash}"
      @daughters_hash = Profile.find(base_profile_id).daughters_hash(tree_ids)
      # puts "== @daughters_hash = #{@daughters_hash}"

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
    end


    # Редакция хэшей ближнего кругав зависимости от ответов на вопросы
    # в нестандартных ситуациях.
    def proceed_exclusions_profile(members_hash, exclusions_hash)
      exclusions_hash.each do |key, val|
          members_hash.each do |k,v|
            members_hash.delete_if {|k, v| k.to_i == key.to_i && val.to_i == 0.to_i}
          end
      end
      members_hash
    end


  end

end
