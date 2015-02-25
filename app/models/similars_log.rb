class SimilarsLog < ActiveRecord::Base


  validates_presence_of :connected_at, :current_user_id, :table_name, :table_row, :field,
                        :message => "Должно присутствовать в SimilarsLog"

  validates_presence_of :written, :overwritten, :unless => :writtens_can_be_nil?
  validates_numericality_of :written, :overwritten,:greater_than => 0, :unless => :writtens_can_be_nil?
  validates_numericality_of :written, :overwritten, :only_integer => true, :unless => :writtens_can_be_nil?
  validate :written_fields_are_not_equal, :unless => :writtens_can_be_equal? # :written AND :overwritten

  validates_numericality_of :connected_at, :current_user_id, :table_row, :only_integer => true,
                            :message => "Должны быть целым числом в SimilarsLog"
  validates_numericality_of :connected_at, :current_user_id, :table_row, :greater_than => 0,
                            :message => "Должны быть больше 0 в SimilarsLog"

  validates_inclusion_of :field, :in => ["profile_id"], :if => :table_users?
  validates_inclusion_of :field, :in => ["profile_id", "is_profile_id"], :if => :table_trees_pr_keys?
  validates_inclusion_of :field, :in => ["tree_id", "user_id"], :if => :table_profiles?
  validates_inclusion_of :table_name, :in => ["trees", "profile_keys", "users", "profiles"]
  validates_uniqueness_of :table_row, scope: [:table_name, :field]  # при условии, что эти поля одинаковые
                                                                    # - тогда поле table_row д.б.uniq

 # 4 ##*** In module SimilarsConnection log_profiles_connection:
 # current_user_id: 7, table_name: "users", table_row: 8, field: "profile_id", written: 84, overwritten: 66, created_at: nil, updated_at: nil>,
# current_user_id: 7, table_name: "profiles", table_row: 84, field: "user_id", written: 8, overwritten: nil, created_at: nil, updated_at: nil>,
 #, current_user_id: 7, table_name: "profiles", table_row: 84, field: "tree_id", written: 7, overwritten: 7, created_at: nil, updated_at: nil>,
 #  current_user_id: 7, table_name: "profiles", table_row: 66, field: "user_id", written: nil, overwritten: 8, created_at: nil, updated_at: nil>] (pid:9507)

  # custom validations
  def written_fields_are_not_equal
    self.errors.add(:similars_logs,
                    'Значения полей в одном ряду не должны быть равны в SimilarsLog.') if self.written == self.overwritten
  end

  def writtens_can_be_equal?
     self.table_name == "profiles" && self.field == "tree_id"
  end

  def writtens_can_be_nil?
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

  def field_tree?
    self.field == "tree_id"
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
