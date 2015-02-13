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

  validate :sim_log_fields_are_not_equal  # :written AND :overwritten
  validates_inclusion_of :field, :in => ["profile_id"], :if => :table_is_users?
  validates_inclusion_of :field, :in => ["profile_id", "is_profile_id"], :if => :table_is_trees_pr_keys?
  validates_inclusion_of :table_name, :in => ["trees", "profile_keys", "users", "profiles"]

 # validates_inclusion_of :field, :in => ["profile_id", "is_profile_id", "user_id", "tree_id"]

  # custom validations
  def sim_log_fields_are_not_equal
    self.errors.add(:similars_logs, 'Значения полей в одном ряду не должны быть равны в SimilarsLog.') if self.written == self.overwritten
  end

  def written_can_be_nil?
    # puts "In SimilarsLog valid:  table_name = #{self.table_name}, written = #{self.written}, field = #{self.field} "
    # puts "In SimilarsLog valid:  table_name? = #{self.table_name == "profiles"} "
    # puts "In SimilarsLog valid:  table_name && field? = #{self.table_name == "profiles" && self.field == "user_id"} "
    self.table_name == "profiles" && self.field == "user_id"
  end

  def table_is_users?
    self.table_name == "users"
  end

  def table_is_trees_pr_keys?
    self.table_name == "trees" || self.table_name == "profile_keys"
  end

  def table_is_profiles?
    self.table_name == "profiles"
  end

end
