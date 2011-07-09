class TodoItemsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  before_filter :get_group, :get_todo
  before_filter :require_member
  before_filter :require_leader, :only => [:delete]

  def new
    @title = "New Todo for #{@group.name}"
    @item = @todo.items.new
  end

  def create
    @item = @todo.items.build(params[:todo_item])
    if @item.save
      flash[:success] = "Item added."
    elsif
      flash[:error] = "Error adding item. Please try again."
    end
    redirect_to group_todo_path(@group, @todo)
  end

  def update
    @item = TodoItem.find(params[:id])
    if params["description"]
      if(@item.update_attributes(:description => params["description"]))
        flash[:success] = "Item updated."
        render :text => params["description"]
      else
        flash[:error] = "Error updating item. Please try again."
      end
    elsif params["status"]
      if(@item.update_attributes(:status => params["status"]))
        flash[:success] = "Item updated."
        render :text => params["status"]
      else
        flash[:error] = "Error updating item. Please try again."
      end
    end
    #redirect_to group_todo_path(@group, @todo)
  end


  private
    def get_todo
      @todo = Todo.find(params[:todo_id])
    end

    def get_group
      @group = Group.find(params[:group_id])
    end


end
