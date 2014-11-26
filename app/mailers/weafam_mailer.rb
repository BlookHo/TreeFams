class WeafamMailer < ActionMailer::Base
  default from: "blookho@gmail.com"

  def invitation_email(email_name)
    #@user = user
    # I am overriding the 'to' default
    mail(to: email_name, subject: 'Добро пожаловать на!  Приглашение на сайт "Мы все - родня" (www.Weallfamily.ru)',
         reply_to: 'blookho@gmail.com')
    #do |format|
    #  format.html { render 'cool_html_template'}
    #  format.text { render text: 'Get a real mail client!'}
    #end


  end

  def welcome_email(user)
    @user = user
    # I am overriding the 'to' default
    mail(to: @user.email, subject: 'Do you have any spam?')
  end

end
