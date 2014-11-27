# encoding: utf-8
class WeafamMailer < ActionMailer::Base
  default from: "blookho@gmail.com"

  def invitation_email(email_name)

    mail(to: email_name, subject: '9 Приглашение на сайт "Мы все - родня"', reply_to: 'blookho@gmail.com')
    logger.info "In Метод: invitation_email: email_name = #{email_name.inspect}"

  end

  #def welcome_email(user)
  #  @user = user
  #  # I am overriding the 'to' default
  #  mail(to: @user.email, subject: 'Do you have any spam?')
  #end

end
