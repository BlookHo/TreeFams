class CommonLog < ActiveRecord::Base


  validates_presence_of      :user_id, :log_type, :log_id, :profile_id,
                             :message => "Должно присутствовать в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id,
                             :greater_than => 0, :message => "Должны быть больше 0 в CommonLog"
  validates_numericality_of  :user_id, :log_type, :log_id, :profile_id,
                             :only_integer => true, :message => "Должны быть целым числом в CommonLog"
  validates_inclusion_of     :log_type, :in => [1,2,3,4], :message => "Должны быть [1,2,3,4] в CommonLog"



  # def self.collect_tree_info(current_user)
  #
  #   tree_info = Tree.get_tree_info(current_user)
  #   logger.info "In CommonLog: tree_info[:connected_users] = #{tree_info[:connected_users]}, tree_info = #{tree_info} "
  #
  #   # to show similars connected in view & for RSpec
  #   @tree_info = tree_info
  #   @connected_users = tree_info[:connected_users]
  #   @current_user_id = current_user.id
  #   # @log_connection_id = SimilarsLog.current_tree_log_id(connected_users) unless connected_users.empty?
  #
  #   tree_info
  #
  # end
  #



  def self.collect_common_logs(current_user)

    common_logs_data = CommonLog.where(user_id: current_user)
    logger.info "In CommonLog model: collect_common_logs: common_logs_data = #{common_logs_data} "
    common_logs_data

  end




end
