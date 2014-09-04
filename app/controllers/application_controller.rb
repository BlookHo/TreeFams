class ApplicationController < ActionController::Base

  # Http server Authorization only in production
  if Rails.env =~ /production/
    http_basic_authenticate_with name: "interweb", password: "interweb"
  end

  # include MainSearchHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user,
                :logged_id?,
                :is_admin?


  before_filter do
    Member if Rails.env =~ /development/
  end


  def current_user
    @current_user ||= User.find(session[:user_id])  if session[:user_id]
  end


  def is_admin?
    current_user && current_user.is_admin?
  end



  def logged_in?
    access_denied if !current_user
  end


  def access_denied
    respond_to do |format|
      format.html { redirect_to :root, :alert => 'Для просмотра этой страницы вам нужно войти на сайт!'}
      # format.js { render :template => '/shared/access_denied'}
    end
  end

  Time::DATE_FORMATS[:ru_datetime] = "%Y.%m.%d в %k:%M:%S"
  @time = Time.current #  Ок  - Greenwich   instead of Time.now - Moscow

  # Получение массива дерева соединенных Юзеров из Tree
  #  На входе - массив соединенных Юзеров
  def get_connected_users_tree(connected_users_arr)
    # Этот метод оставлен здесь для отладочного отображения
    # tree_arr
    # В search_soft.rb исп-ся get_connected_tree(connected_users_arr)

    tree_arr = []
    check_tree_arr = [] # "опорный массив" - для удаления повторных элементов при формировании tree_arr
    connected_users_arr.each do |one_user|

      user_tree = Tree.where(:user_id => one_user)
      row_arr = []
      check_row_arr = []

      user_tree.each do |tree_row|
        row_arr[0] = tree_row.user_id              # user_id ID От_Профиля
        row_arr[1] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        row_arr[2] = tree_row.name_id              # name_id ID От_Профиля
        row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        row_arr[4] = tree_row.is_profile_id        # ID К_Профиля
        row_arr[5] = tree_row.is_name_id           # name_id К_Профиля
        row_arr[6] = tree_row.is_sex_id            # sex К_Профиля
        row_arr[7] = tree_row.connected            # Объединено дерево К_Профиля с другим деревом

        check_row_arr[0] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        check_row_arr[1] = tree_row.name_id              # name_id ID От_Профиля
        check_row_arr[2] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        check_row_arr[3] = tree_row.is_profile_id        # ID К_Профиля
        check_row_arr[4] = tree_row.is_name_id           # name_id К_Профиля
        check_row_arr[5] = tree_row.is_sex_id            # sex К_Профиля

        #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.include?(row_arr).inspect}" # == false
        #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.inspect} --- #{row_arr}"
        if !check_tree_arr.include?(check_row_arr) # контроль на наличие повторов
          tree_arr << row_arr
          check_tree_arr << check_row_arr
        end
        row_arr = []
        check_row_arr = []
      end

    end
    #session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}

    @len_check_tree = check_tree_arr.length  if !check_tree_arr.blank?
    return tree_arr

  end


  # Формирование массивов значений для форм ввода типа select.
  # @note GET /
  # @note
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def form_select_arrays

    @sel_names = []
    @sel_names_male = []
    @sel_names_female = []

    @sel_relations = []
    @sel_countries = []
    @sel_cities = []

    #@sel_sex = []
    #@sel_educ = []
    #@sel_confess = []
    #@sel_politics = []

    #Sex.all.each do |sex|
    #  @sel_sex << sex.name
    #end
    #Education.all.each do |education|
    #  @sel_educ << education.name
    #end
    #Confession.all.each do |confession|
    #  @sel_confess << confession.name
    #end
    #Politic.all.each do |politic|
    #  @sel_politics << politic.name
    #end

    #Country.all.each do |country|
    #  @sel_countries << country.name
    #end

    Name.all.each do |name|
      @sel_names << name.name # Both male & female names array
      name.only_male ? @sel_names_male << name.name : @sel_names_female << name.name
      # make @sel_names_male array or @sel_names_female array в зависимости от значения name.only_male
    end

    Relation.all.each do |relation|
      @sel_relations << relation.relation
    end

    session[:sel_names] = {:value => @sel_names, :updated_at => Time.current}
    #unless current_user.country.blank?
    #  current_user.country.cities.each do |city|
    #    @sel_cities << city.name
    #  end
    #  @sel_cities.sort!
    #end

    #@twitter_authentication = Authentication.where(:user_id => current_user.id.to_s, :provider => "twitter").first
    #@facebook_authentication = Authentication.where(:user_id => current_user.id.to_s, :provider => "facebook").first
    #@vkontakte_authentication = Authentication.where(:user_id => current_user.id.to_s, :provider => "vkontakte").first
    #
    #sex = current_user.sex
    #!sex.blank? ? @user_sex = sex.name : @user_sex = 0
    #education = current_user.education
    #!education.blank? ? @user_education = education.name : @user_education = 0
    #politic = current_user.politic
    #!politic.blank? ? @user_politic = politic.name : @user_politic = 0
    #confession = current_user.confession
    #!confession.blank? ? @user_confession = confession.name : @user_confession = 0
    #country = current_user.country
    #!country.blank? ? @user_country = country.name : @user_country = 0
    #city = current_user.city
    #!city.blank? ? @user_city = city.name : @user_city = 0
  end


  @@approved_match_qty = 0

  @@match_qty = 0



  # Автоматическое определение пола по имени.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  def check_sex_by_name(user_name)
    user_sex = 0    # Female name
    find_name=Name.select(:only_male).where(:name => user_name)
    @find_name = find_name
    user_sex = 1 if !find_name.blank? and find_name[0]['only_male']    # Male name

    return user_sex
  end


  # Автоматическое наполнение хэша сущностями и
  # количеством появлений каждой сущности.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place = main_contrl.,
  ################# FILLING OF HASH WITH KEYS AND/OR VALUES
  def fill_hash(one_hash, elem) # Filling of hash with keys and values, according to key occurance
    if elem.blank? or elem == "" or elem == nil
      one_hash['Не найдено'] += 1
    else
      test = one_hash.key?(elem) # Is  elem in one_hash?
      if test == false #  "NOT Found in hash"
        one_hash.merge!({elem => 1}) # include elem with val=1 in hash
      else  #  "Found in hash"
        one_hash[elem] += 1 # increase (+1) val of occurance of elem
      end
    end
  end

  # Автоматическое наполнение хэша сущностями и
  # количеством появлений каждой сущности.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place = main_contrl.,
  ################# FILLING OF HASH WITH KEYS AND/OR VALUES
  def two_hashes_check(one_hash, second_hash) # Filling of hash with keys and values, according to key occurance

    rez_hash = {}
    sec_val_arr = second_hash.values
    sec_key_arr = second_hash.keys

    ind = 0
    one_hash.each do |key, val|
      if sec_val_arr[ind] >= val
        rez_hash.merge!({key => val}) # наполнение хэша найденными profile_id
      end
      ind += 1
    end
    return rez_hash
  end



















end
