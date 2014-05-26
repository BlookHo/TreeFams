class ApplicationController < ActionController::Base
 # include MainSearchHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  #before_filter :set_locale

  Time::DATE_FORMATS[:ru_datetime] = "%Y.%m.%d в %k:%M:%S"
  @time = Time.current #  Ок  - Greenwich   instead of Time.now - Moscow


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
  def fill_hash(one_hash, str_elem) # Filling of hash with keys and values, according to key occurance
    if str_elem.blank? or str_elem == "" or str_elem == nil
      one_hash['Не найдено'] += 1
    else
      test = one_hash.key?(str_elem) # Is  str_elem in one_hash?
      if test == false #  "NOT Found in hash"
        one_hash.merge!({str_elem => 1}) # include str_elem with val=1 in hash
      else  #  "Found in hash"
        one_hash[str_elem] += 1 # increase (+1) val of occurance of str_elem
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
