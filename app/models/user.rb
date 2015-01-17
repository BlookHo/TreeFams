class User < ActiveRecord::Base
  include Search
  # основной метод поиска

  include SimilarsInitSearch     # методы поиска стартовых пар похожих
  include SimilarsExclusions     # методы учета отношений исключений
  include SimilarsCompleteSearch # методы поиска похожих
  include SimilarsConnection     # методы объединения похожих
  include SimilarsDisconnection  # методы разъобъединения похожих

  include SimilarsHelper  # Исп-ся в Similars

  include SearchHelper  # Исп-ся в Search,  SimilarsCompleteSearch

  include UserLock # вроде бы не используется
  include UserAccount



  before_create :generate_access_token


  validates :email,
            :uniqueness => true,
            :format => {
              :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }

  has_secure_password

  # User profile
  has_one  :profile,  dependent: :destroy
  has_many :trees,    dependent: :destroy
  has_many :profile_keys, dependent: :destroy

  has_many :connection_requests, dependent: :destroy

  has_many :updates_feeds, dependent: :destroy



  def name
    profile.name.name.capitalize
  end


  # Получение массива соединенных Юзеров
  # для заданного "стартового" Юзера
  #
  def get_connected_users
    #todo:
    # connected_users_arr = [self.id]
    connected_users_arr = []
    connected_users_arr << self.id
    #first_users_arr = ConnectedUser.where(user_id: self.id).pluck(:with_user_id)
    first_users_arr = ConnectedUser.connected_users_ids(self)
    if first_users_arr.blank?
      first_users_arr = ConnectedUser.where(with_user_id: self.id).pluck(:user_id)
    end
    one_connected_users_arr = first_users_arr
    #todo: unless вместо if!
    #todo: вынести в метод
    if !one_connected_users_arr.blank?

      connected_users_arr << one_connected_users_arr
      connected_users_arr.flatten!.uniq! unless connected_users_arr.blank?

      one_connected_users_arr.each do |conn_arr_el|
        next_connected_users_arr = ConnectedUser.where("(user_id = #{conn_arr_el} or with_user_id = #{conn_arr_el})").pluck(:user_id, :with_user_id)
        unless next_connected_users_arr.blank?

          one_connected_users_arr << next_connected_users_arr
          one_connected_users_arr.flatten!.uniq! if !one_connected_users_arr.blank?

          connected_users_arr << next_connected_users_arr
          connected_users_arr.flatten!.uniq! if !connected_users_arr.blank?

        end
      end
    end
    connected_users_arr
  end



  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  # Извлечение имени юзера и склонение его по падежу
  # @param data [receiver_id] id юзера - получателя сообщения
  # @param data [padej] падеж
  def self.show_user_name(user_id, padej)
    user = User.find(user_id)
    user_name = user.get_user_name # Определение имени юзера
    user_name != "" ? inflected_name = YandexInflect.inflections(user_name)[padej]["__content__"] : inflected_name = ""
    inflected_name
  end


  # Определение имени юзера
  def get_user_name
    Name.find(Profile.find(self.profile_id).name_id).name
  end

  # Определение имени юзера - из списка имен юзеров
  def self.all_users_names
    users = User.all
    users_names = []
    users.each do |user|
      users_names << user.get_user_name
    end
    users_names
  end





  #########################################
  # Методы похожих профилей - SIMILARS
  #########################################

  # Объединяет похожие профили
  # запуск объединения похожих профилей
  def connecting_similars(similars_connection_data)
    msg_connection = "connecting_similars"
    logger.info "*** In User.connecting_similars: #{msg_connection} "

    profiles_to_rewrite = similars_connection_data[:profiles_to_rewrite]
    profiles_to_destroy = similars_connection_data[:profiles_to_destroy]

    # методы соединения профилей = перезапись профилей в таблицах
    self.connect_sims_in_tables(profiles_to_rewrite, profiles_to_destroy)

    # Перезапись profile_data при объединении профилей
    #  ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)

  end

  # Оставляет похожие профили без объединения
  # помечаем их как непохожие на будущее
  def without_connecting_similars

    msg_connection = "without_connecting_similars"
    logger.info "*** In User.without_connecting_similars: #{msg_connection} "

  end

  # Возвращает объединенные профили в состояние перед объединением
  # во всех таблицах
  def disconnecting_similars(profiles_to_rewrite, profiles_to_destroy)
    logger.info "*** In User.disconnecting_similars:  profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy} "
    # методы разсоединения профилей = обратная перезапись профилей в таблицах
    self.disconnect_sims_in_tables(profiles_to_rewrite, profiles_to_destroy)


  end



  private

  def self.create_with_email(email)
    self.create(email: email, password: User.generate_password, password_confirmation: User.generate_password)
  end

  def self.generate_password
    '1111'
  end






end
