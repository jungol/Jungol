class DiscussionsController < ApplicationController
  before_filter :find_group
  before_filter :require_member
  before_filter :find_disc, :except => [:new, :create]
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
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_disc
    @discussion = Discussion.find(params[:id])
  end


end
