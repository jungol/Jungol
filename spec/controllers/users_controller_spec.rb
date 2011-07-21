require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in @user
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should render the show template" do
      get :show, :id => @user
      response.should render_template :show
    end

  end
end
