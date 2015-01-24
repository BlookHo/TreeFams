# Модуль объединения (замещения) профилей при объединении деревьев
module SimilarsProfileMerge
  extend ActiveSupport::Concern

  module ClassMethods
    # profiles_to_rewrite - массив профилей, которые остаются
    # profiles_to_destroy - массив профилей, которые удаляются, а их данные переносятся в opposite_profile_ids
    def profiles_merge(connection_data )
      profiles_to_delete = []
      profiles_to_rewrite = connection_data[:profiles_to_rewrite]
      profiles_to_destroy = connection_data[:profiles_to_destroy]
      # connected_users_arr = connection_data[:connected_users_arr]
      connection_id       = connection_data[:connection_id]
      logger.info "Starting merge profile: profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy}"

      log_profiles_connection = []

    # profiles_to_rewrite =     [35, 41, 44, 42, 52]
    # profiles_to_destroy = [39, 40, 43, 38, 34]

    profiles_to_rewrite.each_with_index do |profile_id, index|

        main_profile     = Profile.find(profile_id)
        opposite_profile = Profile.find(profiles_to_destroy[index])

        logger.info "Данный из профиля  #{opposite_profile.id} будут перенесены в профиль #{main_profile.id}"
        # перенос profile_datas
    #    main_profile.profile_datas << opposite_profile.profile_datas

        # e-mail хранится в юзере
        # перезаписать и e-mail

        # обновление profile_id у юзера, владельца профиля
        # В случаи, если юзер есть у main_profile - ничего не делаем:
        # у этого юзера profile_id остается тем же
        # Если юзер есть у opposite_profile, котрый будет удален,
        # то линкуем юзера к новому профилю
      if opposite_profile.user.present?
        logger.info "Юзер  #{opposite_profile.user.id} будут перелинкован на профиль #{main_profile.id}"

        # 1      opposite_profile.user.update_column(:profile_id, main_profile.id)

        opposite_profile_user_row_id = opposite_profile.user.id
        logger.info "In merge profile: opposite_profile_user_row_id =  #{opposite_profile_user_row_id}"
        opposite_profile_id = opposite_profile.id
        logger.info "In merge profile: opposite_profile_id =  #{opposite_profile_id}"
        opposite_profile_user_profile_id = opposite_profile.user.profile_id
        logger.info "In merge profile: opposite_profile_user_profile_id =  #{opposite_profile_user_profile_id.inspect} "

        one_connection_data = { connected_at: connection_id,
                               table_name: 'User',
                               table_row_id: opposite_profile.user.id,
                               table_field: "profile_id",
                               profile_wrote: main_profile.id,
                               profile_destroyed: opposite_profile.id }
        log_profiles_connection << one_connection_data

        make_user_log(one_connection_data)
        one_connection_data = {}

     # 2      main_profile.update_column(:user_id, opposite_profile.user_id)
     # 3      main_profile.update_column(:tree_id, opposite_profile.tree_id)
          # кроме того здесь нужно писать прежний user_id в поле user_id Profiles для профиля юзера,
          # чей профиль будет удален
          # Зачем, если он будет удален?
     # 4 Если не удаляем opposite_profile профили, то убрать из поля user_id прежний номер user_id - просто nil
          # Чтобы не было 2-х профилей с одинак. полем user_id/

        end
        #logger.info "Профиля  #{opposite_profile.id} будет удален"
        ## Удаление opposite_profile
        profiles_to_delete << opposite_profile
      end
      #logger.info "Профиля  #{opposite_profile.id} будет удален"
      # Удаление opposite_profile
      #   profiles_to_delete.uniq.map(&:destroy)

      log_profiles_connection

    end

    def make_user_log(one_connection_data)

      logger.info "!!!! make_one_log: one_connection_data = #{one_connection_data}"


    end




  end
end
