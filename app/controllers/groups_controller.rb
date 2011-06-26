class GroupsController < ApplicationController

  before_filter :authenticate, :except => [:index, :show]
  before_filter :priveleged_user, :only => [:edit, :update]

  def index
    @title = "All Groups"
    @groups = Group.paginate(:page => params[:page])
  end

  def new
    if !signed_in?
      redirect_to root_path
    else
      @title = "Create Group"
      @group = Group.new
    end
  end

  def show
    @group = Group.find(params[:id])
    @title = @group.name
  end

  def create
    if !signed_in?
      redirect_to root_path
    else
      @group = current_user.groups.create(params[:group])
      if current_user.groups.exists?(@group.id) #success
        flash[:success] = "Group Created."
        redirect_to @group
      else
        @title = "Create Group"
        render :new
      end
    end
  end

  def edit
    @title = "Edit Group"
  end

  def update
    if(@group.update_attributes(params[:group]))
      flash[:success] = "Group updated."
      redirect_to @group
    else
      @title = "Edit Group"
      render :edit
    end
  end

  private
    def authenticate
      deny_access unless signed_in?
    end

    def priveleged_user
      @group = Group.find(params[:id])
      @user = User.find(@group.memberships.find_by_role(1).user_id)
      redirect_to(root_path) unless current_user?(@user)
    end

end
