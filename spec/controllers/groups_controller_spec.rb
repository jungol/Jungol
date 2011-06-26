require 'spec_helper'

describe GroupsController do

  render_views

  before(:each) do
    @user = test_sign_in(Factory(:user))
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create Group")
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attr = { :name => "",
                :about => "",
                :announcement => "" }
    end

    it "should not create a group" do
      lambda do
        post :create, :user => @attr
      end.should_not change(Group, :count)
    end

    it "should have the right title" do
      post :create, :user => @attr
      response.should have_selector("title", :content => "Create Group")
    end

    it "should render the 'new' page" do
      post :create, :user => @attr
      response.should render_template('new')
    end

    describe "success" do

      before(:each) do
        @attr = {:name => "Test Group", :about => "A Sweet Group", :announcement => "it worked!"}
      end

      it "should create a group" do
        lambda do
          post :create, :group => @attr
        end.should change(Group, :count).by(1)
      end

      it "should redirect to the group show page" do
        post :create, :group => @attr
        response.should redirect_to(group_path(assigns(:group)))
      end


      it "should have a confirmation message" do
        post :create, :group => @attr
        flash[:success].should =~ /group created/i
      end
    end
  end
end
