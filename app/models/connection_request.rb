class ConnectionRequest < ActiveRecord::Base

  #belongs_to :user
  #attr_accessor :user_id, :with_user_id, :connection_id, :confirm, :done, :created_at
  validates_presence_of :user_id, :with_user_id, :connection_id,
                        :message => "Должно присутствовать в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :only_integer => true,
                            :message => "ID объединяемых Юзеров: должны быть целым числом в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :greater_than => 0,
                            :message => "ID объединяемых Юзеров: должны быть больше 0 в ConnectionRequest"
  validate :request_users_ids_not_equal  # :user_id  AND :with_user_id
  # custom validation
  def request_users_ids_not_equal
    self.errors.add(:connection_requests, 'Юзеры IDs в одном ряду не должны быть равны в ConnectionRequest.') if self.user_id == self.with_user_id
  end

  validates_inclusion_of :confirm, :in => [nil, 0, 1, 2],
                         :message => "Значение поля подтверждения объединения: должно быть [nil, 0, 1, 2] в ConnectionRequest"
  # nil - default
  # 0 - No to connect
  # 1 - Yes to connect
  # 2 - Request deleted by System (trees already connected)

  validates_inclusion_of :done, :in => [true, false],
                         :message => "done должно быть [true, false] в ConnectionRequest"



  # @note: update request data - to 'yes' to connect
  #   Ответ ДА на запрос на объединение
  #   Действия: сохраняем инфу - кто дал добро (= 1) какому объединению
  #   Перед этим - запуск собственно процесса объединения
  def self.request_connection(connection_data)
    # who_connect_arr         = connection_data[:who_connect_arr]
    # with_whom_connect_arr   = connection_data[:with_whom_connect_arr]
    # profiles_to_rewrite     = connection_data[:profiles_to_rewrite]
    # profiles_to_destroy     = connection_data[:profiles_to_destroy]
    current_user_id         = connection_data[:current_user_id]
    user_id                 = connection_data[:user_id]
    connection_id           = connection_data[:connection_id]

    requests_to_update = self.where(connection_id: connection_id,
                                    user_id: user_id,
                                    done: false )
    unless requests_to_update.blank?
      requests_to_update.each do |request_row|
        request_row.done    = true
        request_row.confirm = 1 if request_row.with_user_id == current_user_id  # тот, кто сказал "Да"
        request_row.save
      end
    end
      # logger.info "In update_requests: Done"
    # else
    #   logger.info "WARNING: NO update_requests WAS DONE!"
    #   redirect_to show_user_requests_path # To: Просмотр Ваших оставшихся запросов'
    #   # flash - no connection requests data in table
    # end
  end


  # @note: Find Array of connection_ids of all requests - included in just connected [1,2,3]
  #   Найти все запросы, в которых участвуют члены нового объединенного дерева
  #   Make DONE all connected requests
  #   - update all requests - with users, connected with current_user  # 1.Get connected users - arr
  #   where(user-id - in Arr and with_user in Arr)
  #   set to DONE all.
  # @param: current_user_id=>1
  def self.connected_requests_update(current_user_id)
    new_tree_users = User.find(current_user_id).get_connected_users
    self.where("user_id in (?)", new_tree_users).where("with_user_id in (?)", new_tree_users)
        .where(done: false).update_all({done: true, confirm: 2})
    # puts "In  connected_requests_update: new_tree_users = #{new_tree_users}"
  end

  # @note: rollback ConnectionRequest - update request data - to 'yes' to connect
  #   Ответ ДА на запрос на объединение
  def self.request_disconnection(disconnect_data)
    # puts "In  request_disconnection: disconnect_data = #{disconnect_data}"
    # requests_to_rollback =
    self.where(connection_id: disconnect_data[:connection_id],   # 3
               user_id: disconnect_data[:with_user_id],          # 3
               done: true )
        .update_all({done: false, confirm: nil})
  end


  # @note rollback ConnectionRequest - update request data - to 'yes' to connect
  # conn_users_destroy_data = {
  #     user_id: connection_common_log["user_id"], #    1,
  #     with_user_id: Profile.find(connection_common_log["base_profile_id"]).user_id,    #        3,
  #     connection_id: connection_common_log["log_id"]   #    3,
  # }
  def self.disconnected_requests_update(disconnect_data)
    connected_tree = User.find(disconnect_data[:user_id]).get_connected_users
    # puts "In  disconnected_requests_update: connected_tree = #{connected_tree}"
    self.where("user_id in (?)", connected_tree).where("with_user_id in (?)", connected_tree)
        .where(done: true, confirm: 2)
        .update_all({done: false, confirm: nil})

  end




end
