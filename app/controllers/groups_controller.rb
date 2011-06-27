class GroupsController < ApplicationController

  before_filter :authenticate, :except => [:index, :show]
  before_filter :priveleged_user, :only => [:edit, :update]

  def index
    @title = "All Groups"
    @groups = Group.paginate(:page => params[:page])
  end

  def new
    @title = "Create Group"
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @member = @group.users.include?(current_user)
    @title = @group.name
  end

  def join
    @member = true
    @group = Group.find(params[:id])
    if !@group.users.include?(current_user)
      @group.users << current_user
      flash[:success] = "Congrats! You joined #{@group.name}."
      redirect_to @group
    else
      flash[:error] = "Error joining #{@group.name}. Please try again."
      redirect_to @group
    end
  end

  def create
    @group = current_user.groups.create(params[:group])
    if current_user.groups.exists?(@group.id) #success
      flash[:success] = "Group Created."
      redirect_to @group
    else
      @title = "Create Group"
      render :new
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
