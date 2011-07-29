require 'spec_helper'

describe TodosController do

  before(:each) do
    @attr = { :name => "Test Group",
              :about => "We're a Group!"}
    @user = Factory(:confirmed_user)
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

  describe "DELETE 'destroy'" do
    before(:each) do
      @todo = @user.created_todos.create!(:title => "bla", :description => "desc")
      @group.todos << @todo
      @user.share @group, @todo
    end

    describe "as a non-member" do
      it "should protect the page" do
        @user = Factory(:confirmed_user)
        test_sign_in @user
        delete :destroy, :group_id => @group, :id => @todo
        response.should redirect_to @group
      end
    end

    describe "as a non-admin" do
      it "should direct back to todo" do
        @user = Factory(:confirmed_user)
        test_sign_in @user
        @group.users << @user
        delete :destroy, :group_id => @group, :id => @todo
        response.should redirect_to group_todo_path(@group, @todo)
      end
    end

    describe "as a creator/admin" do
      it "should destroy the todo" do
        expect {
        delete :destroy, :group_id => @group, :id => @todo
        }.should change(Todo, :count).by(-1)
      end

      it "should update the group's todo count" do
        expect {
        delete :destroy, :group_id => @group, :id => @todo
        }.should change(@group.todos, :count).by(-1)
      end

      it "should redirect to the group page" do
        delete :destroy, :group_id => @group, :id => @todo
        response.should redirect_to @group
      end
    end
  end

end
