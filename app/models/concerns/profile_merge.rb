# Модуль объединения (замещения) профилей при объединении деревьев
module ProfileMerge
  extend ActiveSupport::Concern

  module ClassMethods
    # main_profile_ids - массив профилей, которые остаются
    # opposite_profile_ids - массив профилей, которые удаляются, а их данные переносятся в opposite_profile_ids
    def merge(main_profile_ids, opposite_profile_ids)
      logger.info "Starting merge profile"

      main_profile_ids.each_with_index do |profile_id, index|
        main_profile = Profile.find profile_id
        opposite_profile = Profile.find(opposite_profile_ids[index])


        logger.info "Данный из профиля  #{opposite_profile.id} будут перенесены в профиль #{main_profile.id}"
        # перенос profile_datas
        # main_profile.profile_datas << opposite_profile.profile_datas

        # обновление profile_id у юзера, владельца профиля
        # В случаи, если юзер есть у main_profile - ничего не делаем:
        # у этого юзера profile_id остается тем же
        # Если юзер есть у opposite_profile, котроый будет удален,
        # то линкуем юзера к новому профилю
        if opposite_profile.user.present?
          logger.info "Юзер  #{opposite_profile.user.id} будут перелинкован на профиль #{main_profile.id}"
          # opposite_profile.user.update_column(:profile_id, main_profile.id)
        end


        logger.info "Профиля  #{opposite_profile.id} будет удален"
        # Удаление opposite_profile
        # opposite_profile.destroy
      end
    end

  end
end
