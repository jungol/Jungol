module PermissionsHelper
  protected
    def require_member
      unless @group.member?(current_user)
        flash[:error] = "You must be a member of #{@group.name} to do that."
        redirect_to(group_path(@group))
      end
    end

    def require_admin
      unless @group.admin?(current_user)
        flash[:error] = "You must be an admin of #{@group.name} to do that."
        redirect_to(group_path(@group))
      end
    end


end
