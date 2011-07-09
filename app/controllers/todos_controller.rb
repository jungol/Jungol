class TodosController < ApplicationController
  before_filter :find_group
  before_filter :require_member
  before_filter :find_todo, :except => [:new, :create]
  before_filter :authenticate, :except => [:index, :show]

  def new
    @title = "Create a Todo List"
    @todo = Todo.new
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

  def show
    @title = "#{@todo.title} < #{@group.name}"
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_todo
    @todo = Todo.find(params[:id])
  end

end
