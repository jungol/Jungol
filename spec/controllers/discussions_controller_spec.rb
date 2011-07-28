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

  describe "DELETE 'destroy'" do
    before(:each) do
      @discussion = @user.created_discussions.create!(:title => "bla", :description => "desc")
      @group.discussions << @discussion
    end

    describe "as a non-member" do
      it "should protect the page" do
        @user = Factory(:confirmed_user)
        test_sign_in @user
        delete :destroy, :group_id => @group, :id => @discussion
        response.should redirect_to @group
      end
    end

    describe "as a non-admin" do
      it "should direct back to discussion" do
        @user = Factory(:confirmed_user)
        test_sign_in @user
        @group.users << @user
        delete :destroy, :group_id => @group, :id => @discussion
        response.should redirect_to group_discussion_path(@group, @discussion)
      end
    end

    describe "as a creator/admin" do
      it "should destroy the discussion" do
        expect {
        delete :destroy, :group_id => @group, :id => @discussion
        }.should change(Discussion, :count).by(-1)
      end

      it "should update the group's discussion count" do
        expect {
        delete :destroy, :group_id => @group, :id => @discussion
        }.should change(@group.discussions, :count).by(-1)
      end

      it "should redirect to the group page" do
        delete :destroy, :group_id => @group, :id => @discussion
        response.should redirect_to @group
      end
    end
  end

end
