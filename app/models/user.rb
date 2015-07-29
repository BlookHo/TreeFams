class User < ActiveRecord::Base

  include Search                # основной метод поиска
  include SearchComplete        # метод полного поиска
  include SearchHelper          # Исп-ся в Search,  SimilarsCompleteSearch
  include ConnectionTrees       # основной метод объединения деревьев
  include DisconnectionTrees    # основной метод разъединения деревьев

  include SimilarsStart          # запуск методов поиска стартовых пар похожих
  include SimilarsInitSearch     # методы поиска стартовых пар похожих
  include SimilarsExclusions     # методы учета отношений исключений
  include SimilarsCompleteSearch # методы поиска похожих
  include SimilarsConnection     # методы объединения похожих
  include SimilarsDisconnection  # методы разъобъединения похожих

  include SimilarsHelper  # Исп-ся в Similars

  include ProfileCreation  # Исп-ся в Profiles
  include ProfileDestroying  # Исп-ся в Profiles

  include UserLock # вроде бы не используется
  include UserAccount



  before_create :generate_access_token
  after_create :update_connected_users!


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
  def get_connected_users
    connected_users_arr = [self.id]
    first_users_arr = ConnectedUser.connected_users_ids(self).uniq
    if first_users_arr.blank?
      first_users_arr = ConnectedUser.connected_with_users_ids(self).uniq
    end
    one_connected_users_arr = first_users_arr
    unless one_connected_users_arr.blank?
      connected_users_arr = get_growing_arr(connected_users_arr, one_connected_users_arr)
      one_connected_users_arr.each do |conn_arr_el|
        next_connected_users_arr = ConnectedUser.where("(user_id = #{conn_arr_el} or with_user_id = #{conn_arr_el})").pluck(:user_id, :with_user_id)
        unless next_connected_users_arr.blank?
          one_connected_users_arr = get_growing_arr(one_connected_users_arr, next_connected_users_arr)
          connected_users_arr = get_growing_arr(connected_users_arr, next_connected_users_arr)
        end
      end
    end
    connected_users_arr.sort
  end

  # Наращивает массив и упорядочивает его
  def get_growing_arr(growing_arr, one_next_arr)
    growing_arr << one_next_arr
    growing_arr.flatten!.uniq! unless growing_arr.blank?
    growing_arr
  end


  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  # Извлечение имени юзера и склонение его по падежу
  # @param user_id [Integer] id юзера - получателя сообщения
  # @param padej [Integer] падеж
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



  def update_connected_users!
    connected_user_ids = self.get_connected_users
    cids = connected_user_ids.size > 0 ? connected_user_ids : [self.id]
    connected_user_ids.each do |connected_user_id|
      user = User.find(connected_user_id)
      user.update_attribute(:connected_users, connected_user_ids)
    end
  end


  def update_disconnected_users!
    self.connected_users.each do |connected_user_id|
      user = User.find(connected_user_id)
      user.update_attribute(:connected_users, user.get_connected_users)
    end
  end




  #########################################
  # Методы похожих профилей - SIMILARS
  #########################################
  # Оставляет похожие профили без объединения
  # помечаем их как непохожие на будущее
  def without_connecting_similars
    msg_connection = "without_connecting_similars"
    logger.info "*** In User.without_connecting_similars: #{msg_connection} "
  end


  def reset_password
    password = User.generate_password
    self.update_attributes(password: password, password_confirmation: password)
    UserMailer.reset_password(self, password).deliver
  end


  # @note Получение массивов юзеров - мужчин и женщин в дереве
  def self.get_users_male_female(connected_users)
    user_males = []
    user_females = []
    connected_users.each do |conn_user|
      profile_user = Profile.find(User.find(conn_user).profile_id)
      profile_user.sex_id == 1 ? user_males << profile_user.id : user_females << profile_user.id
    end
    user_males_qty = user_males.size # all tree male users qty
    user_females_qty = user_females.size # all tree female users qty

    { user_males: user_males,
      user_females: user_females,
      user_males_qty: user_males_qty,
      user_females_qty: user_females_qty }
  end


  private

  def self.create_with_email(email)
    self.create(email: email, password: User.generate_password, password_confirmation: User.generate_password)
  end

  def self.generate_password
    '1111'
  end



end
