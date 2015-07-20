module CommonLogs
  extend ActiveSupport::Concern
  # in CommonLog model

  module ClassMethods

    # @note: основной метод запуска возврата дерева в состояние на выбранную дату
    def rollback(rollback_id, current_user)
      logger.info "START In rollback module: current_user.id = #{current_user.id}  "

      connected_users_arr = current_user.get_connected_users

      common_logs_arr = CommonLog.where(user_id: connected_users_arr) # current_user.id)
                            .where("id >= ?", rollback_id)    # .where("created_at > #{rollback_date}")
                            .order("created_at DESC")
      logger.info "In rollback module: common_logs_arr.size = #{common_logs_arr.size}  " unless common_logs_arr.blank?

      common_logs_arr.each do |common_log|

        case common_log.log_type
          when 1 #  Добавление профиля
            rollback_add_profile(common_log.id, current_user)
          when 2 #  Удаление профиля
            rollback_delete_profile(common_log.id, current_user)
          when 3 #  Объединение похожих профилей в одном дереве
            rollback_similars_profiles(common_log.id, current_user)
          when 4 #  Объединение деревьев
            rollback_connection_trees(common_log.id, current_user)
          else
            @error = "Тип лога - не определен! common_log.log_type = #{common_log.log_type} "
        end
      end

      # here to check requests to keepif exists in search results
      # todo: uncomment this line to work check
      # todo: !!!!!!  UPDATE RSPEC - User, Conn.req.  !!!!!!! ->
      # кол-во рядом - меньше. на те, кот-х нет в рез-х поиска.
      # т.е. задать рез-ты поиска в spec
      # check_requests(connected_users_arr) ##########
      logger.info "END rollback module "

    end


    # @note
    #
    def check_requests(connected_users_arr)
      # logger.info "In CommonLog controller: check_requests: connected_users_arr = #{connected_users_arr} "
      ConnectionRequest.check_requests_with_search(current_user, connected_users_arr)
    end


    # @note Возврат Add Logs
    #   Возврат дерева - откат на выбранную дату
    # @param params[:rollback_date]
    # @param params[:rollback_id]
    def rollback_add_profile(common_log_id, current_user)
      profile_id = CommonLog.find(common_log_id).profile_id
      rollback_add_log_data = { current_user:  current_user,
                                log_type:  1,
                                profile_id:  profile_id,
                                common_log_id:  common_log_id }

      CommonLog.rollback_add_one_profile(rollback_add_log_data)
    end


    # @note Возврат delete Logs
    # @note Возврат дерева - откат на выбранную дату
    # @param params[:rollback_date]
    # @param params[:rollback_id]
    def rollback_delete_profile(common_log_id, current_user)
      one_common_log = CommonLog.find(common_log_id)
      destroy_log_data = {current_user:     current_user,
                          log_type:         2,
                          profile_id:       one_common_log.profile_id,
                          base_profile_id:  one_common_log.base_profile_id,
                          relation_id:      one_common_log.relation_id,
                          log_id:           one_common_log.log_id ,
                          common_log_id:    common_log_id
      } # common_log_id
      puts "In CommonLog model: rollback_delete_profile: log_id = #{one_common_log.log_id}, current_user.id = #{current_user.id}"

      CommonLog.rollback_destroy_one_profile(destroy_log_data)
    end


    # todo: Connect with Similars methods & refactor
    # @note Similars Connect log - Rollback
    # @note Возврат дерева - откат на выбранную дату
    # @param params[:rollback_date]
    # @param params[:rollback_id]
    def rollback_similars_profiles(common_log_id, current_user)

      logger.info "In CommonLog controller: rollback_similars_profiles для common_log_id = #{common_log_id} "
      # logger.info "In CommonLog controller: rollback_connection_trees для common_log_id = #{common_log_id.inspect} "
      # Не заблокировано ли дерево пользователя
      # if current_user.tree_is_locked?
      #   flash[:warning] = "Объединения в данный момент невозможно. Временная блокировка пользователя.
      #                  Можно повторить попытку позже."
      #   return redirect_to home_path #:back
      # else
      #   current_user.lock!
      # end

      ############ call of User.module Similars_disconnection #####################
      current_user.disconnect_sims(common_log_id)

      # current_user.unlock_tree!
    end


    # @note Disconnect
    #    Возврат дерева - откат на выбранную дату
    # @param params[:rollback_date]
    # @param params[:rollback_id]
    def rollback_connection_trees(common_log_id, current_user)

      # logger.info "In CommonLog controller: rollback_connection_trees для common_log_id = #{common_log_id.inspect} "
      # Не заблокировано ли дерево пользователя
      # if current_user.tree_is_locked?
      #   flash[:warning] = "Объединения в данный момент невозможно. Временная блокировка пользователя.
      #                  Можно повторить попытку позже."
      #   return redirect_to home_path #:back
      # else
      #   current_user.lock!
      # end

      ############ call of User.module Disconnection_tree #####################
      current_user.disconnect_tree(common_log_id)

      # current_user.unlock_tree!
    end


  end
end