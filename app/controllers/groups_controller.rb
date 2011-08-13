class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_group, :except => [:index, :new, :create]
  before_filter :require_admin, :only => [:edit, :update, :link, :administer, :approve_user, :approve_group]

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
    @pending = @group.pending_member?(current_user)
    @admin = @group.admin?(current_user)
    @title = @group.name
  end

  #ADD MEMBER TO GROUP
  def join
    if request.post?
      if !@group.users.include?(current_user)
        @group.users << current_user
        flash[:success] = "Thanks! Your membership must now be approved by an admin of #{@group.name}."
        redirect_to @group
      else
        flash[:error] = "Error requesting to join #{@group.name}. Please try again."
        redirect_to @group
      end
    else #it fell back to GET (no js)
      flash[:error] = "Please enable javascript to join."
      redirect_to @group
    end
  end

  #ADD GROUP TO GROUPS
  def link
    @title = "Request connection to Group"
    if request.get?
      @groups = @group.unconnected_groups
      render :link
    elsif request.post?
      @group2 = Group.find(params[:group][:id])
      if @group.connect(@group2)
        flash[:success] = "Thanks. #{@group2.name} must now approve the connection."
      else
        flash[:error] = "Error connecting with #{@group2.name}. Please try again."
      end
      redirect_to @group
    else
      flash[:error] = "Error connecting with #{@group2.name}. Please try again."
      redirect_to @group
    end
  end

  def create
    @group = current_user.created_groups.new(params[:group])
    if @group.save #success
      flash[:success] = "Group Created."
      redirect_to @group
    else
      flash.now[:error] = "Error creating group"
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

  def administer
    if params[:u].present? && params[:r].present?
      mem = Membership.find_by_user_id_and_group_id(params[:u], @group.id)
      if mem.change_role(params[:r])
        flash[:success] = "Member's role updated."
      end
      redirect_to @group
    end
  end

  #Approve/Deny pending memberships
  def approve_user
    if params[:u].present?
      if request.post? #Approve
        mem = Membership.find_by_user_id_and_group_id(params[:u], @group.id)
        if mem.update_attributes(:is_pending => false)
          flash[:success] = "Membership approved."
        end
      elsif request.delete? #DENY
        mem = Membership.find_by_user_id_and_group_id(params[:u], @group.id)
        if mem.destroy
          flash[:success] = "Membership denied."
        end
      end
    end
    redirect_to @group
  end

  #Approve/Deny pending group connections
  def approve_group
    if params[:g].present?
      if request.post? #Approve
        @group2 = Group.find(params[:g])
        if @group.approve_group(@group2)
          flash[:success] = "You're now connected to #{@group2.name}."
        end
      elsif request.delete? #DENY
        @group2 = Group.find(params[:g])
        if @group.deny_group(@group2)
          flash[:success] = "Connection denied."
        end
      end
    end
    redirect_to @group
  end

  def find_group
    @group = Group.find(params[:id])
  end

end
