# Модуль объединения (замещения) профилей при объединении деревьев
module SimilarsProfileMerge
  extend ActiveSupport::Concern

  module ClassMethods
    # main_profile_ids - массив профилей, которые остаются
    # opposite_profile_ids - массив профилей, которые удаляются, а их данные переносятся в opposite_profile_ids
    def profiles_merge(main_profile_ids, opposite_profile_ids)
      logger.info "Starting merge profile: to_rewrite = #{main_profile_ids},  to_destroy = #{opposite_profile_ids}"
      profiles_to_delete = []

      log_profiles_connection = {}

      main_profile_ids.each_with_index do |profile_id, index|

        main_profile     = Profile.find(profile_id)
        opposite_profile = Profile.find(opposite_profile_ids[index])

        logger.info "Данный из профиля  #{opposite_profile.id} будут перенесены в профиль #{main_profile.id}"
        # перенос profile_datas
    #    main_profile.profile_datas << opposite_profile.profile_datas

        # e-mail хранится в юзере
        # перезаписать и e-mail

        opposite_rewrite_row_id = opposite_profile.id
        logger.info "In merge profile: opposite_rewrite_row_id =  #{opposite_rewrite_row_id}"

        rewrite_row_id = main_profile.id
        rewrite_user_id = main_profile.user_id
        rewrite_tree_id = main_profile.tree_id
        logger.info "In merge profile: rewrite_row_id =  #{rewrite_row_id.inspect}, rewrite_user_id =  #{rewrite_user_id.inspect}, rewrite_tree_id =  #{rewrite_tree_id.inspect}"

        # one_connection_data = { #connected_at: connection_id,
        #                         table_name: 'User',
        #                         table_row_id: rewrite_row.id,
        #                         table_field: table_field,
        #                         profile_wrote: profiles_to_rewrite[arr_ind],
        #                         profile_destroyed: profiles_to_destroy[arr_ind] }
        #
        # logger.info "In merge profile: one_connection_data =  #{one_connection_data}"

     #   log_profiles_connection << one_connection_data

        # обновление profile_id у юзера, владельца профиля
        # В случаи, если юзер есть у main_profile - ничего не делаем:
        # у этого юзера profile_id остается тем же
        # Если юзер есть у opposite_profile, котрый будет удален,
        # то линкуем юзера к новому профилю
   #     if opposite_profile.user.present?
        if main_profile.user.present?
            logger.info "Юзер  #{main_profile.user.id} будут перелинкован на профиль #{main_profile.id}"
          opposite_rewrite_user_row_id = main_profile.user.id
          logger.info "In merge profile: opposite_rewrite_user_row_id =  #{opposite_rewrite_user_row_id}"

     # 1      opposite_profile.user.update_column(:profile_id, main_profile.id)

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

    end

  end
end
