class SimilarsLog < ActiveRecord::Base


  validates_presence_of :connected_at, :current_user_id, :table_name, :table_row, :field, :overwritten,
                        :message => "Должно присутствовать в SimilarsLog"
  validates_presence_of :written, :unless => :written_can_be_nil?
  validates_numericality_of :written, :greater_than => 0, :unless => :written_can_be_nil?
  validates_numericality_of :written,  :only_integer => true, :unless => :written_can_be_nil?
  validates_numericality_of :connected_at, :current_user_id, :table_row, :overwritten, :only_integer => true,
                            :message => "Должны быть целым числом в SimilarsLog"
  validates_numericality_of :connected_at, :current_user_id, :table_row, :overwritten, :greater_than => 0,
                            :message => "Должны быть больше 0 в SimilarsLog"
  validate :one_log_fields_are_not_equal  # :written AND :overwritten
  validates_inclusion_of :field, :in => ["profile_id"], :if => :table_users?
  validates_inclusion_of :field, :in => ["profile_id", "is_profile_id"], :if => :table_trees_pr_keys?
  validates_inclusion_of :field, :in => ["tree_id", "user_id"], :if => :table_profiles?
  validates_inclusion_of :table_name, :in => ["trees", "profile_keys", "users", "profiles"]
  validates_uniqueness_of :table_row, scope: [:table_name, :field]

  # custom validations
  def one_log_fields_are_not_equal
    self.errors.add(:similars_logs,
                    'Значения полей в одном ряду не должны быть равны в SimilarsLog.') if self.written == self.overwritten
  end

  def written_can_be_nil?
    # puts "In SimilarsLog valid:  table_name = #{self.table_name}, written = #{self.written}, field = #{self.field} "
    # puts "In SimilarsLog valid:  table_name? = #{self.table_name == "profiles"} "
    # puts "In SimilarsLog valid:  table_name && field? = #{self.table_name == "profiles" && self.field == "user_id"} "
    self.table_name == "profiles" && self.field == "user_id"
  end

  def table_users?
    self.table_name == "users"
  end

  def table_trees_pr_keys?
    self.table_name == "trees" || self.table_name == "profile_keys"
  end

  def table_profiles?
    self.table_name == "profiles"
  end


  # Для текущего дерева - получение номера id лога для прогона разъединения Похожих,
  # ранее объединенных.
  # Если такой лог есть, значит ранее были найдены похожие и они объединялись. Значит теперь их
  # можно разъединять.
  # Последний id (максимальный) из существующих логов - :connected_at
  def self.current_tree_log_id(connected_users)
    log_connection_id = []
    # Сбор всех id логов, относящихся к текущему дереву
    current_tree_logs_ids = self.where(current_user_id: connected_users).pluck(:connected_at).uniq
    logger.info "In internal_similars_search 1b: @current_tree_logs_ids = #{current_tree_logs_ids} " if !current_tree_logs_ids.blank?
    log_connection_id = current_tree_logs_ids.max unless current_tree_logs_ids.blank?
    logger.info "In internal_similars_search 1b: log_connection_id = #{log_connection_id} " if !log_connection_id.blank?
    log_connection_id
  end


  # From SimilarsConnection-Module # similars_connect_tree
  # Сохранение массива логов в таблицу SimilarsLog
  def self.store_log(common_log)
    logger.info "MMMMM *** In model SimilarsLog store_log "
    common_log.each(&:save)
  end





end
