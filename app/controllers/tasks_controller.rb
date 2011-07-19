class TasksController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :get_group, :get_todo
  before_filter :require_member
  before_filter :require_leader, :only => [:delete]

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
    @task = Task.find(params[:id])
    if params['task'].is_a? Array #WE'RE UPDATING LIST ORDER
      Task.update_many(params['task'])
      render :nothing => true
      return
    end
    if params['task']['description'] #UPDATING DESCRIPTION
      if(@task.update_attributes(:description => params['task']['description']))
        flash.now[:success] = "Task updated."
        #render :text => params['task']['description']
      else
        flash.now[:error] = "Error updating task. Please try again."
      end
    end
    if params['task']['status'] #UPDATING STATUS
      if(@task.update_attributes(:status => params['task']['status']))
        flash.now[:success] = "Task updated."
        #render :text => params['task']['status']
      else
        flash.now[:error] = "Error updating task. Please try again."
      end
    end
    if params['task']['list_order']
      if(@task.update_attributes(:list_order => params['task']['list_order']))
        flash.now[:success] = "Task updated."
        #render :text => params['task']['list_order']
      else
        flash.now[:error] = "Error updating task. Please try again."
      end
    end
    render :text => params['task']['status'] || params['task']['description'] || params['task']['list_order']
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
