class Notifier < ActionMailer::Base
  default :from => "Jungol Team <no-reply@jungolhq.com>",
          :return_path => "mailer@jungolhq.com",
          :reply_to => "no-reply@jungolhq.com"

  def pending_user(admin, group, user)
    @user = user
    @admin = admin
    @group = group
    mail(:to => admin.email,
         :subject => "#{user.name} has requested to join #{group.name}")
  end


  def approved_user(group, user)
    @user = user
    @group = group
    mail(:to => @user.email, :subject => "You are now a member of #{@group.name}. Welcome!")
  end

  def pending_group(admin, group, group_b)
    @admin = admin
    @group = group
    @group_b = group_b
    mail(:to => admin.email,
         :subject => "Another group wants to connect with #{group.name}")
  end

  def approved_group(admin, my_group, new_group)
    @admin = admin
    @my_group = my_group
    @new_group = new_group
    mail(:to => admin.email, :subject => "You are now connected with #{new_group.name}")
  end

  def email_signup(req)
    @email = req.email
    @ip = req.ip
    @time = req.created_at
    mail(:to => 'admin@jungolhq.com', :subject => "Someone requested updates!")
  end

end
