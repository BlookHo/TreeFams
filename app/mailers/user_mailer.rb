class UserMailer < ActionMailer::Base
  default from: "weallfamily@yandex.ru"

  def welcome_mail(user, password = '1111')
    @name = user.name
    @email = user.email
    @password = password
    mail(to: @email, subject: 'Мы все - родня. Регистрация: данные для входа в ваш аккаунт.')
  end

end
