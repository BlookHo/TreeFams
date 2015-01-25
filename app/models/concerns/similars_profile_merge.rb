# Модуль объединения (замещения) профилей при объединении деревьев
module SimilarsProfileMerge
  extend ActiveSupport::Concern

  module ClassMethods

    # Перелинкование User на другой Profile - при необходимости
    # Перезапись profile_datas
    # profiles_to_rewrite - массив профилей, которые остаются
    # profiles_to_destroy - массив профилей, которые удаляются, а их данные переносятся в opposite_profile_ids
    def profiles_merge(connection_data)
      profiles_to_delete = []
      profiles_to_rewrite = connection_data[:profiles_to_rewrite]
      profiles_to_destroy = connection_data[:profiles_to_destroy]
      # connected_users_arr = connection_data[:connected_users_arr]
      connection_id       = connection_data[:connection_id]
      #logger.info "Starting merge profile: profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy}"

      log_profiles_connection = []

      profiles_to_rewrite.each_with_index do |profile_id, index|

        main_profile     = Profile.find(profile_id)
        opposite_profile = Profile.find(profiles_to_destroy[index])

        #logger.info "Данный из профиля  #{opposite_profile.id} будут перенесены в профиль #{main_profile.id}"
        # перенос profile_datas
        #######################################
     #    main_profile.profile_datas << opposite_profile.profile_datas

        # обновление profile_id у юзера, владельца профиля
        # В случаи, если юзер есть у main_profile - ничего не делаем:
        # у этого юзера profile_id остается тем же
        # Если юзер есть у opposite_profile, котрый будет удален,
        # то линкуем юзера к новому профилю
        if opposite_profile.user.present?

          link_data = { main_profile: main_profile,
                        opposite_profile: opposite_profile,
                        connected_at: connection_data[:connection_id] }
          log_profiles_connection = make_user_profile_link(link_data)

        end
        #logger.info "Профиля  #{opposite_profile.id} будет удален"
        ## Удаление opposite_profile
        # profiles_to_delete << opposite_profile

      end
      #logger.info "Профиля  #{opposite_profile.id} будет удален"
      # НЕ Удаление opposite_profile
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
      opposite_profile = link_data[:opposite_profile]
      connection_id = link_data[:connected_at]

      # 1 link #################################
  #    opposite_profile.user.update_column(:profile_id, main_profile.id)

      one_connection_data = { connected_at: connection_id,
                              table_name: 'User',
                              table_row_id: opposite_profile.user.id,
                              table_field: "profile_id",
                              written: main_profile.id }
      log_profiles_connection << one_connection_data
      logger.info "In make_user_profile_link: one_connection_data =  #{one_connection_data.inspect} "
      {:connected_at=>11, :table_name=>"User", :table_row_id=>5, :table_field=>"profile_id", :written=>52}

      # 2 link ##################################
  #    main_profile.update_column(:user_id, opposite_profile.user_id)

      one_connection_data = { connected_at: connection_id,
                              table_name: 'Profile',
                              table_row_id: main_profile.id,
                              table_field: "user_id",
                              written: opposite_profile.user_id }
      log_profiles_connection << one_connection_data
      logger.info "In make_user_profile_link: one_connection_data =  #{one_connection_data.inspect} "
      {:connected_at=>11, :table_name=>"Profile", :table_row_id=>52, :table_field=>"user_id", :written=>5}

      # 3 link ###################################
  #     main_profile.update_column(:tree_id, opposite_profile.tree_id)

      one_connection_data = { connected_at: connection_id,
                              table_name: 'Profile',
                              table_row_id: main_profile.id,
                              table_field: "tree_id",
                              written: opposite_profile.tree_id }
      log_profiles_connection << one_connection_data
      logger.info "In make_user_profile_link: one_connection_data =  #{one_connection_data.inspect} "
      {:connected_at=>11, :table_name=>"Profile", :table_row_id=>52, :table_field=>"tree_id", :written=>5}

      # 4 link ###################################
  #    opposite_profile.update_column(:user_id, nil)
      # Если не удаляем opposite_profile профили, то убрать из поля user_id прежний номер user_id - просто nil
      # Чтобы не было 2-х профилей с одинак. полем user_id/

      one_connection_data = { connected_at: connection_id,
                              table_name: 'Profile',
                              table_row_id: opposite_profile.id,
                              table_field: "user_id",
                              written: nil }
      log_profiles_connection << one_connection_data
      logger.info "In make_user_profile_link: one_connection_data =  #{one_connection_data.inspect} "
      {:connected_at=>11, :table_name=>"Profile", :table_row_id=>34, :table_field=>"user_id", :written=>nil}

      log_profiles_connection
    end




  end
end
