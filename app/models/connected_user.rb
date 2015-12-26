class ConnectedUser < ActiveRecord::Base

  validates_presence_of :user_id, :with_user_id, :connection_id, :rewrite_profile_id, :overwrite_profile_id,
                        :message => "Должно присутствовать в ConnectedUser"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :rewrite_profile_id, :overwrite_profile_id,
                            :only_integer => true,
                        :message => "ID автора сообщения или получателя сообщения должны быть целым числом в ConnectedUser"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :rewrite_profile_id, :overwrite_profile_id,
                            :greater_than => 0,
                        :message => "ID автора сообщения или получателя сообщения должны быть больше 0 в ConnectedUser"
  validate :connect_users_ids_not_equal  # :user_id  AND :with_user_id
  validate :profiles_fields_are_not_equal # :rewrite_profile_id AND :overwrite_profile_id

  # custom validation
  def connect_users_ids_not_equal
    self.errors.add(:connected_users, 'Юзеры IDs в одном ряду не должны быть равны в ConnectedUser.') if self.user_id == self.with_user_id
  end

  # custom validations
  def profiles_fields_are_not_equal
    self.errors.add(:connected_users,
                    'Значения полей в одном ряду не должны быть равны в ConnectedUser.') if self.rewrite_profile_id == self.overwrite_profile_id
  end

  belongs_to :user

  # @note: used in User.get_connected_users
  #  EX.: first_users_arr = ConnectedUser.connected_users_ids(self).uniq
  scope :connected_users_ids, -> (connected_user) {where(user_id: connected_user.id).pluck(:with_user_id)}
  scope :connected_with_users_ids, -> (connected_user) {where(with_user_id: connected_user.id).pluck(:user_id)}


  # @note: Заполнение таблицы Connected_Trees - записью о том, что деревья
  #   с current_user_id и user_id - соединились
  #   Call from connect_users_trees_controller
  #   здесь сохраняются массивы профилей
  # @param  connection_data = {
  #     who_connect:          who_connect_users_arr, #
  #     with_whom_connect:    with_whom_connect_users_arr, #
  #     profiles_to_rewrite:  profiles_to_rewrite, #
  #     profiles_to_destroy:  profiles_to_destroy, #
  #     current_user_id:      current_user_id, #
  #     user_id:              user_id ,#
  #     connection_id:        @connection_id } #
  def self.set_users_connection(connection_data) #, current_user_id, user_id, connection_id)
    current_user_id     = connection_data[:current_user_id]
    user_id             = connection_data[:user_id]

    if current_user_id != user_id

      profiles_to_rewrite = connection_data[:profiles_to_rewrite]
      profiles_to_destroy = connection_data[:profiles_to_destroy]
      connection_id       = connection_data[:connection_id]

      # logger.info "== In connect_users:  connection_data = #{connection_data}, connection_id = #{connection_id}"
      # logger.info "== In connect_users:  profiles_to_rewrite = #{profiles_to_rewrite} "
      # logger.info "== In connect_users:  profiles_to_destroy = #{profiles_to_destroy} "
      # logger.info "== In connect_users:  current_user_id = #{current_user_id}, user_id = #{user_id} "

      profiles_to_rewrite.each_with_index  do |rewrite_profile, index|
        # logger.info "== In connect_users: create_one_connection_row; index = #{index}, profiles_to_destroy[i] = #{profiles_to_destroy[index]} "
        # logger.info "== In connect_users:  index = #{index}, rewrite_profile = #{rewrite_profile} "
        # logger.info "== In connect_users:  index = #{index}, profiles_to_destroy[i] = #{profiles_to_destroy[index]} "
        new_users_connection = ConnectedUser.new
        new_users_connection.user_id = current_user_id
        new_users_connection.with_user_id = user_id
        new_users_connection.connection_id = connection_id
        new_users_connection.rewrite_profile_id = rewrite_profile
        new_users_connection.overwrite_profile_id = profiles_to_destroy[index]
        #############################
 new_users_connection.save
        #############################
      end

    else
      logger.info "ERROR: Connection of Users - INVALID! Current_user=#{current_user_id.inspect}
                   EQUALS TO user_id=#{user_id.inspect}"
    end

  end


  # @note:
  # conn_users_destroy_data = {
  #      user_id: common_log_row_fields["user_id"], #    1,
  #      with_user_id: User.where(profile_id: common_log_row_fields["base_profile_id"]),    #        3,
  #      connection_id: common_log_row_fields["log_id"]   #    3,
  #  }
  def self.destroy_connection(conn_users_destroy_data)

     # self.where(user_id: conn_users_destroy_data[:user_id],
     #           with_user_id: conn_users_destroy_data[:with_user_id],
     #           connection_id: conn_users_destroy_data[:connection_id]).map(&:destroy)
     self.where(connection_id: conn_users_destroy_data[:connection_id]).map(&:destroy)


  end



  # after_update  :update_connected_users
  after_create  :update_connected_users
  # after_destroy :update_connected_users
  def update_connected_users
    user = User.find(self.user_id)
    user.update_connected_users!
  end


end
