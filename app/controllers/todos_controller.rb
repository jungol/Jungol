class TodosController < ApplicationController
  before_filter :find_group
  before_filter :find_todo, :except => [:new, :create]
  before_filter :authenticate, :except => [:index, :show]
  before_filter :require_member

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

  private
    def authenticate
      deny_access unless signed_in?
    end

    def require_member
     unless @group.member?(current_user)
       flash[:error] = "You must be a member of #{@group.name} to do that."
       redirect_to(group_path(@group))
     end
    end

    def require_leader
     unless @group.leader?(current_user)
       flash[:error] = "You must be a leader of #{@group.name} to do that."
       redirect_to(group_path(@group))
     end
    end



end
