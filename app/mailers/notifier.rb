class Notifier < ActionMailer::Base
  default :from => "no-reply@jungolhq.com",
          :return_path => "mailer@jungolhq.com",
          :reply_to => "admin@jungolhq.com"

  def pending_user(admin, group, user)
    @user = user
    @admin = admin
    @group = group
    mail(:to => admin.email,
         :subject => "Someone has requested to join #{group.name}")
  end

  def pending_group(admin, group, group_b)
    @admin = admin
    @group = group
    @group_b = group_b
    mail(:to => admin.email,
         :subject => "Another group wants to connect with #{group.name}")
  end
end
