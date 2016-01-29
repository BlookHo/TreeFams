class ConnectionLog < ActiveRecord::Base

  #############################################################
  # Иванищев А.В. 2014 -2015
  #############################################################
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

  def table_users?
    self.table_name == "users"
  end

  def table_trees_pr_keys?
    self.table_name == "trees" || self.table_name == "profile_keys"
  end

  def table_profiles?
    self.table_name == "profiles"
  end


  # for RSpec - in User_spec.rb
  scope :at_current_user_connected_fields, -> (current_user_id, connection_id) { where(current_user_id: current_user_id,
                                                                                connected_at: connection_id).
                                                            where(" field = 'profile_id' or field = 'is_profile_id' ")}
  scope :at_current_user_deleted_field, -> (current_user_id, connection_id) { where(current_user_id: current_user_id,
                                                                                       connected_at: connection_id).
                                                            where(" field = 'deleted' ")}

  # @note:  Для текущего дерева - получение номера id лога для прогона разъединения trees, ранее объединенных.
  #   Если такой лог есть, значит ранее trees они объединялись. Значит теперь их можно разъединять.
  #   Последний id (максимальный) из существующих логов - :connected_at
  def self.current_tree_log_id(connected_users)
    log_connection_id = []
    # Сбор всех id логов, относящихся к текущему дереву
    current_tree_logs_ids = self.where(current_user_id: connected_users).pluck(:connected_at).uniq
    log_connection_id = current_tree_logs_ids.max unless current_tree_logs_ids.blank?
    log_connection_id
  end


  # @note: From -Module # similars_connect_tree
  #   Сохранение массива логов в таблицу ConnectionLog
  def self.store_log(connection_log)
    connection_log.each(&:save)
  end


end

