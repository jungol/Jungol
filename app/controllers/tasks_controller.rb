class TasksController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
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
      flash[:success] = "Task added."
    elsif
      flash[:error] = "Error adding task. Please try again."
    end
    redirect_to group_todo_path(@group, @todo)
  end

  def update
    @task = Task.find(params[:id])
    if params['task']['description']
      if(@task.update_attributes(:description => params['task']['description']))
        flash[:success] = "Task updated."
        #render :text => params['task']['description']
      else
        flash[:error] = "Error updating task. Please try again."
      end
    end
    if params['task']['status']
      if(@task.update_attributes(:status => params['task']['status']))
        flash[:success] = "Task updated."
        #render :text => params['task']['status']
      else
        flash[:error] = "Error updating task. Please try again."
      end
    end
    render :text => params['task']['status'] || params['task']['description']
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
