class Notifier < ActionMailer::Base
  default :from => "no-reply@jungolhq.com",
          :return_path => "mailer@jungolhq.com",
          :reply_to => "admin@jungolhq.com"

  def invite(user, email)
    @user = user
    mail(:to => email,
         :subject => "You're invited to join Jungol!")
  end
end
