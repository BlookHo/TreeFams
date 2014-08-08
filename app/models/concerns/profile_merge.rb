# Модуль объединения (замещения) профилей при объединении деревьев
module ProfileMerge
  extend ActiveSupport::Concern

  module ClassMethods
    # main_profile_ids - массив профилей, которые остаются
    # opposite_profile_ids - массив профилей, которые удаляются, а их данные переносятся в opposite_profile_ids
    def merge(main_profile_ids, opposite_profile_ids)
      logger.info "Starting merge profile"

      profiles_to_delete = []

      # fix
      # main_profile_ids = main_profile_ids.uniq!
      # opposite_profile_ids = opposite_profile_ids.uniq!


      main_profile_ids.each_with_index do |profile_id, index|

        logger.info "============== Start mergin cycle"
        logger.info "main_profile_ids  #{main_profile_ids} текущий индекс #{index}"
        logger.info "opposite_profile_ids  #{opposite_profile_ids} текущий индекс #{index}"

        main_profile     = Profile.find(profile_id)
        opposite_profile = Profile.find(opposite_profile_ids[index])

        logger.info "Данные из профиля  #{opposite_profile.id} будут перенесены в профиль #{main_profile.id}"
        # перенос profile_datas
        # main_profile.profile_datas << opposite_profile.profile_datas


        logger.info "Opposite user #{opposite_profile.try(:user).try(:id)}"
        logger.info "Main user #{main_profile.try(:user).try(:id)}"

        logger.info "Opposite user profile#{opposite_profile.try(:user).try(:profile).try(:id)}"
        logger.info "Main user profile #{main_profile.try(:user).try(:profile).try(:id)}"

        # обновление profile_id у юзера, владельца профиля
        # В случаи, если юзер есть у main_profile - ничего не делаем:
        # у этого юзера profile_id остается тем же
        # Если юзер есть у opposite_profile, котрый будет удален,
        # то линкуем юзера к новому профилю
        if opposite_profile.user.present?
          logger.info "Юзер  #{opposite_profile.user.id} будут перелинкован на профиль #{main_profile.id}"
          opposite_profile.user.update_column(:profile_id, main_profile.id)
          main_profile.update_column(:user_id, opposite_profile.user_id)
          main_profile.update_column(:tree_id, opposite_profile.tree_id)
          # кроме того здесь нужно писать прежний user_id в поле user_id Profiles для профиля юзера,
          # чей профиль будет удален
          # Зачем, если он будет удален?
        end
        logger.info "Профиль  #{opposite_profile.id} будет удален"
        # Удаление opposite_profile
        # opposite_profile.destroy
        # Cобираем профили, которые потом надо удалить
        logger.info "Pre: #{profiles_to_delete.map(&:id)}"
        profiles_to_delete << opposite_profile
        logger.info "After: #{profiles_to_delete.map(&:id)}"

        if main_profile_ids.size == index + 1
          logger.info "Прерываем цикл!!!!!!!!"
          break
        end

      end
      logger.info "Вышли из цикла, профили на удаление: #{profiles_to_delete.map(&:id)}"
      # профиля могу дублироваться, поэтому оставляем только уникальные
      profiles_to_delete.uniq.map(&:destroy)
    end




  end
end
