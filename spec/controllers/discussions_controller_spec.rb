require 'spec_helper'

describe DiscussionsController do
  before(:each) do
    @attr = { :name => "Test Group",
              :about => "We're a Group!"}
    @user = Factory(:user)
    test_sign_in @user
    @group = @user.created_groups.create(@attr)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new, :group_id => @group
      response.should be_success
    end

    it "should have the right title" do
      get :new, :group_id => @group
      response.should render_template :new
    end

    describe 'permissions' do
      it "should redirect a non-member" do
        @user = Factory(:user)
        test_sign_in @user
        get :new, :group_id => @group
        response.should redirect_to (@group)
        flash[:error].should =~ /member/
      end
    end

  end

  describe "POST 'create'" do
    before(:each) do
      @attr = {:title => "A Test Discussion", :description => "A Test Description"}
    end

    it "should add a Discussion to DB" do
      lambda do
        post :create, :group_id => @group, :discussion => @attr
      end.should change(Discussion, :count).by(1)
    end

    it "should have a success message" do
        post :create, :group_id => @group, :discussion => @attr
        flash[:success].should == "Discussion Created."
    end
  end
end
