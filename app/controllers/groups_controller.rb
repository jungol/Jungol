class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_group, :except => [:index, :new, :create]
  before_filter :require_admin, :only => [:destroy, :edit, :update, :link, :administer, :approve_user, :approve_group]

  def index
    @title = "All Groups"
    @blurb = "These are all the groups currently on Jungol."
    @groups = Group.paginate(:page => params[:page])
  end

  def new
    @title = "Create Group"
    @group = Group.new
    @blurb = "Create a new group to share with the world."
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

        #SEND OUT NOTIFICATION EMAILS
        @group.admins.each do |admin|
          Notifier.pending_user(admin, @group, current_user).deliver
        end

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
    @title = "Group Connections"
    if request.get?
      render :link
    elsif request.xhr? #REQUEST LINK
      response_text = {:flash => {}, :text => {}}
      @group2 = Group.find(params[:group][:id])
      if @group.connect(@group2)
        response_text[:flash] = "Pending"

        #SEND OUT NOTIFICATION EMAILS
        @group2.admins.each do |admin|
          Notifier.pending_group(admin, @group2, @group).deliver
        end
      else
        response_text[:flash] = "Error."
      end
      render :json => response_text
      return
    elsif request.post?
      @group2 = Group.find(params[:group][:id])
      if @group.connect(@group2)
        flash[:success] = "Thanks. #{@group2.name} must now approve the connection."

        #SEND OUT NOTIFICATION EMAILS
        @group2.admins.each do |admin|
          Notifier.pending_group(admin, @group2, @group).deliver
        end
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
          mem.notify_user
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
          @group.notify_of_new_connection(@group2)
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

  def destroy
    title = @group.name
    if current_user == @group.creator
      if @group.destroy
        flash[:success] = "Group '#{title}' deleted."
        current_user.update_attributes(:filter_state => nil)
        redirect_to root_path
      end
    else
      flash[:error] = "Error deleting Group '#{title}.'"
      redirect_to group_path @group
    end
  end

  def find_group
    @group = Group.find(params[:id])
  end

end
