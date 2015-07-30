class UserMailer < ActionMailer::Base
  default from: "\"Мы все – родня!\" <notification@weallfamily.ru>"

  def welcome_mail(user, password = '1111')
    @name = user.name
    @email = user.email
    @password = password
    mail(to: @email, subject: 'Регистрация: данные для входа в ваш аккаунт.')
  end


  def reset_password(user,  password)
    @name = user.name
    @email = user.email
    @password = password
    mail(to: @email, subject: 'Восстановление пароля.')
  end

end
