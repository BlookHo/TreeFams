class SimilarsController < ApplicationController
  include SearchHelper

  layout 'application.new'

  before_filter :logged_in?

  # todo: перенести этот метод в Operational - для нескольких моделей
  #
  # пересечение 2-х хэшей, у которых - значения = массивы
  def intersection(first, other)
    common_hash = {}
    uncommon_hash = {}
    # logger.info "intersection 01: first = #{first}"
    # logger.info "intersection 01: other = #{other}"
    first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
      if !other.include?(k)
        uncommon_hash.merge!({k => other})
      end
      intersect = other[k] & v    # пересечение = общая часть массивов
      difference = (other[k] - v) + (v - other[k])  # разность = различие 2-х массивов
      # logger.info "intersection 02: other[k] = #{other[k]}, v = #{v}, intersect = #{intersect}, difference = #{difference} "
      common_hash.merge!({k => intersect}) if !intersect.blank?
      uncommon_hash.merge!({k => difference}) if !difference.blank?
      # logger.info "intersection 05: common_hash = #{common_hash}, uncommon_hash = #{uncommon_hash} "
    end
    return common_hash, uncommon_hash
  end


  # Запуск методов определения похожих профилей в текущем дереве
  # sim_data = { log_connection_id: log_connection_id, #
  #              similars: similars,       #
  #              unsimilars: unsimilars  }
  def internal_similars_search

    ############################# DEBUG ################################################
    # SimilarsFound.delete_all
    # SimilarsFound.reset_pk_sequence

    tree_info = current_user.get_tree_info(current_user)
    logger.info "In SimilarsStart 1:  @tree_info[:connected_users] = #{tree_info[:connected_users]}"

    ### Удаление ВСЕХ ранее сохраненных пар похожих ДЛЯ ОДНОГО ДЕРЕВА
    connected_users = current_user.get_connected_users
    logger.info "In SimilarsStart 1:  connected_users = #{connected_users}"
    SimilarsFound.clear_tree_similars(connected_users)

    tree_info, sim_data, similars = current_user.start_similars
        # tree_info = {:current_user=> <User id: 5, profile_id: 34, admin: false, rating: 0.0, created_at: "2015-01-24 09:46:18", updated_at: "2015-02-03 09:55:19", email: "petr_andr@pe.pe", encrypted_password: "", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, password_digest: "$2a$10$mKB.q2fRANiQ6snAOrd9KeQ/ucoD5FXdHiAv.k9asJi...", is_locked: false, access_token: "6eefef787693ceb6ad916c1245865726">,
        # :users_profiles_ids=>[34, 31],
        # :tree_is_profiles=>[33, 38, 34, 42, 44, 36, 31, 41, 32, 43, 40, 52, 37, 39, 35],
        # :tree_profiles_amount=>15,
        # :all_tree_profiles=>[33, 38, 34, 42, 44, 36, 31, 41, 32, 43, 40, 52, 37, 39, 35],
        # :all_tree_profiles_amount=>15,
        # :connected_users=>[5, 4],
        # :profiles=>{33=>{:is_name_id=>345, :is_sex_id=>0, :profile_id=>31, :relation_id=>2}, 38=>{:is_name_id=>354, :is_sex_id=>0, :profile_id=>34, :relation_id=>8}, 34=>{:is_name_id=>370, :is_sex_id=>1, :profile_id=>31, :relation_id=>5}, 42=>{:is_name_id=>354, :is_sex_id=>0, :profile_id=>35, :relation_id=>6}, 44=>{:is_name_id=>187, :is_sex_id=>0, :profile_id=>42, :relation_id=>2}, 36=>{:is_name_id=>343, :is_sex_id=>1, :profile_id=>32, :relation_id=>1}, 31=>{:is_name_id=>40, :is_sex_id=>1, :profile_id=>34, :relation_id=>5}, 41=>{:is_name_id=>351, :is_sex_id=>1, :profile_id=>35, :relation_id=>1}, 32=>{:is_name_id=>90, :is_sex_id=>1, :profile_id=>34, :relation_id=>1}, 43=>{:is_name_id=>187, :is_sex_id=>0, :profile_id=>40, :relation_id=>8}, 40=>{:is_name_id=>351, :is_sex_id=>1, :profile_id=>38, :relation_id=>1}, 52=>{:is_name_id=>370, :is_sex_id=>1, :profile_id=>42, :relation_id=>7}, 37=>{:is_name_id=>293, :is_sex_id=>0, :profile_id=>32, :relation_id=>2}, 39=>{:is_name_id=>173, :is_sex_id=>0, :profile_id=>38, :relation_id=>6}, 35=>{:is_name_id=>173, :is_sex_id=>0, :profile_id=>31, :relation_id=>8}}} (pid:3463)
        # sim_data = {:log_connection_id=>nil,
        #             :similars=>[{:first_profile_id=>38, :first_relation_id=>"Жена", :name_first_relation_id=>"Петра", :first_name_id=>"Ольга", :first_sex_id=>"Ж", :second_profile_id=>42, :second_relation_id=>"Сестра", :name_second_relation_id=>"Елены", :second_name_id=>"Ольга", :second_sex_id=>"Ж", :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370]}, :common_power=>4, :inter_relations=>[]},
        #                         {:first_profile_id=>41, :first_relation_id=>"Отец", :name_first_relation_id=>"Елены", :first_name_id=>"Олег", :first_sex_id=>"М", :second_profile_id=>40, :second_relation_id=>"Отец", :name_second_relation_id=>"Ольги", :second_name_id=>"Олег", :second_sex_id=>"М", :common_relations=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[370]}, :common_power=>4, :inter_relations=>[]}]
        #             }
        #
        # similars = [{:first_profile_id=>38, :first_relation_id=>"Жена", :name_first_relation_id=>"Петра", :first_name_id=>"Ольга", :first_sex_id=>"Ж", :second_profile_id=>42, :second_relation_id=>"Сестра", :name_second_relation_id=>"Елены", :second_name_id=>"Ольга", :second_sex_id=>"Ж", :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370]}, :common_power=>4, :inter_relations=>[]}, {:first_profile_id=>41, :first_relation_id=>"Отец", :name_first_relation_id=>"Елены", :first_name_id=>"Олег", :first_sex_id=>"М", :second_profile_id=>40, :second_relation_id=>"Отец", :name_second_relation_id=>"Ольги", :second_name_id=>"Олег", :second_sex_id=>"М", :common_relations=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[370]}, :common_power=>4, :inter_relations=>[]}] (pid:3463)

    logger.info "In SimilarsStart 2:  tree_info = #{tree_info}"
    logger.info "In SimilarsStart 2:  sim_data = #{sim_data}"
    logger.info "In SimilarsStart 2:  similars = #{similars}"
    @log_connection_id = current_tree_log_id(tree_info[:connected_users]) unless tree_info.empty?

    if similars.empty?   # т.е. нет похожих
      flash.now[:notice] = "Успешное сообщение: В дереве - все Ок. - internal_similars_search"
    else  # т.е. есть похожие
      unless sim_data.empty?  # т.е. есть инфа о похожих
        flash.now[:alert] = "Предупреждение: В дереве есть 'похожие' профили. Объединиться будет невозможно - internal_similars_search"
        @tree_info = tree_info  # To View
        view_tree_data(tree_info, sim_data) unless @tree_info.empty?  # to internal_similars_search.html.haml
      end
    end



  end



  def show_similars_data
  end



  # Отобр-е параметров дерева и sim_data во вьюхе
  def view_tree_data(tree_info, sim_data)
    @tree_info = tree_info
    logger.info "In similars_contrler 1:  @tree_info[:connected_users] = #{tree_info[:connected_users]}, @tree_info = #{tree_info},  "  if !tree_info.blank?
    logger.info "In similars_contrler 1a: @tree_info.profiles.size = #{tree_info[:profiles].size} "  if !tree_info.blank?
   # @log_connection_id = sim_data[:log_connection_id]
    @current_user_id = current_user.id
    view_similars(sim_data) unless sim_data.empty?
  end


  # Отображение во вьюхе Похожих и - для них - непохожих, если есть
  def view_similars(sim_data)
    @sim_data = sim_data  #
    logger.info "In similars_contrler 01:  @sim_data = #{@sim_data} "
    @similars = sim_data[:similars]
    @similars_qty = @similars.size unless sim_data[:similars].empty?
    #################################################
    @paged_similars_data = pages_of(@similars, 10) # Пагинация - по 10 строк на стр.

  end


  # Для текущего дерева - получение номера id лога для прогона разъединения Похожих,
  # ранее объединенных.
  # Если такой лог есть, значит ранее были найдены похожие и они объединялись. Значит теперь их
  # можно разъединять.
  # Последний id (максимальный) из существующих логов - :connected_at
  def current_tree_log_id(connected_users)
    # Сбор всех id логов, относящихся к текущему дереву
    current_tree_logs_ids = SimilarsLog.where(current_user_id: connected_users).pluck(:connected_at).uniq
    logger.info "In internal_similars_search 1b: @current_tree_logs_ids = #{current_tree_logs_ids} " if !current_tree_logs_ids.blank?
    log_connection_id = current_tree_logs_ids.max
    logger.info "In internal_similars_search 1b: log_connection_id = #{log_connection_id} " if !log_connection_id.blank?
    log_connection_id
  end


  # Готовит данные для Объединения похожих профилей - similars_connection_data
  # ПЕредает их в модель для непосредственного объединения
  def connect_similars
    first_profile_connecting  = params[:first_profile_id].to_i
    second_profile_connecting = params[:second_profile_id].to_i
    init_hash = { first_profile_connecting => second_profile_connecting}
    logger.info "*** In connect_similars 2:  init_hash = #{init_hash} "

    # todo: check similars_complete_search, when init_hash has many profiles
    # todo: also - to manipulate  buttons "Yes/No - to connect" in multiple rows in case many profiles

    ############ call of User.module ############################################
    profiles_to_rewrite, profiles_to_destroy = current_user.similars_complete_search(init_hash)
    #############################################################################
    @profiles_to_rewrite = profiles_to_rewrite # TO_VIEW
    @profiles_to_destroy = profiles_to_destroy # TO_VIEW

    #############################################################################
    # SimilarsLog.delete_all
    # SimilarsLog.reset_pk_sequence
    #############################################################################

    last_log_id = SimilarsLog.last.connected_at unless SimilarsLog.all.empty?
    logger.info "*** In connect_similars last_log_id = #{last_log_id.inspect}"
    # порядковый номер connection - взять значение из последнего лога
    last_log_id == nil ? last_log_id = 1 : last_log_id += 1
    logger.info "*** In connect_similars last_log_id = #{last_log_id.inspect}"
    #############################################################################

    similars_connection_data = {profiles_to_rewrite: profiles_to_rewrite, #
                                profiles_to_destroy: profiles_to_destroy,
                                current_user_id: current_user.id,
                                connection_id: last_log_id }

    # Лог - это массив записей о параметрах всех совершенных объединениях дерева
    # храниться должен отдельно

    ############ call of User.module Similars_connection ########################

    @log_connection = current_user.similars_connect_tree(similars_connection_data)
    logger.info "*** In  Similars_Controller connect_similars: @log_connection = \n     #{@log_connection} "
    @log_connection_id = @log_connection[:log_user_profile][0][:connected_at] unless @log_connection[:log_user_profile].blank?
    logger.info "*** In  Similars_Controller connect_similars: @log_connection_id = #{@log_connection_id} "
    @log_user_profile_size = @log_connection[:log_user_profile].size unless @log_connection[:log_user_profile].blank?
    @log_connection_tree_size = @log_connection[:log_tree].size unless @log_connection[:log_tree].blank?
    @log_connection_profilekey_size = @log_connection[:log_profilekey].size unless @log_connection[:log_profilekey].blank?
    @complete_log = @log_connection[:log_user_profile] + @log_connection[:log_tree] + @log_connection[:log_profilekey]
    logger.info "*** In  Similars_Controller connect_similars: @complete_log = \n     #{@complete_log} "
    @complete_log_size = @complete_log.size unless @complete_log.blank?
    logger.info "*** In  Similars_Controller connect_similars: @complete_log_size = #{@complete_log_size} "

    flash[:notice] = "Успешное сообщение - internal_similars_search"


  end

  # Оставляет похожие профили без объединения
  # помечаем их как непохожие на будущее
  def keep_disconnected_similars
    first_profile_connecting = params[:first_profile_id]
    second_profile_connecting = params[:second_profile_id]
    logger.info "*** In keep_disconnected_similars:  first_profile_connecting = #{first_profile_connecting},  second_profile_connecting = #{second_profile_connecting} "
    ############ call of User.module ############################################
    current_user.without_connecting_similars

  end

  # Возвращает объединенные профили в состояние перед объединением
  # во всех таблицах
  def disconnect_similars

    log_id = params[:log_connection_id]
    logger.info "*** In disconnect_similars:  log_id = #{log_id}"
    @log_id = log_id.to_i

    # logger.info "*** In disconnect_similars:  profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy} "
    ############ call of User.module Similars_disconnection #####################
    current_user.disconnect_sims_in_tables(log_id.to_i)

    # respond_to do |format|
    #   format.js { render :js => "window.location.href = '#{home_path}'" }
    # end

  end


  # Контроль (тест) объединения профилей после объединения - по таблицах ProfileKey
  #
  def check_connected_similars

    log_id = params[:log_connection_id]
    logger.info "*** In check_connected_similars:  log_id = #{log_id}"
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
