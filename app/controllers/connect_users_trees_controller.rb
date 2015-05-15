class ConnectUsersTreesController < ApplicationController
  include SearchHelper
  include ConnectionRequestsHelper

  layout 'application.new'


  # @note: Главный стартовый метод объединения деревьев
  # @param: Вход:
  def connection_of_trees

    # Не заблокировано ли дерево пользователя
    if current_user.tree_is_locked?
      flash[:warning] = "Объединения в данный момент невозможно. Временная блокировка пользователя.
                       Можно повторить попытку позже."
      return redirect_to home_path #:back
    else
      current_user.lock!
    end

    user_id = params[:user_id_to_connect].to_i   # From view
    connection_id = params[:connection_id].to_i # From view Link - where pressed button Yes
    @current_user_id = current_user.id  # DEBUGG_TO_VIEW
    @user_id = user_id # DEBUGG_TO_VIEW

    connection_request =  ConnectionRequest.where(connection_id: connection_id).first
    @from_user = User.find(connection_request.user_id)  # TO_VIEW
    @to_user   = User.find(connection_request.with_user_id) # TO_VIEW

    # flash[:notice] = " Пожалуйста, подождите... Идет подготовка к объединению деревьев. "

    ##### Старт процесса проверки исходных данных и объединения деревьев
    connection_results = current_user.connection(user_id, connection_id)

    # TO_VIEW
    @with_whom_connect_users_arr = connection_results[:with_whom_connect_arr]
    @who_connect_users_arr       = connection_results[:who_connect_arr]
    @elapsed_search_time         = connection_results[:search_time]
    @uniq_profiles_pairs         = connection_results[:uniq_profiles_pairs]
    @duplicates_one_to_many      = connection_results[:duplicates_one_to_many] #
    @duplicates_many_to_one      = connection_results[:duplicates_many_to_one] #
    @profiles_to_rewrite         = connection_results[:profiles_to_rewrite]
    @profiles_to_destroy         = connection_results[:profiles_to_destroy]
    @stop_connection             = connection_results[:stop_connection]
    @connection_message          = connection_results[:connection_message]  #

    logger.info "@stop_connection = #{@stop_connection},\n connection_results = #{connection_results}"

    # flash[:notice] = " #{connection_data[:connection_message]} Ваши деревья успешно объединены!"

    current_user.unlock_tree! # unlock tree

  end



end
