class GroupsController < ApplicationController
  before_filter :find_group, :except => [:index, :new, :create]
  before_filter :authenticate_user!, :except => [:index, :show]
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
    @member = @group.member?(current_user)
    @leader = @group.leader?(current_user)
    @title = @group.name
  end

  #ADD MEMBER TO GROUP
  def join
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
    if request.get?
      @groups = @group.unconnected_groups
      render :link
    elsif request.post?
      @group2 = Group.find(params[:group][:id])
      @group.groups << @group2
      @group2.groups << @group
      flash[:success] = "Congrats! #{@group.name} is now connected with #{@group2.name}."
      redirect_to @group
    else
      flash[:error] = "Error connecting with #{@group2.name}. Please try again."
      redirect_to @group
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

  def find_group
    @group = Group.find(params[:id])
  end

end
