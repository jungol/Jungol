module PermissionsHelper
  protected
    def require_member
      unless current_user.member_of? @group
        flash[:error] = "You must be a member of #{@group.name} to do that."
        redirect_to(group_path(@group))
      end
    end

    def require_admin
      unless current_user.admin_of? @group
        flash[:error] = "You must be an admin of #{@group.name} to do that."
        redirect_to(group_path(@group))
      end
    end

    def require_privileged
      unless current_user.privileged? @group
        flash[:error] = "You must be an admin of #{@group.name} to do that."
        redirect_to(group_path(@group))
      end
    end

end
