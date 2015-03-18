class CommonLog < ActiveRecord::Base


  validates_presence_of      :user_id, :log_type, :log_id, :profile_id,
                             :message => "Должно присутствовать в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id,
                             :greater_than => 0, :message => "Должны быть больше 0 в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id,
                             :only_integer => true, :message => "Должны быть целым числом в CommonLog"
  validates_inclusion_of     :log_type, :in => [1,2,3,4], :message => "Должны быть [1,2,3,4] в CommonLog"


  # Collect One type of Common_logs for current_user_id
  def self.get_tree_add_logs(connected_users) #, log_type)
    # logger.info "In CommonLog model: collect_common_logs: connected_users = #{current_user_id} "
    # common_logs_data = CommonLog.where(user_id: current_user_id, log_type: log_type).order("created_at DESC")
    common_logs_data = CommonLog.where(user_id: connected_users).order("created_at DESC")
    # logger.info "In CommonLog model: collect_common_logs: common_logs_data = #{common_logs_data} "
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
  # @param common_log_data [Hash] { user_id: connected_user.id, log_type: current_log_type,
  #                                log_id:  new_log_number, profile_id: new_profile.id }
  # @return [Boolean] выполнение метода = true
  # @see CommonLog
  def self.create_common_log(common_log_data)
      common_log = self.new
        common_log.user_id         = common_log_data[:user_id]
        common_log.log_type        = common_log_data[:log_type]
        common_log.log_id          = common_log_data[:log_id]
        common_log.profile_id      = common_log_data[:profile_id]
        common_log.base_profile_id = common_log_data[:base_profile_id]
        common_log.relation_id     = common_log_data[:new_relation_id]
      if common_log.save
        logger.info "In CommonLog model: create_common_log: good save "
      else
        # todo: дает undefined method for flash?
        flash.now[:alert] = "Ошибка при создании CommonLog"
        # logger.info "In CommonLog model: create_common_log: BAD save "
      end
  end


  # @note Получение списка profile_id - по выбранным ранее логам (по id)
  #   На входе - rollback_id - граница rollback для удаления
  #   Для заданных current_user_id, log_type
  # @param rollback_id [Integer]
  #   rollback_date [Datetime]
  #   current_user_id [Integer]
  #   log_type [Integer]
  # @return profiles_arr [Array]
  # @see CommonLog
  # todo: NO USE?
  def self.profiles_for_rollback(rollback_id, rollback_date, current_user_id, log_type)
    logger.info "In CommonLog model: profiles_for_rollback: rollback_id = #{rollback_id}, rollback_date = #{rollback_date} "
    profiles_arr = CommonLog.where(user_id: current_user_id, log_type: log_type)
                       .where("id >= ?", rollback_id)    # .where("created_at > #{rollback_date}")
                       .order("created_at DESC").pluck(:profile_id)
    profiles_arr
  end

  # @note Rollback_add == Destroy
  #   Удаление записей содержащих profile_id из таблиц - по выбранным ранее логам (по дате)
  # В основе - массив профилей для удаления
  def self.rollback_add_one_profile(current_user, log_type, profile_id)
    logger.info "In CommonLog model: rollback_add_one_profile: profile_id = #{profile_id} "
    # profiles_arr.each do |profile_id|
      @profile = Profile.find(profile_id)
      # logger.info "In CommonLog model: rollback_add: @profile = #{@profile} "
      if @profile.tree_circle(current_user.get_connected_users, @profile.id).size > 0
        @error = "Вы можете удалить только последнего родственника в цепочке"
      elsif @profile.user.present?
        @error = "Вы не можете удалить профиль у которого есть реальный владелец (юзер)"
      elsif @profile.user_id == current_user.id
        @error = "Вы не можете удалить свой профиль"
      else
        ProfileKey.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
        Tree.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)

        # todo: не удалять ProfileData?
        ProfileData.where(profile_id: @profile.id).map(&:destroy)

        CommonLog.where(user_id: current_user.id, log_type: log_type, profile_id: @profile.id).map(&:destroy)

        # todo: В дальнейшем надо будет чистить от не используемых профилей - но аккуратно
        # @profile.destroy # Не удаляем профили, чтобы иметь возм-ть повторить создание удаленных профилей

      end
  end


  # @note Rollback_destroy == Add
  #   Удаление записей содержащих profile_id из таблиц - по выбранным ранее логам (по дате)
  # В основе - массив профилей для удаления
  def self.rollback_destroy_one_profile(current_user, log_type, profile_id, base_profile_id, relation_id)

    # Профиль, к которому добавляем (на котором вызвали меню +)
    @base_profile = Profile.find(base_profile_id)  # FOR add_new_profile

    # Sex того профиля, к кому добавляем (на котором вызвали меню +) к автору отображаемого круга
    @base_sex_id = @base_profile.sex_id # FOR add_new_profile
    # logger.info "In CommonLog model: rollback_destroy_one_profile: @base_sex_id = #{@base_sex_id} "

    @profile = Profile.find(profile_id)  # FOR add_new_profile Старый ЛОГИРУЕМЫЙ добавляемый профиль
    # logger.info "In Profile controller: rollback_destroy_one_profile  @profile.relation_id = #{@profile.relation_id} "

    # todo: учесть при работе с нестандартными вопросами
    @profile.answers_hash = {}  # Исключаем нестандартные вопросы
    ProfileKey.add_new_profile(@base_sex_id, @base_profile, @profile, relation_id,
                                     exclusions_hash: @profile.answers_hash,
                                     tree_ids: current_user.get_connected_users)
    CommonLog.where(user_id: current_user.id, log_type: log_type, profile_id: profile_id).map(&:destroy)
  end




end
