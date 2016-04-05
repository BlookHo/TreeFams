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
  def weekly_manifest_email(weekly_email_data)

    @user_sex = weekly_email_data[:user_sex]
    @user_name = weekly_email_data[:user_name]
    @tree_profiles_qty = weekly_email_data[:tree_profiles_qty]
    @new_connections_exists = weekly_email_data[:new_connections_exists]
    @connect_profiles_info_complete = weekly_email_data[:connect_profiles_info_complete]
    @connect_tree_profiles_qty = weekly_email_data[:connect_tree_profiles_qty]
    @connect_tree_users_qty = weekly_email_data[:connect_tree_users_qty]
    @new_profiles_exists = weekly_email_data[:new_profiles_exists]
    @new_profiles_qty = weekly_email_data[:new_profiles_qty]
    @new_profiles_females = weekly_email_data[:new_profiles_females]
    @new_profiles_males = weekly_email_data[:new_profiles_males]
    @profiles_info_complete = weekly_email_data[:profiles_info_complete]
    @new_conn_requests_exists = weekly_email_data[:new_conn_requests_exists]
    @conn_req_profiles_complete = weekly_email_data[:conn_req_profiles_complete]
    @conn_req_tree_profiles_qty = weekly_email_data[:conn_req_tree_profiles_qty]
    @email_name = weekly_email_data[:email_name]

    mail to: @email_name, subject: 'Новости вашей родни'

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
