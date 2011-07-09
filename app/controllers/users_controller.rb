class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def new
    if signed_in?
      redirect_to(root_path)
    else
      @title = "Sign up"
      @user = User.new
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    if signed_in?
      redirect_to(root_path)
    else
      @user = User.new(params[:user])
      if @user.save     #WE SAVED THE USER TO THE DB
        sign_in @user
        flash[:success] = "Welcome to Jungol!"
        redirect_to @user
      else              #RELOAD THE SIGNUP PAGE
        @title = "Sign up"
        render :new
      end
    end
  end

  def edit
    #@user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render :edit
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
