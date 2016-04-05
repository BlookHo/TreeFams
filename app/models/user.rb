class User < ActiveRecord::Base

  include SearchMain            # модифицированный основной метод поиска, , с отработкой исключений противоречий
                                # между найденными профилями
  include SearchActualProfiles  # определение актуальных профилей - для основного поиска
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

  include DoubleUsersSearch


  before_create :generate_access_token
  # after_create :update_connected_users!
  before_save :downcase_email


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


  # @note: delete one user by his ID
  def delete_one_user
    logger.info "In self.delete_one_user:  #{self.id} - Это дерево является дубликатом: - будем удалять ! "

    # delete ConnectedUser
    ConnectedUser.where("user_id = ? OR with_user_id = ?", self.id, self.id).destroy_all
    # delete DeletionLog
    DeletionLog.where("current_user_id = ?", self.id).destroy_all
    # delete SearchResults
    SearchResults.where("user_id = ? OR found_user_id = ?", self.id, self.id).destroy_all
    # delete SimilarsFound
    SimilarsFound.where("user_id = ?", self.id).destroy_all
    # delete ConnectionLogs
    ConnectionLog.where("current_user_id = ? OR with_user_id = ?", self.id, self.id).destroy_all
    # delete SimilarsLog
    SimilarsLog.where("current_user_id = ?", self.id).destroy_all
    # delete CommonLog
    CommonLog.where("user_id = ?", self.id).destroy_all
    # delete Profiles
    Profile.where("tree_id = ?", self.id).destroy_all

    # all others: trees, profile_keys, connection_requests, updates_feeds - TO CHECK DESTROYING
    User.find(self.id).destroy

    logger.info  "Удален #{self.id} пользователь" # ??

  end


  def name
    profile.name.name.capitalize unless profile.blank?  # If wrong connect between two users
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

  # @note: Определение all emails of юзерS
  def self.all_users_emails
    users = User.all
    users_names = []
    users.each do |user|
      users_names << user.email
    end
    users_names
  end

  # @note: prepare users_data for weekly mail
  #   users_data = { :users_names, :users_emails }
  def self.users_mail_info
    users_names = User.all_users_names
    # puts "In collect_weekly_info:  users_names = #{users_names}"
    users_emails = User.all_users_emails
    # puts "In collect_weekly_info:  users_emails = #{users_emails}"
    { users_names: users_names, users_emails: users_emails }
  end


  def update_connected_users!
    connected_user_ids = self.get_connected_users
    # cids =
    connected_user_ids.size > 0 ? connected_user_ids : [self.id]
    connected_user_ids.each do |connected_user_id|
      user = User.find(connected_user_id)
      user.update_attribute(:connected_users, connected_user_ids)
      logger.info "In update_connected_users!: self.get_connected_users = #{self.get_connected_users}"
      logger.info "In update_connected_users!: self.connected_users = #{self.connected_users}"
    end
    logger.info "user updated: connected_users = #{connected_user_ids}"
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


  # @note Получение массивов юзеров - мужчин и женщин в ОДНОМ дереве
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


  # @note Получение массивов юзеров - мужчин и женщин on site
  def self.collect_user_stats
    all_users = all.count
    users_sex = collect_sex_users
     { users: all_users, users_male: users_sex[:users_male], users_female: users_sex[:users_female] }
  end

  # @note: Call from collect_user_stats - to User stats -  on site
  def self.collect_sex_users
    users_male = 0
    users_female = 0
    all.each do |user|
      user_profile = user.profile
      unless user_profile.blank?
        user_profile.sex_id == 1 ? users_male += 1 : users_female += 1
      end
    end
    { users_male: users_male, users_female: users_female}
  end


  # @note: collect profiles_ids of users array
  #   use in weekly manifest email
  def self.users_profiles(new_users_connected)
    users_profiles = []
    new_users_connected.each do |one_user_id|
      one_profile_id = find(one_user_id).profile_id
      users_profiles << one_profile_id
    end
    users_profiles
  end

  # @note: main week user data
  def self.week_user_info(user_to_send)

    user_to_send_id = user_to_send[0].id
    puts "user to send_id = #{user_to_send_id} "

    user_profile = Profile.find(user_to_send[0].profile_id)
    user_sex = user_profile.sex_id

    puts "user to send: user_sex = #{user_sex}"

    user_weekly_info = User.find(user_to_send_id).collect_weekly_info
    puts "To send user_weekly_info = #{user_weekly_info}"
    tree_profiles_qty = user_weekly_info[:tree_info][:qty_of_tree_profiles]
    #      @tree_users_qty = user_weekly_info[:tree_info][:qty_of_tree_users] # YET NO USE in Mail View

    { user_sex: user_sex,
      user_weekly_info: user_weekly_info,
      tree_profiles_qty: tree_profiles_qty }
  end

  # @note: collect profiles_ids of users array
  #   start weekly manifest email to all active users
  #   sending weekly mail data for every user
  def self.send_weekly_manifest
    week_ago_time = 1.week.ago
    puts "In 1 collect_weekly_info:  week_ago_time = #{week_ago_time}"

    # users_data = User.users_mail_info
    # puts "In weekly_manifest_email: users_data = #{users_data}"  # current_user_id = #{self.id},
    # users_data =
    #     {:users_names=>
    #          ["Алексей", "Анна", "Наталья", "Таисия", "Вера", "Петр", "Дарья", "Федор"],
    #      :users_emails=>["alexey@al.al", "aneta@an.an", "vera@na.na", "darja@pe.pe",
    #                      "natalia@pe.pe", "petr@pe.pe", "taisia@pe.pe", "fedor@pe.pe"]}

    # # real sending
    users_data =     # Август  loc user_id = 23  pr+id = 404
        #, "Денис", "Алексей","Август"],  # Алексей  loc user_id = 57 # prod  user_id = 3 pr_id = 8724, name_id = 29
        # {:users_names=> ["Денис"],
        # :users_emails=>["denis@lobkov.net"] }
        # {:users_names=> ["Август"],
        # :users_emails=>["blookho@gmail.com"] }

        {:users_names=> ["Август", "Алексей"], # last come
        :users_emails=>["blookho@gmail.com", "zoneiva@gmail.com"] }

        # {:users_names=> [ "Алексей"],
        # :users_emails=>[ "zoneiva@gmail.com"] }

    # {:users_names=> [ "Алексей","Денис", "Август"],
    # :users_emails=>[ "zoneiva@gmail.com", "denis@lobkov.net", "blookho@gmail.com" ] }

    #, "denis@lobkov.net", "medvedev.alexey@gmail.com", "blookho@gmail.com"] }

    # denis@lobkov.net                  loc user_id = 61      prod  user_id = 3,  pr_id =  1059, name_id = 155 Денис
    # medvedev.alexey@gmail.com         prod  user_id = 1,  pr_id = 1,     name_id = 29 Алексей
    # konstantin.starovoytov@gmail.com  prod  user_id = 9,  pr_id =  176,  name_id = 249 Константин
    # annach61@mail.ru                  loc user_id = 61   prod  user_id = 3,  pr_id = 8725,  name_id = 533 Анета

    # mailcatcher sending
    # users_data =
    #     {:users_names=> ["Андрей"],
    #      :users_emails=>["andrey-7-tree@an.an"] }
    # {:users_names=> ["Андрей"],
    # :users_emails=>["azoneiva@gmail.coma"] }


    puts "In proceed_weekly_mail: users_data = #{users_data} "
    count_emails = 0
    users_data[:users_emails].each_with_index do |one_email, index|
      user_to_send = User.where( email: one_email)
      logger.info "In proceed_weekly_mail: user_to_send = #{user_to_send},  "
      unless user_to_send.blank?

        ## Main user's info ###############################################################################
        week_user_data = week_user_info(user_to_send)
        user_name         = users_data[:users_names][index]
        user_sex          = week_user_data[:user_sex]
        user_weekly_info  = week_user_data[:user_weekly_info]
        tree_profiles_qty = week_user_data[:tree_profiles_qty]

          # user_weekly_info =
          # {:site_info=>
          #      {:profiles=>405, :profiles_male=>219, :profiles_female=>186, :users=>29,
          #       :users_male=>23, :users_female=>6, :trees=>24, :invitations=>3, :requests=>55,
          #       :connections=>47, :refuse_requests=>0, :disconnections=>34, :similars_found=>5},
          #  :tree_info=>
          #      {:tree_profiles=>[63, 69, 79, 967, 70, 64, 66, 84, 65, 80, 67, 68, 968, 969, 971],
          #       :connected_users=>[7, 8], :qty_of_tree_profiles=>15, :qty_of_tree_users=>2},
          #  :connections_info=>
          #      {:new_users_connected=>[8], :conn_count=>1, :new_users_profiles=>[66]}, # [8]
          #  :new_weekly_profiles=>
          #      {:new_profiles_qty=>6, :new_profiles_male=>4, :new_profiles_female=>2,
          #       :new_profiles_ids=>[64, 65, 63, 67, 68, 66]},  # [64, 65, 63, 67, 68, 66]
          #  :connection_requests_info=>
          #      {:request_users_ids=>[57], :request_users_qty=>1, :request_users_profiles=>[790]}}   # [57]


        #################################################################################
        # relatives_events
        if user_weekly_info[:connection_requests_info][:request_users_ids].blank?
          @new_relatives_events_exists = false
        else
          @new_relatives_events_exists = true


        end


        #################################################################################
        # connection_requests
        conn_req_profiles_complete = {}
        conn_req_tree_profiles_qty = 0

        if user_weekly_info[:connection_requests_info][:request_users_ids].blank?
          new_conn_requests_exists = false
        else
          new_conn_requests_exists = true
          # All requests:
          @connect_request_user_ids = user_weekly_info[:connection_requests_info][:request_users_ids]
          @connect_request_users_qty = user_weekly_info[:connection_requests_info][:request_users_qty]

          # First request
          connect_request_users_id = user_weekly_info[:connection_requests_info][:request_users_ids].first#
          @connect_request_users_id = [connect_request_users_id]
          connect_request_profile_id = user_weekly_info[:connection_requests_info][:request_users_profiles].first#
          @connect_request_profile_id = [connect_request_profile_id]
          connect_request_user_info = User.find(connect_request_users_id).collect_weekly_info
          puts "@connect_request_user_info = #{connect_request_user_info}"
          # @connect_request_user_info =
          # {:site_info=>
          #      {:profiles=>405, :profiles_male=>219, :profiles_female=>186, :users=>29,
          #       :users_male=>23, :users_female=>6, :trees=>24, :invitations=>3, :requests=>55,
          #       :connections=>47, :refuse_requests=>0, :disconnections=>34, :similars_found=>5},
          #  :tree_info=>
          #      {:tree_profiles=>[790, 792, 794, 814, 799, 796, 797, 791, 808, 898, 798, 815, 807,
          #                        795, 793, 913, 902, 806, 897, 813, 812],
          #       :connected_users=>[57, 58, 60], :qty_of_tree_profiles=>21, :qty_of_tree_users=>3},
          #  :connections_info=>
          #      {:new_users_connected=>[58, 58, 58, 58, 58, 58, 60, 60, 60, 60, 60, 60, 60, 60],
          #       :conn_count=>14,
          #       :new_users_profiles=>[795, 795, 795, 795, 795, 795, 794, 794, 794, 794, 794, 794, 794, 794]},
          #  :new_weekly_profiles=>
          #      {:new_profiles_qty=>0, :new_profiles_male=>0, :new_profiles_female=>0, :new_profiles_ids=>[]},
          #  :connection_requests_info=>{:request_users_ids=>[], :request_users_qty=>0, :request_users_profiles=>[]}}
          conn_req_tree_profiles_qty = connect_request_user_info[:tree_info][:qty_of_tree_profiles]
          @conn_req_tree_users_qty = connect_request_user_info[:tree_info][:qty_of_tree_users]

          conn_request_profiles_info = Profile.collect_profiles_info(@connect_request_profile_id)
          p "1 conn_request_profiles_info = #{conn_request_profiles_info}"
          @conn_request_profiles_info = conn_request_profiles_info # to view
          unless conn_request_profiles_info.blank?
            puts "2 @conn_request_profiles_info = #{@conn_request_profiles_info}"

            first_elements_qty = first_three_qty(conn_request_profiles_info)
            conn_req_profiles_info_three = conn_request_profiles_info.first(first_elements_qty).to_h
            @conn_req_profiles_info_three = conn_req_profiles_info_three # to view
            puts "3 @conn_req_profiles_info_three = #{@conn_req_profiles_info_three}"

            conn_req_profiles_complete = ProfileData.profiles_data_info(conn_req_profiles_info_three)
          end

        end


        #################################################################################
        # connections
        conn_profiles_info_complete = {}
        conn_tree_profiles_qty = 0
        conn_tree_users_qty = 0

        if user_weekly_info[:connections_info][:new_users_connected].blank?
          new_connections_exists = false
        else
          new_connections_exists = true
          new_connect_profiles_id = user_weekly_info[:connections_info][:new_users_profiles].first#
          @new_connect_profiles_id = [new_connect_profiles_id]
          new_user_connected_id = user_weekly_info[:connections_info][:new_users_connected].first #
          # @new_user_connected_id = [new_user_connected_id]

          connect_user_weekly_info = User.find(new_user_connected_id).collect_weekly_info
          # puts "@connect_user_weekly_info = #{connect_user_weekly_info}"

          conn_tree_profiles_qty = connect_user_weekly_info[:tree_info][:qty_of_tree_profiles]
          conn_tree_users_qty = connect_user_weekly_info[:tree_info][:qty_of_tree_users]

          connect_profiles_info = Profile.collect_profiles_info(@new_connect_profiles_id)
          # @connect_profiles_info = connect_profiles_info # to view

          unless connect_profiles_info.blank?
            # puts "@connect_profiles_info = #{@connect_profiles_info}"

            first_elements_qty = first_three_qty(connect_profiles_info)
            connect_profiles_info_three = connect_profiles_info.first(first_elements_qty).to_h
            # @connect_profiles_info_three = connect_profiles_info_three # to view
            # puts "@connect_profiles_info_three = #{@connect_profiles_info_three}"

            conn_profiles_info_complete = ProfileData.profiles_data_info(connect_profiles_info_three)
            puts "#### conn_profiles_info_complete = #{conn_profiles_info_complete}"
          end
        end


        #################################################################################
        # new profiles
        new_profiles_qty = 0
        new_profiles_females = 0
        new_profiles_males = 0
        profiles_info_complete = {}

        # profiles_ids = user_weekly_info[:new_weekly_profiles][:new_profiles_ids] # [2, 3, 7, 8, 9, 10, 11, 12, 13, ...]
        # data_profiles_ids = user_weekly_info[:new_weekly_profile_data][:new_profiles_ids] # [2, 3, 7, 8, 9, 10, 11, 12, 13, ...]


        if user_weekly_info[:new_weekly_profiles][:new_profiles_ids].blank?
          # new_profiles_exists = false
          if user_weekly_info[:new_weekly_profile_data][:new_profiles_ids].blank?
            new_profiles_exists = false
          else
            new_profiles_exists = true
            puts "new_weekly_profile_data "

            week_profiles_data = week_profiles_info(user_weekly_info[:new_weekly_profile_data])

            new_profiles_qty       = week_profiles_data[:new_profiles_qty]
            new_profiles_females   = week_profiles_data[:new_profiles_females]
            new_profiles_males     = week_profiles_data[:new_profiles_males]
            profiles_info_complete = week_profiles_data[:profiles_info_complete]
          end

        else
          new_profiles_exists = true
          puts "new_weekly_profiles "
          week_profiles_data = week_profiles_info(user_weekly_info[:new_weekly_profiles])

          new_profiles_qty       = week_profiles_data[:new_profiles_qty]
          new_profiles_females   = week_profiles_data[:new_profiles_females]
          new_profiles_males     = week_profiles_data[:new_profiles_males]
          profiles_info_complete = week_profiles_data[:profiles_info_complete]

        end

        # @confirmation_url = confirmation_url(user)
        #################################################################################

        events = {
            new_conn_requests_exists: new_conn_requests_exists,
            new_connections_exists:   new_connections_exists,
            new_profiles_exists:      new_profiles_exists
        }
        puts "events = #{events}"
        if Service.check_all_events_exists?(events) # Send OR not Send for this user?
          weekly_email_data = {
            user_sex:                       user_sex,
            user_name:                      user_name,
            tree_profiles_qty:              tree_profiles_qty,
            new_connections_exists:         new_connections_exists,
            connect_profiles_info_complete: conn_profiles_info_complete,
            connect_tree_profiles_qty:      conn_tree_profiles_qty,
            connect_tree_users_qty:         conn_tree_users_qty,
            new_profiles_exists:            new_profiles_exists,
            new_profiles_qty:               new_profiles_qty,
            new_profiles_females:           new_profiles_females,
            new_profiles_males:             new_profiles_males,
            profiles_info_complete:         profiles_info_complete,
            new_conn_requests_exists:       new_conn_requests_exists,
            conn_req_profiles_complete:     conn_req_profiles_complete,
            conn_req_tree_profiles_qty:     conn_req_tree_profiles_qty,
            email_name:                     one_email
          }
          #################################################################################
          WeafamMailer.weekly_manifest_email(weekly_email_data).deliver_now # send one user weekly email
          #################################################################################
          count_emails += 1
          puts "*** Week manifest email sent Ok to #{one_email} ***"
        end
      end

    end
    puts "In proceed_weekly_mail: count_week_emails = #{count_emails}"
    count_emails

  end

  # @note: collect wek profiles info
  def self.week_profiles_info(new_weekly_profiles)
    # puts "In week_profiles_info: new_weekly_profiles = #{new_weekly_profiles}"
    new_profiles_ids = new_weekly_profiles[:new_profiles_ids]
    new_profiles_qty = new_profiles_ids.size # 17
    @new_profiles_three = new_profiles_ids.take(3) # [2, 3, 7
    profiles_info = Profile.collect_profiles_info(new_profiles_ids)
    # @profiles_info = profiles_info # to view
    profiles_info_complete = {}
    unless profiles_info.blank?
      # puts "@profiles_info = #{@profiles_info}"
      first_elements_qty = first_three_qty(profiles_info)
      profiles_info_three = profiles_info.first(first_elements_qty).to_h
      # @profiles_info_three = profiles_info_three # to view
      # puts "@profiles_info_three = #{@profiles_info_three}"
      profiles_info_complete = ProfileData.profiles_data_info(profiles_info_three)
    end
    new_profiles_females = new_weekly_profiles[:new_profiles_female] # 8
    new_profiles_males = new_weekly_profiles[:new_profiles_male] # 9
    # puts "user to send: email_name = #{one_email},  user_name = #{user_name} "
    # puts "vars: new_profiles_ids = #{new_profiles_ids}, new_profiles_qty = #{new_profiles_qty}"
    # puts "@new_profiles_three = #{@new_profiles_three}, new_profiles_females = #{new_profiles_females}, new_profiles_males = #{new_profiles_males} "
    # week_profiles_data =
    { new_profiles_qty:       new_profiles_qty,
      new_profiles_females:   new_profiles_females,
      new_profiles_males:     new_profiles_males,
      profiles_info_complete: profiles_info_complete }
  end



  # @note: service method
  #   determine qty of first elements to take from hash
  # todo: place this into Hash service class
  def self.first_three_qty(profiles_info)
    unless profiles_info.blank?
      first_elements_qty = 0
      info_size = profiles_info.size
      if info_size >= 3 # todo: put this "3" in constants (qty of firest elements to take from hahs to display)
        first_elements_qty = 3
      else
        first_elements_qty = info_size
      end
    end
    # first_elements_qty
  end




                                # @note: collect profiles_ids of users array
  #   use in weekly manifest email
  def collect_weekly_info
    week_ago_time = 1.week.ago
    puts "In 1 collect_weekly_info:  current_user_id = #{self.id}, week_ago_time = #{week_ago_time}"

    site_stat_info = WeafamStat.collect_site_stats
    puts "In 2 collect_weekly_info:  site_stat_info = #{site_stat_info}"
    puts "In 3 collect_weekly_info:  On site: profiles = #{site_stat_info[:profiles]}, users = #{site_stat_info[:users]}"

    tree_stat_info = TreeStats.collect_tree_stats(self.id)
    puts "In 4 collect_weekly_info:  tree_stat_info = #{tree_stat_info}"

    connected_users = tree_stat_info[:connected_users]
    connections_info = ConnectedUser.connections_weekly(connected_users)
    puts "In 5 collect_weekly_info:  connections_info = #{connections_info}"

    # new_weekly_profiles = {}
    new_weekly_profiles = Profile.new_weekly_profiles(connected_users)
    puts "In 6 collect_weekly_info:  new_weekly_profiles = #{new_weekly_profiles}"

    # new_weekly_profile_datas = {}
    new_weekly_profile_data = ProfileData.new_weekly_profile_datas(tree_stat_info[:tree_profiles])
    puts "In 7 collect_weekly_info:  new_weekly_profile_data = #{new_weekly_profile_data}"

    connection_requests_info = ConnectionRequest.connection_requests_exists(connected_users)
    puts "In 8 collect_weekly_info:  connection_requests_info = #{connection_requests_info}"
    # {:request_users_ids=>[57], :request_users_qty=>1, :request_users_profiles=>[790]}

    # new_conn_requests =
    { site_info: site_stat_info,
      tree_info: tree_stat_info,
      connections_info: connections_info,
      new_weekly_profiles: new_weekly_profiles,
      new_weekly_profile_data: new_weekly_profile_data,
      connection_requests_info: connection_requests_info
    }

  end









  private


  def downcase_email
    self.email = self.email.downcase
  end


  def self.create_with_email_and_password(email, password)
    self.create(email: email, password: password, password_confirmation: password)
  end

  def self.generate_password
    if Rails.env =~ /development/
      '1111'
    else
      Array.new(4).map { rand(0...9)}.join
    end
  end



end
