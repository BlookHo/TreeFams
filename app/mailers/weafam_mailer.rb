# encoding: utf-8
class WeafamMailer < ActionMailer::Base
  #############################################################
  # Иванищев А.В. 2015 - December; 2016 - March
  # Методы подготовки информации и отправки почтовых сообщений
  #############################################################

  default from: "\"Мы все – родня!\" <notification@weallfamily.ru>"

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
  def weekly_manifest_email

    users_data = User.users_mail_info
    puts "In weekly_manifest_email: users_data = #{users_data}"

    proceed_weekly_mail(users_data)

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



  # @note: prepare weekly mail data
  # #################  1. все имена юзеров, все почты.
  # 2. новости от всей родни из дерева:
  #   -  дни рождения на след. неделе       NEWINFO of PROFILES
  #   -  фото у кого д.р.     of PROFILES
  # 3. непрочитанные сообщения от:
  #   - от кого: (имя, фамилия если есть)      NEWINFO of USERS
  #     - начало сообщения - 20 символов
  # 4. есть запросы юзеру на объединение от:
  #   - от кого: (имя, фамилия если есть)       NEWINFO of USERS
  #     -  (в его дереве 45 чел.)
  # 5. Информация - статистика из дерева:
  # #################   - Сейчас в вашем дереве - 120 чел.,  of PROFILES
  # #################       из них - 5 #"#{активных}" пользователей проекта. (?)   of USERS
  #   - За прошедший период добавилась информация о 10 чел.(),       NEWINFO  of PROFILES
  #       из них 2 пользователей.       NEWINFO   of USERS
  #   -  Новые активные участники:
  #       <ВСТАВИТЬ ФОТО>  (если есть)   of USERS
  #         Сергей Митин (Минск)
  #       <ВСТАВИТЬ ФОТО>  (если есть)   of USERS
  #         Людмила (Минск)
  #   - Произошло 1 объединений деревьев,        NEWINFO   of USERS
  #       при этом добавилось в ваше дерево информацию о 5 чел.        NEWINFO  of PROFILES
  #   - Ваша родня написала новых сообщений друг другу: 18        NEWINFO   of USERS
  #   - Добавилось новых фотографий: 14        NEWINFO   of PROFILES
  # #################6. Информация - статистика сайта:
  # #################  - Всего на сайте информация о 190 чел.,  of PROFILES
  # #################      из них - 20 (?) активных пользователей.   of USERS
  def collect_weekly_info(current_user_id)
    puts "In collect_weekly_info:  current_user_id = #{current_user_id}"


    site_stat_info = WeafamStat.collect_site_stats
    puts "In collect_weekly_info:  site_stat_info = #{site_stat_info}"
    puts "In collect_weekly_info:  On site: profiles = #{site_stat_info[:profiles]}, users = #{site_stat_info[:users]}"

    tree_stat_info = TreeStats.collect_tree_stats(current_user_id)
    puts "In collect_weekly_info:  tree_stat_info = #{tree_stat_info}"

    # tree_stats[:tree_profiles]        = tree_data[:tree_profiles]
    # tree_stats[:connected_users]      = tree_data[:connected_author_arr]
    # tree_stats[:qty_of_tree_profiles] = tree_data[:qty_of_tree_profiles]
    # tree_stats[:qty_of_tree_users]    = users_qty


  end

  # @note: sending weekly mail data for every user
  def proceed_weekly_mail(users_data)  #(email_name, profile_id, current_user_id)
    logger.info "In proceed_weekly_mail: users_data = #{users_data} "
    count_emails = 0
    users_data[:users_emails].each_with_index do |one_email, index|
      user_to_send_id = User.where( email: one_email)[0].id
      user_to_send_name = users_data[:users_names][index]
      puts "user to send: email = #{one_email}, id = #{user_to_send_id}, name = #{user_to_send_name} "

      # collect_weekly_info(user_to_send_id)
      # template_weekly_info(user_to_send_id)

      @email_name = one_email
      @user_name = user_to_send_name
      # @confirmation_url = confirmation_url(user)
      mail to: one_email, subject: 'One user weekly manifest email'
      count_emails += 1

    end
    puts "In proceed_weekly_mail: count_week_emails = #{count_emails}"
    count_emails
  end


end
