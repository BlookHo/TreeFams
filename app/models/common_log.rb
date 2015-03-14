class CommonLog < ActiveRecord::Base


  validates_presence_of      :user_id, :log_type, :log_id, :profile_id,
                             :message => "Должно присутствовать в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id,
                             :greater_than => 0, :message => "Должны быть больше 0 в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id,
                             :only_integer => true, :message => "Должны быть целым числом в CommonLog"
  validates_inclusion_of     :log_type, :in => [1,2,3,4], :message => "Должны быть [1,2,3,4] в CommonLog"


  # Collect One type of Common_logs for current_user_id
  def self.get_tree_add_logs(current_user_id, log_type)
    logger.info "In CommonLog model: collect_common_logs: connected_users = #{current_user_id} "
    common_logs_data = CommonLog.where(user_id: current_user_id, log_type: log_type)
    logger.info "In CommonLog model: collect_common_logs: common_logs_data = #{common_logs_data} "
    common_logs_data
  end

  # Определение нового порядкового номера ADD лога на основе уже существующих логов
  def self.new_add_log_id(tree_owner, current_log_type)
    logs_numbers = self.where(user_id: tree_owner, log_type: current_log_type).pluck(:log_id).uniq
    # logger.info "In CommonLog model: get_add_log_id: logs_numbers = #{logs_numbers} "
    last_log_id = logs_numbers.max unless logs_numbers.blank? # берем макс-й из существующих номеров
    last_log_id == nil ? last_log_id = 1 : last_log_id += 1 # установление очередного значения порядкового номера лога
    # logger.info "In CommonLog model: get_add_log_id: last_log_id = #{last_log_id} "
    last_log_id
  end

  # Создание записи одного Общего Лога
  # common_log_data =  { user_id: connected_user.id, log_type: current_log_type,
  #                      log_id:  new_log_number, profile_id: new_profile.id }
  def self.create_common_log(common_log_data)
      common_log = self.new
        common_log.user_id    = common_log_data[:user_id]
        common_log.log_type   = common_log_data[:log_type]
        common_log.log_id     = common_log_data[:log_id]
        common_log.profile_id = common_log_data[:profile_id]
      # logger.info "In CommonLog model: create_common_log: common_log = #{common_log} "
      if common_log.save
        logger.info "In CommonLog model: create_common_log: good save "
      else
        flash.now[:alert] = "Ошибка при создании CommonLog"
        # logger.info "In CommonLog model: create_common_log: BAD save "
      end
  end

  # Определение нового порядкового номера лога на основе уже существующих логов
  # def self.get_common_log_id(connected_users, current_log_type)
  #   logs_numbers = self.where(user_id: connected_users, log_type: current_log_type).pluck(:log_id).uniq
  #   logger.info "In CommonLog model: get_log_id: logs_numbers = #{logs_numbers} "
  #   last_log_id = logs_numbers.max unless logs_numbers.blank? # берем макс-й из существующих номеров
  #   last_log_id == nil ? last_log_id = 1 : last_log_id += 1 # установление очередного значения порядкового номера лога
  #   logger.info "In CommonLog model: get_log_id: last_log_id = #{last_log_id} "
  #   # last_log_id
  # end

  # Collect All types of Common_logs for connected_users
  # def self.collect_common_logs(connected_users)
  #   logger.info "In CommonLog model: collect_common_logs: connected_users = #{connected_users} "
  #   common_logs_data = CommonLog.where(user_id: connected_users)
  #   logger.info "In CommonLog model: collect_common_logs: common_logs_data = #{common_logs_data} "
  #   common_logs_data
  # end



end
