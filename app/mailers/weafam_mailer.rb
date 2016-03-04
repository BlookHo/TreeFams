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
  def weekly_manifest_email(email_name, profile_id, current_user_id)

    collect_weekly_info(email_name, profile_id, current_user_id)

    proceed_weekly_mail

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
  # 1. все имена юзеров, все почты.
  # 2. новости от всей родни из дерева:
  #   -  дни рождения на след. неделе
  #   -  фото у кого д.р.
  # 3. непрочитанные сообщения от:
  #   - от кого: (имя, фамилия если есть)
  #     - начало сообщения - 20 символов
  # 4. есть запросы юзеру на объединение от:
  #   - от кого: (имя, фамилия если есть)
  #     -  (в его дереве 45 чел.)
  # 5. Информация - статистика из дерева:
  #   - Сейчас в вашем дереве - 120 чел.,
  #       из них - 5 активных пользователей проекта. (?)
  #   - За прошедший период добавилась информация о 10 чел.(),
  #       из них 2 пользователей.
  #   -  Новые активные участники:
  #       <ВСТАВИТЬ ФОТО>  (если есть)
  #         Сергей Митин (Минск)
  #       <ВСТАВИТЬ ФОТО>  (если есть)
  #         Людмила (Минск)
  #   - Произошло 1 объединений деревьев,
  #       при этом добавилось в ваше дерево информацию о 5 чел.
  #   - Ваша родня написала новых сообщений друг другу: 18
  #   - Добавилось новых фотографий: 14
  # 6. Информация - статистика сайта:
  #   - Всего на сайте информация о 190 чел.,
  #       из них - 20 (?) активных пользователей.
  def collect_weekly_info(email_name, profile_id, current_user_id)
    puts "In collect_weekly_info:  current_user_id = #{current_user_id}"
    # ", @current_user_name = #{@current_user_name} " #



  end

  # @note: sending weekly mail data
  def proceed_weekly_mail  #(email_name, profile_id, current_user_id)
    logger.info "In proceed_weekly_mail:  "
    # "@profile_name = #{@profile_name}, @current_user_name = #{@current_user_name} " #

  end


end
