# Модуль объединения (замещения) профилей при объединении деревьев
module ProfileMerge
  extend ActiveSupport::Concern
  #############################################################
  # Иванищев А.В. 2014 -2015
  #############################################################

  module ClassMethods

    # @note: main_profile_ids - массив профилей, которые остаются
    #   opposite_profile_ids - массив профилей, которые удаляются, а их данные переносятся в opposite_profile_ids
    def merge(connection_data)
      profiles_to_rewrite = connection_data[:profiles_to_rewrite]
      profiles_to_destroy = connection_data[:profiles_to_destroy]
      logger.info "Starting merge profile"
      logger.info "In merge profile: connection_data = #{connection_data}"

      log_connection_user_profile = []
      profiles_to_rewrite.each_with_index do |profile_id, index|

        main_profile     = Profile.find(profile_id)
        opposite_profile = Profile.find(profiles_to_destroy[index])
        logger.info "Данные из профиля  #{opposite_profile.id} будут перенесены в профиль #{main_profile.id}"

        # обновление profile_id у юзера, владельца профиля
        # В случаи, если юзер есть у main_profile - ничего не делаем:
        # у этого юзера profile_id остается тем же
        # Если юзер есть у opposite_profile, котрый будет удален,
        # то линкуем юзера к новому профилю
        if opposite_profile.user.present?
          logger.info "opposite_profile - is User: opposite_profile.user.id = #{opposite_profile.user.id}, profile_id = #{opposite_profile.id}"
          new_log_merge_profiles = []
          link_data = { main_profile:     main_profile,
                        opposite_profile: opposite_profile,
                        current_user_id:  connection_data[:current_user_id],
                        user_id:          connection_data[:user_id],
                        connected_at:     connection_data[:connection_id] }
          new_log_merge_profiles = user_profile_connection_link(link_data)
          log_connection_user_profile = log_connection_user_profile + new_log_merge_profiles
        end

      end

      log_connection_user_profile
    end


    # @note: Поочередное линкование Юзера и Профиля
    #   4 times update_column
    #   link_data = { main_profile: main_profile,
    #               opposite_profile: opposite_profile,
    def user_profile_connection_link(link_data)
      logger.info " In module Profile_Merge - user_profile_connection_link"
      log_profiles_connection = []

      main_profile      = link_data[:main_profile]
      current_user_id   = link_data[:current_user_id]
      user_id           = link_data[:user_id]
      opposite_profile  = link_data[:opposite_profile]
      connection_id     = link_data[:connected_at]

      # for RSpec
      @main_profile_id = main_profile.id
      main_profile_user_id = main_profile.user_id # previous value of this field before updates

      # 1 link
      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              with_user_id: user_id,        # int
                              table_name: 'users',
                              table_row: opposite_profile.user.id,
                              field: 'profile_id',
                              written: main_profile.id,
                              overwritten: opposite_profile.id }
      log_profiles_connection = collect_one_connection_log(log_profiles_connection, one_connection_data)
      opposite_profile.user.update_attributes(:profile_id => main_profile.id, :updated_at => Time.now)
      logger.info "# 1 link #"

      # 2 link
      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              with_user_id: user_id,        # int
                              table_name: 'profiles',
                              table_row: main_profile.id,
                              field: 'user_id',
                              written: opposite_profile.user_id,
                              overwritten: nil } # should be nil  # overwritten: main_profile_user_id }

      log_profiles_connection = collect_one_connection_log(log_profiles_connection, one_connection_data)
      main_profile.update_attributes(:user_id => opposite_profile.user_id, :updated_at => Time.now)
      logger.info "# 2 link #"

      # 3 link
      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              with_user_id: user_id,        # int
                              table_name: 'profiles',
                              table_row: main_profile.id,
                              field: 'tree_id',
                              written: opposite_profile.tree_id,
                              overwritten: main_profile.tree_id }
      log_profiles_connection = collect_one_connection_log(log_profiles_connection, one_connection_data)
      main_profile.update_attributes(:tree_id => opposite_profile.tree_id, :updated_at => Time.now)
      logger.info "# 3 link #"

      # 4 link
      # Если не удаляем opposite_profile профили, то убрать из поля user_id прежний номер user_id - просто nil
      # Чтобы не было 2-х профилей с одинак. полем user_id/
      one_connection_data = { connected_at: connection_id,
                              current_user_id: current_user_id,
                              with_user_id: user_id,        # int
                              table_name: 'profiles',
                              table_row: opposite_profile.id,
                              field: 'user_id',
                              written: nil,   # should be nil # written: main_profile_user_id,
                              overwritten: opposite_profile.user_id }
      log_profiles_connection = collect_one_connection_log(log_profiles_connection, one_connection_data)
      opposite_profile.update_column(:user_id, nil) # ONLY SO!!!
      logger.info "# 4 link #"

      log_profiles_connection
    end

    # @note: Для Сохранения одного лога в табл.ConnectionLog
    def collect_one_connection_log(log_user_profiles, one_connection_data)
      log_user_profiles << ConnectionLog.new(one_connection_data)
      log_user_profiles
    end

  end
end
