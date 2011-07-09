module PermissionsHelper
  protected

    def authenticate
      deny_access unless signed_in?
    end

    def require_member
      unless @group.member?(current_user)
        flash[:error] = "You must be a member of #{@group.name} to do that."
        redirect_to(group_path(@group))
      end
    end

    def require_leader
      unless @group.leader?(current_user)
        flash[:error] = "You must be a leader of #{@group.name} to do that."
        redirect_to(group_path(@group))
      end
    end


end
