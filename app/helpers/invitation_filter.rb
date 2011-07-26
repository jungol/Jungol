class InvitationFilter
  def self.filter(controller)
    if controller.is_a? Devise::RegistrationsController
      params = controller.send(:params)
      if params[:action] == "new"
        controller.redirect_to(
          controller.new_user_session_path,
          :alert => "Jungol is currently invitation only.  Please sign in or check back soon."
        )
      end
    end
  end
end
