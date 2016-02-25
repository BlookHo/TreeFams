class SimilarsController < ApplicationController
  include SearchHelper
  include SimilarsHelper

  layout 'application.new'
  # puts "In SimilarsController - START \n"

  before_filter :logged_in?
  # puts "In SimilarsController - AFTER LOGGED  \n"

  # todo: перенести этот метод в Operational - для нескольких моделей
  # пересечение 2-х хэшей, у которых - значения = массивы
  def intersection(first, other)
    common_hash = {}
    uncommon_hash = {}
    first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
      unless other.include?(k)
        uncommon_hash.merge!({k => other})
      end
      intersect = other[k] & v    # пересечение = общая часть массивов
      difference = (other[k] - v) + (v - other[k])  # разность = различие 2-х массивов
      common_hash.merge!({k => intersect}) unless intersect.blank?
      uncommon_hash.merge!({k => difference}) unless difference.blank?
    end
    return common_hash, uncommon_hash
  end


  # Запуск методов определения похожих профилей в текущем дереве
  def internal_similars_search
    # puts "In action internal_similars_search - START \n"
    # connected_users = current_user.get_connected_users

    #################
    similars_data = current_user.start_similars # search similars

    # to show similars connected in view & for RSpec
    @tree_info = similars_data[:tree_info]
    @new_sims = similars_data[:new_sims]
    @similars = similars_data[:similars]
    @connected_users = similars_data[:connected_users]
    @log_connection_id = similars_data[:log_connection_id]
    @current_user_id = current_user.id
    # @log_connection_id =  SimilarsLog.current_tree_log_id(@connected_users) unless @connected_users.empty?

    if @similars.empty?   # т.е. нет похожих
      flash.now[:notice] = "Успешное сообщение: В дереве все Ок - 'похожих' профилей нет."
    else  # т.е. есть похожие
      unless @new_sims=="" #.empty?  # т.е. есть инфа о похожих
        flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
        # flash.now[:alert]
        view_tree_similars(@tree_info, @similars) unless @tree_info.empty?  # to internal_similars_search.html.haml
      end
    end
  end

  # to show after home_controller#index
  def show_similars_data
  end


  # Готовит данные для Объединения похожих профилей - similars_connection_data
  # ПЕредает их в модель для непосредственного объединения
  # Лог - это массив записей о параметрах всех совершенных объединениях дерева
  def connect_similars

    first_profile_connecting  = params[:first_profile_id].to_i
    second_profile_connecting = params[:second_profile_id].to_i

    sim_connection_result = current_user.similars_connection(first_profile_connecting,
                                                             second_profile_connecting)
    # for RSpec & TO_VIEW
    @init_hash           = sim_connection_result[:init_hash]
    @profiles_to_rewrite = sim_connection_result[:profiles_to_rewrite]
    @profiles_to_destroy = sim_connection_result[:profiles_to_destroy]
    log_connection       = sim_connection_result[:last_log_id]

    show_log_data(log_connection)
    flash[:notice] = "Похожие профили в дереве успешно объединены"

    logger.info "In SimilarsConnectionController: After similars_connection - @current_user.id = #{@current_user.id} "
    search_event = 3
    SearchResults.start_search_methods(current_user, search_event)

  end


  # Возвращает объединенные профили в состояние перед объединением
  # во всех таблицах
  def disconnect_similars
    log_id = params[:log_connection_id]
    # for RSpec & TO_VIEW
    @log_id = log_id.to_i

    ############ call of User.module Similars_disconnection #####################
    current_user.disconnect_sims_in_tables(log_id.to_i)
    # tree_info, new_sims, similars =
    current_user.start_similars # to restore similars found
  end


  # Контроль (тест) объединения профилей после объединения - по таблицах ProfileKey
  # todo: have to be done - use after connection, before store in tables
  #
  def check_connected_similars
    log_id = params[:log_connection_id]
    # logger.info "*** In check_connected_similars:  log_id = #{log_id}"
    @log_id = log_id.to_i
    profiles_to_rewrite  = params[:profiles_to_rewrite]#.to_i
    profiles_to_destroy = params[:profiles_to_destroy]#.to_i
    logger.info "*** In check_connected_similars:  profiles_to_rewrite = #{profiles_to_rewrite}"
    logger.info "*** In check_connected_similars:  profiles_to_destroy = #{profiles_to_destroy}"
  end


end

# TEST 1
# arr1 = [2, 1, 3, 5]
# arr2 = [2, 0, 4]
# inter = arr1 & arr2
# differ = arr1 || arr2
# differ1 = arr1 - arr2
# differ2 = arr2 - arr1
# resdif = differ1 + differ2
# resdif2 = (arr1 - arr2) + (arr2 - arr1)
#logger.info "&&& In int_sim_search 01: arr1 = #{arr1}, arr2 = #{arr2}, inter = #{inter}, differ = #{differ}"
#logger.info "&&& In int_sim_search 01: differ1 = #{differ1}, differ2 = #{differ2}, resdif = #{resdif}, resdif2 = #{resdif2}"

# TEST 2
# hash1 = {"son"=>[122, 121], "hus"=>[90], "dil"=>[82], "gsf"=>[28]    ,"fat"=>[110]           }
# hash2 = {"son"=>[122, 120], "hus"=>[90], "dil"=>[82], "gsf"=>[28]   ,"hfl"=>[28], "hml"=>[48]}  # from balda
# common_hash, uncommon_hash = intersection(hash1, hash2)
# logger.info "&&& In int_sim_search 021: common_hash = #{common_hash}"
# logger.info "&&& In int_sim_search 022: uncommon_hash = #{uncommon_hash} "

