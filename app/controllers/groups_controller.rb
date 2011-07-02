class GroupsController < ApplicationController

  before_filter :authenticate, :except => [:index, :show]
  before_filter :require_leader, :only => [:edit, :update, :link]

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
    @member = @group.member?(current_user)
    @leader = @group.leader?(current_user)
    @title = @group.name
  end

  #ADD MEMBER TO GROUP
  def join
    @member = true
    @group = Group.find(params[:id])
    if request.post?
      if !@group.users.include?(current_user)
        @group.users << current_user
        flash[:success] = "Congrats! You joined #{@group.name}."
        redirect_to @group
      else
        flash[:error] = "Error joining #{@group.name}. Please try again."
        redirect_to @group
      end
    else #it fell back to GET (no js)
      flash[:error] = "Please enable javascript to join."
      redirect_to @group
    end
  end

  #ADD GROUP TO GROUPS
  def link
    @title = "Connect to Group"
    @group1 = Group.find(params[:id])
    if request.get?
      @groups = Group.find(:all, :conditions => ['id not in (?) or (?)', @group1, @group1.groups])
      render :link
    elsif request.post?
      @group2 = Group.find(params[:group][:id])
      @group1.groups << @group2
      @group2.groups << @group1
      flash[:success] = "Congrats! #{@group1.name} is now connected with #{@group2.name}."
      redirect_to @group1
    else
      flash[:error] = "Error connecting with #{@group2.name}. Please try again."
      redirect_to @group1
    end
  end

  def create
    @group = current_user.created_groups.create(params[:group])
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

    def require_leader
      @group = Group.find(params[:id])
      flash[:error] = "You must be a leader of #{@group.name} to do that."
      redirect_to(group_path) unless @group.leader?(current_user)
    end

end
