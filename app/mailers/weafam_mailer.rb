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
    # users_data =
    #     {:users_names=> ["Алексей"],
    #      :users_emails=>["zoneiva@gmail.com"] }

    # mailcatcher sending
    users_data =
        {:users_names=> ["Андрей"],
         :users_emails=>["andrey-7-tree@an.an"] }


    logger.info "In proceed_weekly_mail: users_data = #{users_data} "
    count_emails = 0
    users_data[:users_emails].each_with_index do |one_email, index|
      user_to_send = User.where( email: one_email)
      logger.info "In proceed_weekly_mail: user_to_send = #{user_to_send},  "
      unless user_to_send.blank?

        user_to_send_id = user_to_send[0].id
        user_to_send_name = users_data[:users_names][index]
        puts "user to send: email = #{one_email}, id = #{user_to_send_id}, name = #{user_to_send_name} "


        user_weekly_info = User.find(user_to_send_id).collect_weekly_info

        # In collect_weekly_info:
        # after collect_weekly_info: user_weekly_info =
                  {:site_info=>
                       {:profiles=>27, :profiles_male=>13, :profiles_female=>14, :users=>8, :users_male=>1,
                        :users_female=>2, :trees=>6, :invitations=>2689, :requests=>4, :connections=>2,
                        :refuse_requests=>0, :disconnections=>67, :similars_found=>0},
                   :tree_info=>
                       {:tree_profiles=>[17, 15, 9, 20, 16, 10, 3, 12, 13, 14, 21, 124, 18, 11, 8, 19, 2, 7],
                        :connected_users=>[1, 2], :qty_of_tree_profiles=>18, :qty_of_tree_users=>2},
                   :connections_info=>{:new_users_connected=>[2], :conn_count=>1, :new_users_profiles=>[11]},
                   :new_weekly_profiles => {:new_profiles_qty=>17, :new_profiles_male=>9, :new_profiles_female=>8,
                                            :new_profiles_ids=>[2, 3, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]}
        }

        @email_name = one_email
        @user_name = user_to_send_name
        @new_profiles_ids = user_weekly_info[:new_weekly_profiles][:new_profiles_ids] # [2, 3, 7, 8, 9, 10, 11, 12, 13, ...]
        @new_profiles_qty = @new_profiles_ids.size # 17
        @new_profiles_three = @new_profiles_ids.take(3) # [2, 3, 7

        @profiles_info = Profile.collect_profiles_info(@new_profiles_ids)
        unless @profiles_info.blank?
          puts "@profiles_info = #{@profiles_info}"
          # @profiles_info =
              {   64=> {:user_id=>nil, :name_id=>90, :sex_id=>1, :tree_id=>7},
                  65=>{:user_id=>nil, :name_id=>345, :sex_id=>0, :tree_id=>7},
                  63=>{:user_id=>7, :name_id=>40, :sex_id=>1, :tree_id=>7},
              67=>{:user_id=>nil, :name_id=>173, :sex_id=>0, :tree_id=>7},
              68=>{:user_id=>nil, :name_id=>343, :sex_id=>1, :tree_id=>7},
              66=>{:user_id=>8, :name_id=>370, :sex_id=>1, :tree_id=>7}}

          first_elements_qty = first_three_qty(@profiles_info)

          @profiles_info_three = @profiles_info.first(first_elements_qty).to_h
          puts "@profiles_info_three = #{@profiles_info_three}"
        end

        @new_profiles_females = user_weekly_info[:new_weekly_profiles][:new_profiles_female] # 8
        @new_profiles_males = user_weekly_info[:new_weekly_profiles][:new_profiles_male] # 9
        puts "user to send: @email_name = #{one_email}, user_to_send_id = #{user_to_send_id}, @user_name = #{user_to_send_name} "
        puts "vars: @new_profiles_ids = #{@new_profiles_ids}, @new_profiles_qty = #{@new_profiles_qty}"
        puts "@new_profiles_three = #{@new_profiles_three}, @new_profiles_females = #{@new_profiles_females}, @new_profiles_males = #{@new_profiles_males} "

        # @confirmation_url = confirmation_url(user)


        mail to: one_email, subject: 'Новости вашей родни'
        count_emails += 1
      end
      # template_weekly_info(user_to_send_id)

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
  #   determine qty of first elements to take from array or hash
  #
  def first_three_qty(profiles_info)
    unless profiles_info.blank?
      first_elements_qty = 0
      info_size = profiles_info.size
      if info_size >= 3 # todo: put this "3" in constants (qty of firest elements to take from array or hahs to display)
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
