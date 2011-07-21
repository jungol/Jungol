class DiscussionsController < ApplicationController
  before_filter :find_group
  before_filter :require_member
  before_filter :find_disc, :except => [:new, :create, :share]
  before_filter :authenticate_user!, :except => [:index, :show]

  def new
    @title = "Create a Discussion"
    @discussion = Discussion.new
  end

  def create
    @discussion = current_user.created_discussions.build(params[:discussion])
    if @discussion.save #success
      @group.discussions << @discussion
      flash[:success] = "Discussion Created."
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
    @shared = @discussion.groups
  end

  def share
    if request.post? #CREATE SHARE
      new_share = current_user.created_shares.new()
      if new_share.save
        @discussion = Discussion.find(params[:id])
        @discussion.item_shares << new_share
        @group.item_shares << new_share
        flash[:success] = "Discussion #{@discussion.title} is now shared with #{@group.name}."
      else
        flash[:error] = "Problem sharing discussion.  Please try again."
      end
    elsif request.put? #UPDATE SHARE

    else #UNKNOWN

    end
    redirect_to group_discussion_path(@discussion.group, @discussion)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_disc
    @discussion = Discussion.find(params[:id], :conditions => {:group_id => params[:group_id]})
  end


end
