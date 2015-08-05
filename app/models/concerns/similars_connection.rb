module SimilarsConnection
  extend ActiveSupport::Concern
  # in User model

  # @note Основной метод объединения похожих профилей в одном дереве
  # @params Первый и Второй похожие профили из одной пары
  def similars_connection(first_profile_connecting, second_profile_connecting)

    #################################################
    rewrite_to_clean, destroy_to_clean, init_hash = self.similars_complete_search(first_profile_connecting, second_profile_connecting)
    #################################################
    logger.info "TEST similars_connection : clean_profiles_arrs: rewrite_to_clean = #{rewrite_to_clean} , destroy_to_clean = #{destroy_to_clean} "

    #### update profiles arrays ###########
    profiles_to_rewrite, profiles_to_destroy = clean_profiles_arrs(rewrite_to_clean, destroy_to_clean)
    logger.info "TEST similars_connection : clean_profiles_arrs: profiles_to_rewrite = #{profiles_to_rewrite} , profiles_to_destroy = #{profiles_to_destroy} "

    # Перезапись profile_data при объединении профилей
    ProfileData.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy)

    last_log_id = SimilarsLog.last.connected_at unless SimilarsLog.all.empty?
    # logger.info "*** In connect_similars last_log_id = #{last_log_id.inspect}"
    # порядковый номер connection - взять значение из последнего лога
    last_log_id == nil ? last_log_id = 1 : last_log_id += 1
    # logger.info "*** In connect_similars last_log_id = #{last_log_id.inspect}"

    similars_connection_data = {profiles_to_rewrite: profiles_to_rewrite, #
                                profiles_to_destroy: profiles_to_destroy,
                                current_user_id: self.id,
                                connection_id: last_log_id }
    ######## call of User.module Similars_connection
    log_connection = self.similars_connect_tree(similars_connection_data)

        {init_hash: init_hash,                       # for RSpec & TO_VIEW
         profiles_to_rewrite: profiles_to_rewrite,   # for RSpec & TO_VIEW
         profiles_to_destroy: profiles_to_destroy,   # for RSpec & TO_VIEW
         last_log_id: log_connection
        }

  end



  def clean_profiles_arrs(profiles_to_rewrite, profiles_to_destroy)
    clean_to_rewrite = []
    clean_to_destroy = []
    profiles_to_rewrite.each_with_index do |profile_id, index|
      if profile_id != profiles_to_destroy[index]
        clean_to_rewrite << profile_id
        clean_to_destroy << profiles_to_destroy[index]
      end
    end
    return clean_to_rewrite, clean_to_destroy
  end


  # Перезапись профилей в таблицах
  # Формирование лога объединения - получение его log_id
  # Запись лога в таблицу SimilarsLog под номером log_id
  def similars_connect_tree(connection_data)

    connected_users_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    connection_data[:connected_users_arr] = connected_users_arr

    # tree_info = get_tree_info(self)
    # logger.info "CCCCC In similars_connect_tree : tree_info[:tree_is_profiles] = #{tree_info[:tree_is_profiles]}, @tree_info[:connected_users] = #{tree_info[:connected_users]}"#", tree_info = #{tree_info},  "

    # todo: Сделать логирование перезаписи Profile_datas - или см. в файле SimilarsProfileMerge.rb строки 28 ?
    # Перезапись profile_data при объединении профилей
    #  ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)

    #########  перезапись profile_id's & update User
     log_connection_user_profile = Profile.profiles_merge(connection_data)
  #  log_connection_user_profile = []
    # todo:Раскоммитить 2 строки ниже и закоммитить 2 строки за ними  - для полной перезаписи логов и отладки
    #########  перезапись profile_id's в Tree и ProfileKey
    log_connection_tree       = update_table(connection_data, Tree)
    log_connection_profilekey = update_table(connection_data, ProfileKey)
    # log_connection_tree = []
    # log_connection_profilekey = []

    common_sims_log = {  log_user_profile: log_connection_user_profile,  log_tree: log_connection_tree, log_profilekey: log_connection_profilekey }
    complete_log_arr = common_sims_log[:log_user_profile] + common_sims_log[:log_tree] + common_sims_log[:log_profilekey]

    # Запись массива лога в таблицу SimilarsLog под номером log_id
    SimilarsLog.store_log(complete_log_arr) unless complete_log_arr.blank?

    data_to_clear = { profiles_to_rewrite: connection_data[:profiles_to_rewrite],
                      profiles_to_destroy: connection_data[:profiles_to_destroy],
                      connected_users_arr: connection_data[:connected_users_arr]   }

    ### Удаление сохраненных ранее найденных пар похожих
    SimilarsFound.clear_similars_found(data_to_clear)
    logger.info "# CONN ##*** In module SimilarsConnection common_sims_logs: #{common_sims_log.inspect} "

    # Запись строки Общего лога в таблицу CommonLog
    make_sims_connec_common_log(connection_data)

    # connection_data = {profiles_to_rewrite: profiles_to_rewrite, #
    #                             profiles_to_destroy: profiles_to_destroy,
    #                             current_user_id: current_user.id,
    #                             connection_id: last_log_id }

    ##########  UPDATES FEEDS - № 19  # similars_connect ###################
    profile_current_user = User.find(connection_data[:current_user_id]).profile_id
    update_feed_data = { user_id:           connection_data[:current_user_id] ,    #
                         update_id:         19,                  #
                         agent_user_id:     connection_data[:current_user_id],   #
                         read:              false,              #
                         agent_profile_id:  profile_current_user,        #
                         who_made_event:    connection_data[:current_user_id] }   #
    logger.info "In SimilarsConnection: Before create UpdatesFeed   update_feed_data= #{update_feed_data} "
    # update_feed_data= {:user_id=>1, :update_id=>4, :agent_user_id=>2, :read=>false, :agent_profile_id=>219, :who_made_event=>1} (pid:16287)

    UpdatesFeed.create(update_feed_data) #

    common_sims_log
  end

  # {:log_user_profile=>[],
  #  :log_tree=>[#<SimilarsLog id: 3972, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 40, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3973, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 47, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3974, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 38, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3975, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 37, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3976, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 38, field: "is_profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3977, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 37, field: "is_profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3978, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 40, field: "is_profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3979, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 31, field: "is_profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
       # #<SimilarsLog id: 3980, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 47, field: "is_profile_id", written: 34, overwritten: 52, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">
       # ],
       # :log_profilekey=>[#<SimilarsLog id: 3981, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 246, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3982, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 253, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3983, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 244, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3984, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 295, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3985, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 245, field: "profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3986, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 242, field: "profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3987, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 240, field: "profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3988, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 297, field: "profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3989, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 255, field: "profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3990, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 256, field: "profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3991, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 258, field: "profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3992, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 299, field: "profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3993, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 254, field: "profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3994, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 204, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3995, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 243, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3996, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 206, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3997, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 202, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3998, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 239, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 3999, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 257, field: "profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 4000, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 296, field: "profile_id", written: 34, overwritten: 52, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 4001, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 300, field: "profile_id", written: 34, overwritten: 52, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 4002, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 298, field: "profile_id", written: 34, overwritten: 52, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
           # #<SimilarsLog id: 4003, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 243, field: "is_profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
   # #<SimilarsLog id: 4004, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 245, field: "is_profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
   # #<SimilarsLog id: 4005, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 296, field: "is_profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,
   # #<SimilarsLog id: 4006, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 254, field: "is_profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4007, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 239, field: "is_profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4008, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 246, field: "is_profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4009, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 241, field: "is_profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4010, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 256, field: "is_profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4011, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 298, field: "is_profile_id", written: 40, overwritten: 41, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4012, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 300, field: "is_profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4013, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 253, field: "is_profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4014, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 255, field: "is_profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4015, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 257, field: "is_profile_id", written: 43, overwritten: 44, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4016, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 203, field: "is_profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4017, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 205, field: "is_profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4018, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 201, field: "is_profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4019, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 258, field: "is_profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4020, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 240, field: "is_profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">, #<SimilarsLog id: 4021, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 244, field: "is_profile_id", written: 39, overwritten: 35, created_at: "2015-02-12 10:55:32", updated_at: "2015-02-12 10:55:32">, #<SimilarsLog id: 4022, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 299, field: "is_profile_id", written: 34, overwritten: 52, created_at: "2015-02-12 10:55:32", updated_at: "2015-02-12 10:55:32">, #<SimilarsLog id: 4023, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 297, field: "is_profile_id", written: 34, overwritten: 52, created_at: "2015-02-12 10:55:32", updated_at: "2015-02-12 10:55:32">, #<SimilarsLog id: 4024, connected_at: 5, current_user_id: 5, table_name: "profile_keys", table_row: 295, field: "is_profile_id", written: 34, overwritten: 52, created_at: "2015-02-12 10:55:32", updated_at: "2015-02-12 10:55:32">]
   #         }


  # перезапись значений в полях одной таблицы
  def update_table(connection_data, table )
    log_connection = []

    # ТЕСТ
    # name_of_table = table.table_name
    # logger.info "*** In module SimilarsConnection update_table: name_of_table = #{name_of_table.inspect} "
    # model = name_of_table.classify.constantize
    # logger.info "*** In module SimilarsConnection update_table: model = #{model.inspect} "
    # logger.info "*** In module SimilarsConnection update_table: table = #{table.inspect} "

    connection_data[:table_name] = table.table_name
    ['profile_id', 'is_profile_id'].each do |table_field|
      table_update_data = { table: table, table_field: table_field}
      logger.info "*** In module SimilarsConnection update_table: table_update_data = #{table_update_data.inspect} "
      log_connection = update_field(connection_data, table_update_data , log_connection)
    end
    log_connection
  end

  # перезапись значений в одном поле одной таблицы
  # profiles_to_destroy[arr_ind] - один profile_id для замены
  # profiles_to_rewrite[arr_ind] - один profile_id, которым меняем
  def update_field(connection_data, table_update_data, log_connection)

    table_name          = connection_data[:table_name]
    current_user_id     = connection_data[:current_user_id]
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    connected_users_arr = connection_data[:connected_users_arr]
    connection_id       = connection_data[:connection_id]

    table       = table_update_data[:table]
    table_field = table_update_data[:table_field]

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      rows_to_update = table.where(:user_id => connected_users_arr).
                             where(" #{table_field} = #{profiles_to_destroy[arr_ind]} " )
      logger.info "*** In module SimilarsConnection update_field: rows_to_update = #{rows_to_update.inspect} "

      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

          if table_field == 'profile_id'
            other_field_val = rewrite_row.is_profile_id
          else
            other_field_val = rewrite_row.profile_id
          end
          logger.info "*** In module SimilarsConnection update_field: other_field_val = #{other_field_val.inspect} "

          if other_field_val == profiles_to_rewrite[arr_ind]
            # Generate deleted = 1 log
            rewrite_row.update_attributes(:deleted => 1, :updated_at => Time.now)
            one_connection_data = { connected_at: connection_id,              # int
                                    current_user_id: current_user_id,        # int
                                    table_name: table_name,                  # string
                                    table_row: rewrite_row.id,            # int
                                    field: 'deleted',                 # string
                                    written: 1,        # int
                                    overwritten: 0 }        # int
            logger.info "*** In module update_field: Deleted log "

          else

            rewrite_row.update_attributes(:"#{table_field}" => profiles_to_rewrite[arr_ind], :updated_at => Time.now)
            one_connection_data = { connected_at: connection_id,              # int
                                    current_user_id: current_user_id,        # int
                                    table_name: table_name,                  # string
                                    table_row: rewrite_row.id,            # int
                                    field: table_field,                 # string
                                    written: profiles_to_rewrite[arr_ind],        # int
                                    overwritten: profiles_to_destroy[arr_ind] }        # int
            logger.info "*** In module update_field: Field update log "

          end

          log_connection << SimilarsLog.new(one_connection_data)

        end

      end

    end
    log_connection

  end

  # todo: check connect sims create common_log & update_feed
  # @note: Сделать 1 запись в общие логи: в common_sims_logs
  def make_sims_connec_common_log(connection_data)
    logger.info "In make_sims_connec_common_log: Before common_log"
    current_log_type          = 3  # connection trees: rollback == disconnect similars. Тип = разъединение similars при rollback
    current_user_id           = connection_data[:current_user_id]
    # user_id                   = connection_data[:user_id]
    common_connect_log_number = connection_data[:connection_id] # Берем тот номер соединения similars,
    # который идет из Conn_requests - номер запроса на соединение деревьев. Он - единый и не является порядковым, как
    # номера логов на добавление и удаление профилей, номера которыхформируются прямо в табл. CommonLogs.

    # puts "In make_sims_connec_common_log: current_user_id = #{current_user_id}"
    # puts "In make_sims_connec_common_log: connection_data = #{connection_data} "

    # new_common_log_number = CommonLog.new_log_id(current_user_id, current_log_type) # No use

    common_log_data = { user_id:         current_user_id,
                        log_type:        current_log_type,
                        log_id:          common_connect_log_number,
                        profile_id:      User.find(current_user_id).profile_id,
                        base_profile_id: User.find(current_user_id).profile_id,
                        new_relation_id: 888 }  # Условный код для лога объединения similars
    logger.info "In SimilarsConnection : Before create_common_log   common_log_data= #{common_log_data} "
    CommonLog.create_common_log(common_log_data)


  end



end
