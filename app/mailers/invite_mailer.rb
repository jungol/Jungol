class InviteMailer < Devise::Mailer

  def member_invitation_instructions(record)
    devise_mail(record, :member_invitation_instructions)
  end

end
