class CommentsController < ApplicationController
  before_filter :find_group, :find_item, :only => :create
  before_filter :find_comment, :only => :update
  before_filter :require_view, :only => :create

  def create
    @comment = current_user.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save #SUCCESS
        if(@todo)
          @todo.comments << @comment
          format.html { redirect_to group_todo_path(@group, @todo), notice: 'Comment was successfully created.' }
          format.json { render json: @comment, status: :created, location: @comment }
        elsif @discussion
          @discussion.comments << @comment
          format.html { redirect_to group_discussion_path(@group, @discussion), notice: 'Comment was successfully created.' }
          format.json { render json: @comment, status: :created, location: @comment }
        end
      else
        if @todo
          format.html { render :template => 'todos/show' }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        elsif @discussion
          format.html { render :template => 'discussions/show' }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    if request.post? && @comment.user == current_user
      if @comment.update_attributes(params[:comment])
        render :text => params[:comment][:body]
      else
        render :nothing => true
      end
    else
      render :nothing => true
    end
  end

  private

    def find_group
      @group = Group.find(params[:group][:id])
    end

    def find_item
      if params[:todo]
        @todo = Todo.find params[:todo][:id]
      elsif params[:discussion]
        @discussion = Discussion.find params[:discussion][:id]
      end
    end

    def find_comment
      @comment = Comment.find(params[:id])
    end

    def require_view
      unless current_user.can_view?(@group, (@todo.present? ? @todo : @discussion))
        flash[:error] = "You don't have permission to comment on that."
        redirect_to @group
      end
    end

end
