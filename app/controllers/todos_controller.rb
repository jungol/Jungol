class TodosController < ApplicationController
  before_filter :find_group
  before_filter :require_member
  before_filter :find_todo, :except => [:new, :create]
  before_filter :authenticate_user!, :except => [:index, :show]

  def new
    @title = "Create a Todo List"
    @todo = Todo.new
    3.times{ @todo.tasks.build }
  end

  def show
    @title = "#{@todo.title} < #{@group.name}"
    @comment = current_user.comments.new
    @unshared = @group.unshared_groups(@todo)
    @shared = @todo.groups
 end

  def create
    @todo = current_user.created_todos.build(params[:todo])
    if @todo.save #success
      @group.todos << @todo
      flash[:success] = "Todo Created."
      redirect_to group_todo_path(@group, @todo)
    else
      @title = "Create a Todo List"
      render :new
    end
  end

  def share
    if request.post? #CREATE SHARE
      new_share = current_user.created_shares.new()
      if new_share.save
        @todo = Todo.find(params[:id])
        @todo.item_shares << new_share
        @group.item_shares << new_share
        flash[:success] = "Todo #{@todo.title} is now shared with #{@group.name}."
      else
        flash[:error] = "Problem sharing todo.  Please try again."
      end
    elsif request.put? #UPDATE SHARE

    else #UNKNOWN

    end
    redirect_to group_todo_path(@todo.group, @todo)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_todo
    @todo = Todo.find(params[:id])
  end

end
