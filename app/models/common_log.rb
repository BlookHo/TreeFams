class CommonLog < ActiveRecord::Base

  include CommonLogs    # основной метод отката назад логов деревьев


  validates_presence_of      :user_id, :log_type, :log_id, :profile_id, :base_profile_id,  :relation_id,
                             :message => "Должно присутствовать в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id, :base_profile_id, :relation_id,
                             :greater_than => 0, :message => "Должны быть больше 0 в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id, :base_profile_id, :relation_id,
                             :only_integer => true, :message => "Должны быть целым числом в CommonLog"
  validates_inclusion_of     :log_type, :in => [1,2,3,4,5,6,7], :message => "Должны быть [1,2,3,4,5,6,7] в CommonLog"
  validates_inclusion_of     :relation_id, :in => [1,2,3,4,5,6,7,8,91,92,101,102,111,112,121,122,13,14,15,16,17,18,191,
                                                   192,201,202,211,212,221,222,444,888,999],
                                                   # 888 - для логов разъединения  деревьев
                                                   # 999 - для логов объединения деревьев
                                                   # 444 - errors with relation_id
                                                   :message => "Должны быть целым числом из заданного множества в CommonLog"

  attr_accessor :agent_name, :tree_user_name # use in self.get_tree_all_logs



  # Collect One type of Common_logs for current_user_id
  def self.get_tree_all_logs(connected_users) #, log_type)
    common_logs_data = CommonLog.where(user_id: connected_users).order("created_at DESC")
    common_logs_data.each do |one_common_log|
      one_common_log.tree_user_name = User.find(one_common_log.user_id).name
      one_common_log.agent_name = Name.find(Profile.find(one_common_log[:profile_id]).name_id).name

    end
    common_logs_data
  end

  # @note Определение нового порядкового номера ADD лога на основе уже существующих логов
  # @param tree_owner [Integer]
  # @param current_log_type [Integer]
  # @return last_log_id [Integer]
  def self.new_log_id(tree_owner, current_log_type)
    logs_numbers = self.where(user_id: tree_owner, log_type: current_log_type).pluck(:log_id).uniq
    # logger.info "In CommonLog model: get_add_log_id: logs_numbers = #{logs_numbers} "
    last_log_id = logs_numbers.max unless logs_numbers.blank? # берем макс-й из существующих номеров
    last_log_id == nil ? last_log_id = 1 : last_log_id += 1 # установление очередного значения порядкового номера лога
    # logger.info "In CommonLog model: get_add_log_id: last_log_id = #{last_log_id} "
    last_log_id
  end


  # @note Создание AR записи одного Общего Лога in model CommonLog
  # Запись строки Общего лога в таблицу CommonLog
  def self.create_common_log(common_log_data)
    create(
      user_id:         common_log_data[:user_id],
      log_type:        common_log_data[:log_type],
      log_id:          common_log_data[:log_id],
      profile_id:      common_log_data[:profile_id],
      base_profile_id: common_log_data[:base_profile_id],
      relation_id:     common_log_data[:new_relation_id]
    )
  end


  # @note Rollback_add == Destroy
  #   Удаление записей содержащих profile_id из таблиц - по выбранным ранее логам (по дате)
  def self.rollback_add_one_profile(rollback_add_log_data )

    current_user = rollback_add_log_data[:current_user]
    # log_type     = rollback_add_log_data[:log_type]
    profile_id   = rollback_add_log_data[:profile_id]
    # log_id       = rollback_add_log_data[:common_log_id]

    @profile = Profile.find(profile_id)
    if @profile.tree_circle(current_user.connected_users, @profile.id).size > 0
      @error = "Вы можете удалить только последнего родственника в цепочке"
    elsif @profile.user.present?
      @error = "Вы не можете удалить профиль у которого есть реальный владелец (юзер)"
    elsif @profile.user_id == current_user.id
      @error = "Вы не можете удалить свой профиль"
    else
      self.delete_profile_data(@profile)
      CommonLog.find(rollback_add_log_data[:common_log_id]).destroy
    end
  end


  # @note Rollback_add == Destroy
  #   Удаление записей содержащих profile_id из таблиц - по выбранным ранее логам (по дате)
  def self.delete_profile_data(profile)
    ProfileKey.where("is_profile_id = ? OR profile_id = ?", profile.id, profile.id).map(&:destroy)
    Tree.where("is_profile_id = ? OR profile_id = ?", profile.id, profile.id).map(&:destroy)

    # todo: удалять ProfileData?
    ProfileData.where(profile_id: profile.id).map(&:destroy)

    # todo: В дальнейшем надо будет чистить от не используемых профилей - но аккуратно
    # @profile.destroy # Не удаляем профили, чтобы иметь возм-ть повторить создание удаленных профилей
    # Mark profile as deleted
    profile.update_attribute('deleted', 1)
    logger.info "In CommonLog model: rollback_add_one_profile: @profile.deleted = #{profile.deleted} "
  end


  # @note Rollback_destroy == Add
  #   Удаление записей содержащих profile_id из таблиц - по выбранным ранее логам (по дате)
  # В основе - массив профилей для удаления
  def self.rollback_destroy_one_profile(destroy_log_data)

    # Previous version
    # Профиль, к которому добавляем (на котором вызвали меню +)
    # @base_profile = Profile.find(base_profile_id)  # FOR add_new_profile
    # Sex того профиля, к кому добавляем (на котором вызвали меню +) к автору отображаемого круга
    # @base_sex_id = @base_profile.sex_id # FOR add_new_profile

    # Mark profile as NOT deleted- back
    profile = Profile.find(destroy_log_data[:profile_id])  # FOR add_new_profile Старый ЛОГИРУЕМЫЙ добавляемый профиль
    profile.update_attribute('deleted', 0)

    # Вернуть "удаленные" ряды в таблицах в 0
    log_to_redo = DeletionLog.restore_deletion_log(destroy_log_data[:log_id], destroy_log_data[:current_user])
    DeletionLog.redo_deletion_log(log_to_redo)
    DeletionLog.deletion_logs_deletion(log_to_redo)

    CommonLog.find(destroy_log_data[:common_log_id]).destroy

    # Previous version
    # @profile.answers_hash = {}  # Исключаем нестандартные вопросы
    #     ProfileKey.add_new_profile(@base_sex_id, @base_profile, @profile, relation_id,
    #                                      exclusions_hash: @profile.answers_hash,
    #                                      tree_ids: current_user.get_connected_users)

  end




end
