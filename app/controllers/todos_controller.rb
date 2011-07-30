class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_group, :except => :share
  before_filter :find_todo, :except => [:new, :create]
  before_filter :find_origin_group, :only => :share
  before_filter :require_member
  before_filter :require_delete, :only => :destroy
  before_filter :require_view, :except => [:new, :create]

  def new
    @title = "Create a Todo List"
    @todo = Todo.new
    3.times{ @todo.tasks.build }
  end

  def show
    @title = "#{@todo.title} < #{@group.name}"
    @comment = current_user.comments.new
    @unshared = @group.unshared_groups(@todo)
    @shared = @todo.shared_groups
    @up_path = group_todo_path(@group, @todo)
  end

  def create
    @todo = current_user.created_todos.build(params[:todo])
    if @todo.save #success
      @group.todos << @todo

      #create share with original group
      current_user.share @group, @todo

      flash[:success] = "Todo Created."
      redirect_to group_todo_path(@group, @todo)
    else
      @title = "Create a Todo List"
      render :new
    end
  end

  def update
    if request.post? #AJAX update - description
      if @todo.update_attributes(params[:todo])
        render :text => params[:todo][:description]
      end
    else
      if params[:todo][:tasks_attributes] #adding tasks to todo
        @todo.add_many(params[:todo][:tasks_attributes].values)
        flash[:success] = "Todo updated."
        redirect_to group_todo_path(@group, @todo)
      else #updating todo through REST form
        if(@todo.update_attributes(params[:todo]))
          flash[:success] = "Todo updated."
          redirect_to group_todo_path(@group, @todo)
        else
          @title = "#{@todo.title} < #{@group.name}"
          render :show
        end
      end
    end
  end

  def share
    if request.post? #CREATE SHARE
      new_share = current_user.created_shares.new()
      if new_share.save
        @todo = Todo.find(params[:id])
        @todo.item_shares << new_share
        @shared_group.item_shares << new_share
        flash[:success] = "Todo #{@todo.title} is now shared with #{@shared_group.name}."
      else
        flash[:error] = "Problem sharing todo.  Please try again."
      end
    elsif request.put? #UPDATE SHARE

    else #UNKNOWN

    end
    redirect_to group_todo_path(@todo.group, @todo)
  end


  def destroy
    title = @todo.title
    @todo.destroy
    flash[:success] = "Todo '#{title}' destroyed."
    redirect_to group_path(@group)
  end

  private
    def find_group
      @group = Group.find(params[:group_id])
    end

    def find_todo
      @todo = Todo.find(params[:id])
    end

    def find_origin_group
      @group = @todo.group
      @shared_group = Group.find(params[:group_id])
    end

    def require_delete
      unless current_user.can_delete? @todo
        redirect_to group_todo_path(@group, @todo)
      end
    end

    def require_view
      unless current_user.can_view?(@group, @todo)
        flash[:error] = "You don't have permission to do that."
        redirect_to @group
      end
    end
end
