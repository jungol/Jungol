class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    @title = "Personal Profile"
    @blurb = "Jungol is a community of people working together to make a difference. Personal Profiles help you learn more about the people you're working with."
  end

end
