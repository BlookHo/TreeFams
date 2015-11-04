class ConnectionLog < ActiveRecord::Base


  validates_presence_of :connected_at, :current_user_id, :with_user_id, :table_name, :table_row, :field,
                        :message => "Должно присутствовать в ConnectionLog"

  validates_numericality_of :connected_at, :current_user_id, :with_user_id, :table_row, :only_integer => true,
                            :message => "Должны быть целым числом в ConnectionLog"
  validates_numericality_of :connected_at, :current_user_id, :with_user_id, :table_row, :greater_than => 0,
                            :message => "Должны быть больше 0 в ConnectionLog"

  validates_inclusion_of :field, :in => ["profile_id"], :if => :table_users?
  validates_inclusion_of :field, :in => ["profile_id", "is_profile_id"], :if => :table_trees_pr_keys?
  validates_inclusion_of :field, :in => ["tree_id", "user_id", "deleted"], :if => :table_profiles?
  validates_inclusion_of :table_name, :in => ["trees", "profile_keys", "users", "profiles"]
  validates_uniqueness_of :table_row, scope: [:table_name, :field]  # при условии, что эти поля одинаковые
      # - тогда поле table_row д.б.uniq

  # validates_presence_of :written, :overwritten, :unless => :writtens_can_be_nil?
  # validates_numericality_of :written, :overwritten, :only_integer => true, :unless => :writtens_can_be_nil?
  # validate :written_fields_are_not_equal, :unless => :writtens_can_be_equal? # :written AND :overwritten

      # custom validations
  # def written_fields_are_not_equal
  #   self.errors.add(:similars_logs,
  #                   'Значения полей в одном ряду не должны быть равны в ConnectionLog.') if self.written == self.overwritten
  # end

  # def writtens_can_be_equal?
  #   self.table_name == "profiles" && self.field == "tree_id"
  # end

  # def writtens_can_be_nil?
  #   # puts "In ConnectionLog Model valid:  table_name = #{self.table_name}, written = #{self.written}, field = #{self.field} "
  #   # puts "In ConnectionLog Model valid:  table_name? = #{self.table_name == "profiles"} "
  #   # puts "In ConnectionLog Model valid:  table_name && field? = #{self.table_name == "profiles" && self.field == "user_id"} "
  #   self.table_name == "profiles" && self.field == "user_id"
  # end

  def table_users?
    self.table_name == "users"
  end

  def table_trees_pr_keys?
    self.table_name == "trees" || self.table_name == "profile_keys"
  end

  def table_profiles?
    self.table_name == "profiles"
  end

  # def field_tree?
  #   self.field == "tree_id"
  # end


  # for RSpec - in User_spec.rb
  scope :at_current_user_connected_fields, -> (current_user_id, connection_id) { where(current_user_id: current_user_id,
                                                                                connected_at: connection_id).
                                                            where(" field = 'profile_id' or field = 'is_profile_id' ")}
  scope :at_current_user_deleted_field, -> (current_user_id, connection_id) { where(current_user_id: current_user_id,
                                                                                       connected_at: connection_id).
                                                            where(" field = 'deleted' ")}


  # Для текущего дерева - получение номера id лога для прогона разъединения trees,
  # ранее объединенных.
  # Если такой лог есть, значит ранее trees они объединялись. Значит теперь их
  # можно разъединять.
  # Последний id (максимальный) из существующих логов - :connected_at
  def self.current_tree_log_id(connected_users)
    # puts "In Model action current_tree_log_id : connected_users = #{connected_users} \n"
    log_connection_id = []
    # Сбор всех id логов, относящихся к текущему дереву
    current_tree_logs_ids = self.where(current_user_id: connected_users).pluck(:connected_at).uniq
    # logger.info "In  1b: @current_tree_logs_ids = #{current_tree_logs_ids} " unless current_tree_logs_ids.blank?
    log_connection_id = current_tree_logs_ids.max unless current_tree_logs_ids.blank?
    # logger.info "In  1b: log_connection_id = #{log_connection_id} " unless log_connection_id.blank?
    log_connection_id
  end


  # From -Module # similars_connect_tree
  # Сохранение массива логов в таблицу ConnectionLog
  def self.store_log(connection_log)
    logger.info "MMMMM *** In model ConnectionLog store_log "
    connection_log.each(&:save)
  end




end
