# encoding: utf-8
class WeafamMailer < ActionMailer::Base
  #############################################################
  # Иванищев А.В. 2015 - December; 2016 - March
  # Методы подготовки информации и отправки почтовых сообщений
  #############################################################

  default from: "\"Мы все – родня!\" <notification@weallfamily.ru>"
  # default from: "blookho@gmail.com"

  # @note: Prepare invit-n mail data
  def invitation_email(email_name, profile_id, current_user_id)
    if !profile_id.to_i.blank? && !current_user_id.to_i.blank?
      @email_name = email_name
      @profile_name, @profile_sex = get_name_data(profile_id)
      current_user = User.find(current_user_id)
      current_profile_id = current_user.profile_id
      @current_user_name, @current_user_sex = get_name_data(current_profile_id)
      @current_user_email = current_user.email

      logger.info "In invitation_email:  @profile_name = #{@profile_name}, @current_user_name = #{@current_user_name} " #

      mail(to: email_name, subject: "Приглашение на сайт < Мы все - родня >", reply_to: 'notification@weallfamily.ru')
      Counter.increment_invites

    else
      flash[:alert] = "Не определены адресат и/или отправитель электронной почты. Почтовое сообщение не отправлено. "
    end

  end


  # @note: Получаем параметры имени профиля: имя=строка + пол профиля(0-1)
  def get_name_data(profile_id)
    name = Name.find(Profile.find(profile_id).name_id)
    return name.name, name.sex_id
  end

  # @note: prepare and send weekly_manifest mail
  #   sending weekly mail data for every user
  def weekly_manifest_email

    # users_data = User.users_mail_info
    # puts "In weekly_manifest_email: users_data = #{users_data}"
    # users_data =
    #     {:users_names=>
    #          ["Алексей", "Анна", "Наталья", "Таисия", "Вера", "Петр", "Дарья", "Федор"],
    #      :users_emails=>["alexey@al.al", "aneta@an.an", "vera@na.na", "darja@pe.pe",
    #                      "natalia@pe.pe", "petr@pe.pe", "taisia@pe.pe", "fedor@pe.pe"]}

    # # real sending
    users_data =
        # {:users_names=> ["Алексей"],
        #  :users_emails=>["zoneiva@gmail.com"] }

    # mailcatcher sending
    # users_data =
    #     {:users_names=> ["Андрей"],
    #      :users_emails=>["andrey-7-tree@an.an"] }
    {:users_names=> ["Андрей"],
    :users_emails=>["azoneiva@gmail.coma"] }


    logger.info "In proceed_weekly_mail: users_data = #{users_data} "
    count_emails = 0
    users_data[:users_emails].each_with_index do |one_email, index|
      user_to_send = User.where( email: one_email)
      logger.info "In proceed_weekly_mail: user_to_send = #{user_to_send},  "
      unless user_to_send.blank?

        user_to_send_id = user_to_send[0].id
        user_to_send_name = users_data[:users_names][index]
        puts "user to send: email = #{one_email}, id = #{user_to_send_id}, name = #{user_to_send_name} "

        @email_name = one_email
        @user_name = user_to_send_name


        user_weekly_info = User.find(user_to_send_id).collect_weekly_info
        puts "To send user_weekly_info = #{user_weekly_info}"

        # In collect_weekly_info:
        # after collect_weekly_info:
        # To send user_weekly_info = PGlocal
        # user_weekly_info =
          {:site_info=>
               {:profiles=>405, :profiles_male=>219, :profiles_female=>186, :users=>29,
                :users_male=>23, :users_female=>6, :trees=>24, :invitations=>3, :requests=>55,
                :connections=>47, :refuse_requests=>0, :disconnections=>34, :similars_found=>5},
           :tree_info=>
               {:tree_profiles=>[63, 69, 79, 967, 70, 64, 66, 84, 65, 80, 67, 68, 968, 969, 971],
                :connected_users=>[7, 8], :qty_of_tree_profiles=>15, :qty_of_tree_users=>2},
           :connections_info=>
               {:new_users_connected=>[8], :conn_count=>1, :new_users_profiles=>[66]}, # [8]
           :new_weekly_profiles=>
               {:new_profiles_qty=>6, :new_profiles_male=>4, :new_profiles_female=>2,
                :new_profiles_ids=>[64, 65, 63, 67, 68, 66]},  # [64, 65, 63, 67, 68, 66]
           :connection_requests_info=>
               {:request_users_ids=>[57], :request_users_qty=>1, :request_users_profiles=>[790]}}   # [57]

        @tree_profiles_qty = user_weekly_info[:tree_info][:qty_of_tree_profiles]
        @tree_users_qty = user_weekly_info[:tree_info][:qty_of_tree_users]

        # user_weekly_info = RSpec
        #           {:site_info=>
        #                {:profiles=>27, :profiles_male=>13, :profiles_female=>14, :users=>8, :users_male=>1,
        #                 :users_female=>2, :trees=>6, :invitations=>2689, :requests=>4, :connections=>2,
        #                 :refuse_requests=>0, :disconnections=>67, :similars_found=>0},
        #            :tree_info=>
        #                {:tree_profiles=>[17, 15, 9, 20, 16, 10, 3, 12, 13, 14, 21, 124, 18, 11, 8, 19, 2, 7],
        #                 :connected_users=>[1, 2], :qty_of_tree_profiles=>18, :qty_of_tree_users=>2},
        #            :connections_info=>{:new_users_connected=>[2], :conn_count=>1, :new_users_profiles=>[11]},
        #            :new_weekly_profiles => {:new_profiles_qty=>17, :new_profiles_male=>9, :new_profiles_female=>8,
        #                                     :new_profiles_ids=>[2, 3, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]}
        # }


        # relatives_events
        if user_weekly_info[:connection_requests_info][:request_users_ids].blank?
          @new_relatives_events_exists = false
        else
          @new_relatives_events_exists = true


        end




        # connection_requests
        if user_weekly_info[:connection_requests_info][:request_users_ids].blank?
          @new_conn_requests_exists = false
        else
          @new_conn_requests_exists = true
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
              {:site_info=>
                   {:profiles=>405, :profiles_male=>219, :profiles_female=>186, :users=>29,
                    :users_male=>23, :users_female=>6, :trees=>24, :invitations=>3, :requests=>55,
                    :connections=>47, :refuse_requests=>0, :disconnections=>34, :similars_found=>5},
               :tree_info=>
                   {:tree_profiles=>[790, 792, 794, 814, 799, 796, 797, 791, 808, 898, 798, 815, 807,
                                     795, 793, 913, 902, 806, 897, 813, 812],
                    :connected_users=>[57, 58, 60], :qty_of_tree_profiles=>21, :qty_of_tree_users=>3},
               :connections_info=>
                   {:new_users_connected=>[58, 58, 58, 58, 58, 58, 60, 60, 60, 60, 60, 60, 60, 60],
                    :conn_count=>14,
                    :new_users_profiles=>[795, 795, 795, 795, 795, 795, 794, 794, 794, 794, 794, 794, 794, 794]},
               :new_weekly_profiles=>
                   {:new_profiles_qty=>0, :new_profiles_male=>0, :new_profiles_female=>0, :new_profiles_ids=>[]},
               :connection_requests_info=>{:request_users_ids=>[], :request_users_qty=>0, :request_users_profiles=>[]}}
          @conn_req_tree_profiles_qty = connect_request_user_info[:tree_info][:qty_of_tree_profiles]
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

            @conn_req_profiles_complete = ProfileData.profiles_data_info(conn_req_profiles_info_three)
          end

        end


        # connections
        if user_weekly_info[:connections_info][:new_users_connected].blank?
          @new_connections_exists = false
        else
          @new_connections_exists = true
          new_connect_profiles_id = user_weekly_info[:connections_info][:new_users_profiles].first#
          @new_connect_profiles_id = [new_connect_profiles_id]
          new_user_connected_id = user_weekly_info[:connections_info][:new_users_connected].first #
          @new_user_connected_id = [new_user_connected_id]

          connect_user_weekly_info = User.find(new_user_connected_id).collect_weekly_info
          # @connect_user_weekly_info = connect_user_weekly_info # to view
          puts "@connect_user_weekly_info = #{connect_user_weekly_info}"
          # @connect_user_weekly_info =
              {:site_info=>
                   {:profiles=>405, :profiles_male=>219, :profiles_female=>186,
                    :users=>29, :users_male=>23, :users_female=>6, :trees=>24,
                    :invitations=>3, :requests=>54, :connections=>47, :refuse_requests=>0,
                    :disconnections=>34, :similars_found=>5},
               :tree_info=>{:tree_profiles=>[66, 69, 79, 967, 70, 64, 68, 84, 65, 80, 968, 67, 969, 971, 63],
                            :connected_users=>[7, 8], :qty_of_tree_profiles=>15, :qty_of_tree_users=>2},
               :connections_info=>{:new_users_connected=>[8], :conn_count=>1, :new_users_profiles=>[66]},
               :new_weekly_profiles=>{:new_profiles_qty=>6, :new_profiles_male=>4, :new_profiles_female=>2,
                                      :new_profiles_ids=>[64, 65, 63, 67, 68, 66]}}

          @connect_tree_profiles_qty = connect_user_weekly_info[:tree_info][:qty_of_tree_profiles]
          @connect_tree_users_qty = connect_user_weekly_info[:tree_info][:qty_of_tree_users]

          connect_profiles_info = Profile.collect_profiles_info(@new_connect_profiles_id)
          @connect_profiles_info = connect_profiles_info # to view
          unless connect_profiles_info.blank?
            puts "@connect_profiles_info = #{@connect_profiles_info}"

            first_elements_qty = first_three_qty(connect_profiles_info)
            connect_profiles_info_three = connect_profiles_info.first(first_elements_qty).to_h
            @connect_profiles_info_three = connect_profiles_info_three # to view
            puts "@connect_profiles_info_three = #{@connect_profiles_info_three}"

            @connect_profiles_info_complete = ProfileData.profiles_data_info(connect_profiles_info_three)
          end
        end


        # new profiles
        if user_weekly_info[:new_weekly_profiles][:new_profiles_ids].blank?
          @new_profiles_exists = false
        else
          @new_profiles_exists = true
          @new_profiles_ids = user_weekly_info[:new_weekly_profiles][:new_profiles_ids] # [2, 3, 7, 8, 9, 10, 11, 12, 13, ...]
          @new_profiles_qty = @new_profiles_ids.size # 17
          @new_profiles_three = @new_profiles_ids.take(3) # [2, 3, 7

          profiles_info = Profile.collect_profiles_info(@new_profiles_ids)
          # @profiles_info =
          {   64=> {:user_id=>nil, :name_id=>90, :sex_id=>1, :tree_id=>7},
              65=>{:user_id=>nil, :name_id=>345, :sex_id=>0, :tree_id=>7},
              63=>{:user_id=>7, :name_id=>40, :sex_id=>1, :tree_id=>7},
              67=>{:user_id=>nil, :name_id=>173, :sex_id=>0, :tree_id=>7},
              68=>{:user_id=>nil, :name_id=>343, :sex_id=>1, :tree_id=>7},
              66=>{:user_id=>8, :name_id=>370, :sex_id=>1, :tree_id=>7}}

          @profiles_info = profiles_info # to view
          unless profiles_info.blank?
            puts "@profiles_info = #{@profiles_info}"

            first_elements_qty = first_three_qty(profiles_info)
            profiles_info_three = profiles_info.first(first_elements_qty).to_h
            @profiles_info_three = profiles_info_three # to view
            puts "@profiles_info_three = #{@profiles_info_three}"

            @profiles_info_complete = ProfileData.profiles_data_info(profiles_info_three)

          end

          @new_profiles_females = user_weekly_info[:new_weekly_profiles][:new_profiles_female] # 8
          @new_profiles_males = user_weekly_info[:new_weekly_profiles][:new_profiles_male] # 9
          puts "user to send: @email_name = #{one_email}, user_to_send_id = #{user_to_send_id}, @user_name = #{user_to_send_name} "
          puts "vars: @new_profiles_ids = #{@new_profiles_ids}, @new_profiles_qty = #{@new_profiles_qty}"
          puts "@new_profiles_three = #{@new_profiles_three}, @new_profiles_females = #{@new_profiles_females}, @new_profiles_males = #{@new_profiles_males} "
        end

        # @confirmation_url = confirmation_url(user)

        events = {
            new_conn_requests_exists: @new_conn_requests_exists,
            new_connections_exists: @new_connections_exists,
            new_profiles_exists: @new_profiles_exists
        }
        puts "events = #{events}"
        if Service.check_all_events_exists?(events) # Send OR not Send for this user?
          mail to: one_email, subject: 'Новости вашей родни'
          count_emails += 1
        end
      end

    end
    puts "In proceed_weekly_mail: count_week_emails = #{count_emails}"
    count_emails

    # if !profile_id.to_i.blank? && !current_user_id.to_i.blank?
    #   @email_name = email_name
    #   @profile_name, @profile_sex = get_name_data(profile_id)
    #   current_user = User.find(current_user_id)
    #   current_profile_id = current_user.profile_id
    #   @current_user_name, @current_user_sex = get_name_data(current_profile_id)
    #   @current_user_email = current_user.email
    #
    #   logger.info "In invitation_email:  @profile_name = #{@profile_name}, @current_user_name = #{@current_user_name} " #
    #
    #   mail(to: email_name, subject: "Приглашение на сайт < Мы все - родня >", reply_to: 'notification@weallfamily.ru')
    #   # Counter.increment_invites
    #
    # else
    #   flash[:alert] = "Не определены адресат и/или отправитель электронной почты. Почтовое сообщение не отправлено. "
    # end

  end

  # @note: service method
  #   determine: whether all event necessary to send weekly email - all exists
  # @input: events = { new_conn_requests_exists: @new_conn_requests_exists,
  #     new_connections_exists: @new_connections_exists,
  #     new_profiles_exists: @new_profiles_exists }
  # todo: place this into service class
  def check_all_events_exists?(events)
    events.each do |name, truefalse|
      return false unless truefalse
    end
    true
  end



  # @note: service method
  #   determine qty of first elements to take from hash
  # todo: place this into Hash service class
  def first_three_qty(profiles_info)
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


  # @note: prepare weekly mail data
  # #################  1. все имена юзеров, все почты.
  # 2. новости от всей родни из дерева:
  #   -  дни рождения на след. неделе       NEWINFO of PROFILES  DATA -  todo: def birthdays_weekly  DATA
  #   -  фото у кого д.р.     of PROFILES    DATA                         todo:     with photos   DATA
  # 3. непрочитанные сообщения от:
  #   - от кого: (имя, фамилия если есть)      NEWINFO of USERS
  #     - начало сообщения - 20 символов
  # 4. есть запросы юзеру на объединение от:    todo:   def conn_requests_weekly  +     with names, surnames   DATA
  #   - от кого: (имя, фамилия если есть)       NEWINFO of USERS
  #     -  (в его дереве 45 чел.)
  # 5. Информация - статистика из дерева:
  # #################   - Сейчас в вашем дереве - 120 чел.,  of PROFILES
  # #################       из них - 5 #"#{активных}" пользователей проекта. (?)   of USERS
  #   - За прошедший период добавилась информация о 10 чел.(),       NEWINFO  of PROFILES
  #       из них 2 пользователей.       NEWINFO   of USERS  todo:   def new_profiles_weekly      with names, surnames  DATA
  #   -  Новые активные участники:                       todo:     def new_users_weekly      with names, surnames, photos  DATA
  #       <ВСТАВИТЬ ФОТО>  (если есть)   of USERS  DATA
  #         Сергей Митин (Минск)
  #       <ВСТАВИТЬ ФОТО>  (если есть)   of USERS  DATA
  #         Людмила (Минск)
  #  ################# - Произошло 1 объединений деревьев,        NEWINFO   of USERS  todo:  def connections_weekly
  #     ????  при этом добавилось в ваше дерево информацию о 5 чел.        NEWINFO  of PROFILES todo:  def connections_weekly
  #   - Ваша родня написала новых сообщений друг другу: 18        NEWINFO   of USERS  todo:    def new_messages_weekly
  #   - Добавилось новых фотографий: 14        NEWINFO   of PROFILES DATA   todo:     def new_photos_weekly  DATA
  # #################6. Информация - статистика сайта:
  # #################  - Всего на сайте информация о 190 чел.,  of PROFILES
  # #################      из них - 20 (?) активных пользователей.   of USERS

  # # @note:
  # def proceed_weekly_mail(users_data)  #(email_name, profile_id, current_user_id)
  #   logger.info "In proceed_weekly_mail: users_data = #{users_data} "
  #   count_emails = 0
  #   users_data[:users_emails].each_with_index do |one_email, index|
  #     user_to_send = User.where( email: one_email)
  #     unless user_to_send.blank?
  #
  #       user_to_send_id = user_to_send[0].id
  #       user_to_send_name = users_data[:users_names][index]
  #       puts "user to send: email = #{one_email}, id = #{user_to_send_id}, name = #{user_to_send_name} "
  #
  #       user_weekly_info = user_to_send.collect_weekly_info
  #       @email_name = one_email
  #       @user_name = user_to_send_name
  #       # @confirmation_url = confirmation_url(user)
  #       mail to: one_email, subject: 'One user weekly manifest email'
  #       count_emails += 1
  #
  #     end
  #     # template_weekly_info(user_to_send_id)
  #
  #
  #   end
  #   puts "In proceed_weekly_mail: count_week_emails = #{count_emails}"
  #   count_emails
  # end


end
