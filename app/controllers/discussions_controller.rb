class DiscussionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_group, :except => :share
  before_filter :find_disc, :except => [:new, :create]
  before_filter :find_origin_group, :only => :share
  before_filter :require_member, :except => :show #catch them in require_view
  before_filter :require_delete, :only => :destroy
  before_filter :require_view, :except => [:new, :create]

  def new
    @title = "Create a Discussion"
    @discussion = Discussion.new
    @privileged = current_user.privileged? @group
    @blurb = "Create a new Discussion to share with the world."
  end

  def create
    @discussion = current_user.created_discussions.build(params[:discussion])
    if @discussion.save #success
      @discussion.interactions.create(:user => current_user, :summary => 'Created Discussion')
      @group.discussions << @discussion

      #create share with original group
      current_user.share @group, @discussion, (params[:admins_only].present?)

      flash[:success] = "Discussion Created."

      #HANDLE SHARING
      if params['share'].present?
        params['share'].each do |sh|
          new_share = current_user.created_shares.new()
          if sh[1].include? "admin"
            new_share.admins_only = true
          end
          if new_share.save
            @shared_group = Group.find(sh[0])
            @discussion.interactions.create(:user => current_user, :summary => 'Shared Discussion')
            @discussion.item_shares << new_share
            @shared_group.item_shares << new_share
            new_share.notify_users
          end
        end
      end
      redirect_to group_discussion_path(@group, @discussion)
    else
      @title = "Create a Discussion"
      render :new
    end
  end

  def show
    @title = "#{@discussion.title} < #{@group.name}"
    @comment = current_user.comments.new
    @unshared = @group.unshared_groups(@discussion)
    @shared = @discussion.shared_groups
    @up_path = group_discussion_path(@group, @discussion)
  end

  def update
    if request.post? #AJAX update - description
      if @discussion.update_attributes(params[:discussion])
        @discussion.update_attribute(:updated_at, Time.now)
        render :text => params[:discussion][:description]
        return
      end
    end
    render :nothing => true
  end

  def share
    if request.get? # SHARE PAGE
      @title = "Share #{@discussion.title}"
      @unshared = @group.unshared_groups(@discussion)
      #@share = @current_user.created_shares.new()
      render :share
      return
    elsif request.xhr? #CREATE SHARE (AJAX)
      response_text = {:flash => {}, :text => {}}
      new_share = current_user.created_shares.new()
      #DID THEY CHECK THE BOX?
      if params[:admins_only].present?
        new_share.admins_only = true
      end

      if new_share.save
        @discussion = Discussion.find(params[:id])
        @discussion.interactions.create(:user => current_user, :summary => 'Shared Discussion')
        @discussion.item_shares << new_share
        @shared_group.item_shares << new_share
        new_share.notify_users
        response_text[:flash] = "'#{@discussion.title}' has been shared with #{@shared_group.name}."
      else
        response_text[:flash] = "Problem sharing discussion.  Please try again."
      end
      render :json => response_text
      return

    elsif request.post? #CREATE SHARE
      new_share = current_user.created_shares.new()
      if params[:admins_only].present?
        new_share.admins_only = true
      end

      if new_share.save
        @discussion = Discussion.find(params[:id])
        @discussion.interactions.create(:user => current_user, :summary => 'Shared Discussion')
        @discussion.item_shares << new_share
        @shared_group.item_shares << new_share
        new_share.notify_users
        flash[:success] = "'#{@discussion.title}' has been shared with #{@shared_group.name}."
      else
        flash[:error] = "Problem sharing discussion.  Please try again."
      end
    elsif request.put? #UPDATE SHARE

    elsif request.delete? #DELETE SHARE

    else #UNKNOWN

    end
    redirect_to group_discussion_path(@discussion.group, @discussion)
  end

  def destroy
    title = @discussion.title
    @discussion.destroy
    flash[:success] = "Discussion '#{title}' destroyed."
    redirect_to @group
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end

    def find_disc
      @discussion = Discussion.find(params[:id])
    end

    def find_origin_group
      @group = @discussion.group
      @shared_group = Group.find(params[:group_id])
    end

    def require_delete
      unless current_user.can_delete? @discussion
        redirect_to group_discussion_path @group, @discussion
      end
    end

    def require_view
      unless current_user.can_view?(@group, @discussion)
        flash[:error] = "You don't have permission to do that."
        redirect_to @group
      end
    end
end
