# encoding: utf-8
class WeafamMailer < ActionMailer::Base
  default from: "weallfamily@yandex.ru"  ####
  #default from: "blookho@gmail.com"

  def invitation_email(email_name, profile_id, current_user_id)

    if !profile_id.to_i.blank? && !current_user_id.to_i.blank?
      @profile_id = profile_id.to_i #
      @current_user_id = current_user_id.to_i #
      @email_name = email_name #
      logger.info "In invitation_email:  profile_id = #{profile_id.inspect}, email_name = #{email_name.inspect}"

      @profile_name = Name.find(Profile.find(profile_id).name_id).name
      @current_user_name = Name.find(Profile.find_by_user_id(current_user_id).name_id).name
      logger.info "In invitation_email:  @profile_name = #{@profile_name}, @current_user_name = #{@current_user_name} " #

      @mail_number = 37
      mail(to: email_name, subject: "#{@mail_number}-e Приглашение на сайт < Мы все - родня >", reply_to: 'weallfamily@yandex.ru')
      #mail(to: email_name, subject: "#{@mail_number}-e Приглашение на сайт < Мы все - родня >", reply_to: 'blookho@gmail.com')  ####
      logger.info "In invitation_email: after mail"
    else
      logger.info "In invitation_email: enter_email   if !profile_id.to_i.blank? && !current_user_id.to_i.blank?: #{!profile_id.to_i.blank? && !current_user_id.to_i.blank?}"
      flash[:alert] = "Не определены адресат и/или отправитель электронной почты. Почтовое сообщение не отправлено. "
    end

  end



  #def welcome_email(user)
  #  @user = user
  #  # I am overriding the 'to' default
  #  mail(to: @user.email, subject: 'Do you have any spam?')
  #end

end
