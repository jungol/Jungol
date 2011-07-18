require 'spec_helper'

describe TodosController do

  before(:each) do
    @attr = { :name => "Test Group",
              :about => "We're a Group!"}
    @user = Factory(:user)
    sign_in @user
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
        sign_in @user
        get :new, :group_id => @group
        response.should redirect_to (@group)
        flash[:error].should =~ /member/
      end
    end

  end

  describe "POST 'create'" do
    before(:each) do
      @attr = {:title => "A Test Todo"}
    end

    it "should add a Todo to DB" do
      lambda do
        post :create, :group_id => @group, :todo => @attr
      end.should change(Todo, :count)
    end

    it "should have a success message" do
        post :create, :group_id => @group, :todo => @attr
        flash[:success].should == "Todo Created."
    end

    it "should add tasks as well" do
      @task_attr = {500 => {:description => "something"}}
      lambda do
        post :create,
          :group_id => @group,
          :todo => @attr.merge(:tasks_attributes => @task_attr)
      end.should change(Task, :count).by(1)
    end

  end

end
