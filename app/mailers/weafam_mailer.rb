# encoding: utf-8
class WeafamMailer < ActionMailer::Base
  default from: "weallfamily@yandex.ru"  ####
  #default from: "blookho@gmail.com"

  def invitation_email(email_name, profile_id, current_user_id)

    if !profile_id.to_i.blank? && !current_user_id.to_i.blank?
      @email_name = email_name #
      #logger.info "In invitation_email:  profile_id = #{profile_id.inspect}, email_name = #{email_name.inspect}"

      @profile_name, @profile_sex = get_name_data(profile_id)
      current_user = User.find(current_user_id)
      current_profile_id = current_user.profile_id
      @current_user_name, @current_user_sex = get_name_data(current_profile_id)
      @current_user_email = current_user.email


      logger.info "In invitation_email:  @profile_name = #{@profile_name}, @current_user_name = #{@current_user_name} " #

      #@mail_number = 48 # #{@mail_number}-e
      mail(to: email_name, subject: "Приглашение на сайт < Мы все - родня >", reply_to: 'weallfamily@yandex.ru')
      logger.info "In invitation_email: after mail"
      #<div style="width:100%; border-top:1px solid #eee;margin-top: 15px;font-size:12px; float:left;">

    else
      logger.info "In invitation_email: enter_email   if !profile_id.to_i.blank? && !current_user_id.to_i.blank?: #{!profile_id.to_i.blank? && !current_user_id.to_i.blank?}"
      flash[:alert] = "Не определены адресат и/или отправитель электронной почты. Почтовое сообщение не отправлено. "
    end

  end

  # Получаем параметры имени профиля: имя=строка + пол профиля(0-1)
  def get_name_data(profile_id)
    name = Name.find(Profile.find(profile_id).name_id)
    return name.name, name.sex_id
  end

  #def welcome_email(user)
  #  @user = user
  #  # I am overriding the 'to' default
  #  mail(to: @user.email, subject: 'Do you have any spam?')
  #end

end
