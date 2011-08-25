class RegistrationsController < Devise::RegistrationsController
  def edit
    @title = "Edit your account"
    @blurb = "Update your account information or add to your profile"
    super
  end
end
