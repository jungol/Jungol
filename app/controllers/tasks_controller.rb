class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_group, :get_todo
  before_filter :require_member
  before_filter :require_admin, :only => [:delete]

  def new
    @title = "New Task for #{@group.name}"
    @task = @todo.tasks.new
  end

  def create
    @task = @todo.tasks.build(params[:task])
    if @task.save
      flash.now[:success] = "Task added."
    elsif
      flash.now[:error] = "Error adding task. Please try again."
    end
    redirect_to group_todo_path(@group, @todo)
  end

  def update
    @task = Task.find(params['id'])
    if params['task'].is_a? Array #WE'RE UPDATING LIST ORDER
      @todo.update_order(params['task'])
      render :nothing => true
      return
    end
    if params['task']['description'] #UPDATING DESCRIPTION
      if(@task.update_attribute(:description, params['task']['description']))
        flash.now[:success] = "Task updated."
      else
        flash.now[:error] = "Error updating task. Please try again."
      end
    end
    if params['task']['status'] #UPDATING STATUS
      if(@task.update_attribute(:status, params['task']['status']))
        flash.now[:success] = "Task updated."
      else
        flash.now[:error] = "Error updating task. Please try again."
      end
    end
    if params['task']['list_order']
      if(@task.update_attribute(:list_order, params['task']['list_order']))
        flash.now[:success] = "Task updated."
      else
        flash.now[:error] = "Error updating task. Please try again."
      end
    end
    render :text => params['task']['status'] || params['task']['description'] || params['task']['list_order']
  end


  private
    def get_todo
      @todo = Todo.find(params[:todo_id])
    end

    def get_group
      @group = Group.find(params[:group_id])
    end


end
