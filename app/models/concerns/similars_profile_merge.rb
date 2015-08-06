# Модуль объединения (замещения) профилей при объединении деревьев
module SimilarsProfileMerge
  extend ActiveSupport::Concern
  # in Profile model

  module ClassMethods

    # Перелинкование User на другой Profile - при необходимости
    # Перезапись profile_datas
    # profiles_to_rewrite - массив профилей, которые остаются
    # profiles_to_destroy - массив профилей, которые удаляются, а их данные переносятся в opposite_profile_ids
    def profiles_merge(connection_data)
      profiles_to_rewrite = connection_data[:profiles_to_rewrite]
      profiles_to_destroy = connection_data[:profiles_to_destroy]
      # connected_users_arr = connection_data[:connected_users_arr]
      logger.info "Starting merge profile - cleaned arrays: profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy}"

      log_profiles_connection = []

      profiles_to_rewrite.each_with_index do |profile_id, index|

        if profile_id != profiles_to_destroy[index]
          main_profile = Profile.where(id: profile_id, deleted: 0)[0]
          opposite_profile = Profile.where(id: profiles_to_destroy[index], deleted: 0)[0]
          logger.info "Profile main_profile.id =  #{main_profile.id}:: opposite_profile.id =  #{opposite_profile.id} будет удален"
          # main_profile     = Profile.find(profile_id)
          # opposite_profile = Profile.find(profiles_to_destroy[index])

          # обновление profile_id у юзера, владельца профиля
          # В случаи, если юзер есть у main_profile - ничего не делаем:
          # у этого юзера profile_id остается тем же
          # Если юзер есть у opposite_profile, котрый будет удален,
          # то линкуем юзера к новому профилю
          if opposite_profile.user.present?

            link_data = { main_profile: main_profile,
                          opposite_profile: opposite_profile,
                          current_user_id: connection_data[:current_user_id],
                          connected_at: connection_data[:connection_id] }
            log_profiles_connection = make_user_profile_link(link_data)
          end

          ## Удаление opposite_profile   - OLD
          # profiles_to_delete << opposite_profile

          # Mark opposite_profile as deleted = Удаление opposite_profile
          opposite_profile.update_attribute('deleted', 1)
          logger.info "## Профил:  #{opposite_profile.id}  -  #{opposite_profile.deleted} after update"

          one_connection_data = { connected_at: connection_data[:connection_id],
                                  current_user_id: connection_data[:current_user_id],
                                  table_name: 'profiles',
                                  table_row: opposite_profile.id,
                                  field: 'deleted',
                                  written: 1,
                                  overwritten: 0 }
          log_profiles_connection = store_one_log(log_profiles_connection, one_connection_data)

        end

      end

      # Удаление opposite_profile's    - OLD
      #   profiles_to_delete.uniq.map(&:destroy)

      log_profiles_connection

    end

    # Поочередное линкование Юзера и Профиля
    # 4 update_column
    # link_data = { main_profile: main_profile,
    #               opposite_profile: opposite_profile,
    #               connected_at: connection_data[:connection_id] }
    def make_user_profile_link(link_data)

      log_profiles_connection = []

      main_profile = link_data[:main_profile]
      current_user_id = link_data[:current_user_id]
      opposite_profile = link_data[:opposite_profile]
      connection_id = link_data[:connected_at]
      logger.info "*** In module SimilarsConnection start make_user_profile_link: link_data = #{link_data.inspect} "

      # for RSpec
      @main_profile_id = main_profile.id

      # 1 link #################################


      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              table_name: 'users',
                              table_row: opposite_profile.user.id,
                              field: 'profile_id',
                              written: main_profile.id,
                              overwritten: opposite_profile.id }
      log_profiles_connection = store_one_log(log_profiles_connection, one_connection_data)
      ######################################
      logger.info "#* In module SimilarsConnection make_user_profile_link: main_profile.id = #{main_profile.id.inspect} "
      logger.info "#* In module SimilarsConnection make_user_profile_link: opposite_profile = #{opposite_profile.inspect} "
      logger.info "#* In module SimilarsConnection make_user_profile_link: opposite_profile.user = #{opposite_profile.user.inspect} "
      logger.info "#* In module SimilarsConnection make_user_profile_link: opposite_profile.user.profile_id = #{opposite_profile.user.profile_id.inspect} "

      logger.info "# 1 ##*** In module SimilarsConnection log_profiles_connection: #{log_profiles_connection.inspect} "
      opposite_profile.user.update_attributes(:profile_id => main_profile.id, :updated_at => Time.now)

      # 2 link ##################################

      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              table_name: 'profiles',
                              table_row: main_profile.id,
                              field: 'user_id',
                              written: opposite_profile.user_id,
                              overwritten: nil }
      log_profiles_connection = store_one_log(log_profiles_connection, one_connection_data)
      logger.info "# 2 ##*** In module SimilarsConnection log_profiles_connection: #{log_profiles_connection.inspect} "
      ######################################
     main_profile.update_attributes(:user_id => opposite_profile.user_id, :updated_at => Time.now)

      # 3 link ###################################

      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              table_name: 'profiles',
                              table_row: main_profile.id,
                              field: 'tree_id',
                              written: opposite_profile.tree_id,
                              overwritten: main_profile.tree_id }

      logger.info "*** In module SimilarsConnection make_user_profile_link: one_connection_data = #{one_connection_data.inspect} "
      log_profiles_connection = store_one_log(log_profiles_connection, one_connection_data)
      logger.info "# 3 ##*** In module SimilarsConnection log_profiles_connection: #{log_profiles_connection.inspect} "

      ######################################
     main_profile.update_attributes(:tree_id => opposite_profile.tree_id, :updated_at => Time.now)

      # 4 link ###################################
      # Если не удаляем opposite_profile профили, то убрать из поля user_id прежний номер user_id - просто nil
      # Чтобы не было 2-х профилей с одинак. полем user_id/

      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              table_name: 'profiles',
                              table_row: opposite_profile.id,
                              field: 'user_id',
                              written: nil,
                              overwritten: opposite_profile.user_id }
      log_profiles_connection = store_one_log(log_profiles_connection, one_connection_data)
      ######################################
      logger.info "*** In module SimilarsConnection make_user_profile_link: one_connection_data = #{one_connection_data.inspect} "
    opposite_profile.update_column(:user_id, nil) # ONLY SO!!!
      logger.info "###*** In module SimilarsConnection make_user_profile_link: opposite_profile.user_id = #{opposite_profile.user_id.inspect} "
      logger.info "###*** In module SimilarsConnection make_user_profile_link: opposite_profile.user.profile_id = #{opposite_profile.user.profile_id.inspect} "

      logger.info "# 4 ##*** In module SimilarsConnection log_profiles_connection: #{log_profiles_connection.inspect} "

      log_profiles_connection
    end

    # Сохранение одного лога в табл.SimilarsLog
    def store_one_log(log_user_profiles, one_connection_data)
      log_user_profiles << SimilarsLog.new(one_connection_data)
      log_user_profiles
    end

  end

end
