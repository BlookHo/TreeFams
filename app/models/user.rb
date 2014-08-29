class User < ActiveRecord::Base
  include Search
  include SearchHard
  include UserLock

  has_secure_password

  validates :email,
            :uniqueness => true,
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }


  # User profile
  has_one  :profile,  dependent: :destroy
  has_many :trees,    dependent: :destroy
  has_many :profile_keys, dependent: :destroy


  def name
    profile.name.name.capitalize
  end

  # Получение массива соединенных Юзеров
  # для заданного "стартового" Юзера
  #
  def get_connected_users
    connected_users_arr = []
    connected_users_arr << self.id
    first_users_arr = ConnectedUser.where(user_id: self.id).pluck(:with_user_id)
    if first_users_arr.blank?
      first_users_arr = ConnectedUser.where(with_user_id: self.id).pluck(:user_id)
    end
    one_connected_users_arr = first_users_arr
    if !one_connected_users_arr.blank?
      connected_users_arr << one_connected_users_arr
      connected_users_arr.flatten!.uniq! if !connected_users_arr.blank?
      one_connected_users_arr.each do |conn_arr_el|
        next_connected_users_arr = ConnectedUser.where("(user_id = #{conn_arr_el} or with_user_id = #{conn_arr_el})").pluck(:user_id, :with_user_id)
        if !next_connected_users_arr.blank?
          one_connected_users_arr << next_connected_users_arr
          one_connected_users_arr.flatten!.uniq! if !one_connected_users_arr.blank?
          connected_users_arr << next_connected_users_arr
          connected_users_arr.flatten!.uniq! if !connected_users_arr.blank?
        end
      end
    end
    return connected_users_arr
  end

  private

  def self.create_with_email(email)
    self.create(email: email, password: User.generate_password, password_confirmation: User.generate_password)
  end

  def self.generate_password
    '1111'
  end


end
