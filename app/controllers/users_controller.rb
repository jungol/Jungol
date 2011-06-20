class UsersController < ApplicationController
  def new
    @title = "Sign up"
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Jungol!"
      redirect_to @user
    else
      @title = "Sign up"
      render :new
    end
  end
end
