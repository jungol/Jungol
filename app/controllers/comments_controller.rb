class CommentsController < ApplicationController
  before_filter :find_group, :find_item
  before_filter :find_comment, :only => :update
  before_filter :require_member
  before_filter :require_creator, :only => :update
  before_filter :authenticate, :except => [:index, :show]
  # GET /comments
  # GET /comments.json
  #  def index
  #    @comments = Comment.all
  #
  #    respond_to do |format|
  #      format.html # index.html.erb
  #      format.json { render json: @comments }
  #    end
  #  end
  #
  #  # GET /comments/1
  #  # GET /comments/1.json
  #  def show
  #    @comment = Comment.find(params[:id])
  #
  #    respond_to do |format|
  #      format.html # show.html.erb
  #      format.json { render json: @comment }
  #    end
  #  end
  #
  #  # GET /comments/new
  #  # GET /comments/new.json

#  def new
#    @comment = Comment.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @comment }
#    end
#  end

  # GET /comments/1/edit
#  def edit
#    @comment = Comment.find(params[:id])
#  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save #SUCCESS
        if(@todo)
          @todo.comments << @comment
          format.html { redirect_to group_todo_path(@group, @todo), notice: 'Comment was successfully created.' }
          format.json { render json: @comment, status: :created, location: @comment }
        elsif @disc
          #TODO - handle comments for discussion
          #@disc.comments << @comment
        end
      else
        format.html { render :template => 'todos/show' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to group_todo_path(@group, @todo), notice: 'Comment was successfully created.' }
        format.json { head :ok }
      else
        format.html { render :template => 'todos/show' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
#  def destroy
#    @comment = Comment.find(params[:id])
#    @comment.destroy
#
#    respond_to do |format|
#      format.html { redirect_to comments_url }
#      format.json { head :ok }
#    end
#  end

  private

  def find_group
    @group = Group.find(params[:group][:id])
  end

  def find_item
    if params[:todo]
      @todo = Todo.find params[:todo][:id]
    elsif params[:disc]
      @disc = Discussion.find params[:disc][:id]
    end
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def require_creator
    if @comment.user != current_user
      flash[:error] = "You must be the comment's creator to do that."
      redirect_to group_path(@group)
    end
  end

end
