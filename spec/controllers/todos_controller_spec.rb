require 'spec_helper'

describe TodosController do

  render_views

  before(:each) do
    @attr = { :name => "Test Group",
              :about => "We're a Group!"}
    @user = test_sign_in(Factory(:user))
    @group = @user.created_groups.create(@attr)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new, :group_id => @group
      response.should be_success
    end

    it "should have the right title" do
      get :new, :group_id => @group
      response.should have_selector(:title, :content => "Create a Todo List")
    end

    describe 'permissions' do
      it "should redirect a non-member" do
        @user = test_sign_in(Factory(:user, :email => Factory.next(:email)))
        get :new, :group_id => @group
        response.should redirect_to (@group)
        flash[:error].should =~ /member/
      end
    end
  end

end
