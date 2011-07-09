require 'spec_helper'

describe TodoItemsController do

  render_views

  before(:each) do
    @attr = { :name => "Test Group",
              :about => "We're a Group!"}
    @user = test_sign_in(Factory(:user))
    @group = @user.created_groups.create(@attr)
    @todo = @user.created_todos.create(:title => "TEST TODO")
    @group.todos << @todo
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new, :group_id => @group, :todo_id => @todo
      response.should be_success
    end

  end

  describe "POST 'create'" do
    before(:each) do
      @attr = { :description => ""}
    end

    it "should not create an invalid Item" do
      lambda do
        post :create, :group_id => @group, :todo_id => @todo, :todo_item => @attr
      end.should_not change(TodoItem, :count)
    end

    it "if invalid should redirect to the Todo page" do
      post :create, :group_id => @group, :todo_id => @todo, :todo_item => @attr
      response.should redirect_to([@group, @todo])
    end

    it "if invalid should give error message" do
      post :create, :group_id => @group, :todo_id => @todo, :todo_item => @attr
      flash[:error].should =~ /error adding/i
    end

    describe "success" do
      before(:each) do
        @attr = {:description => "Something here!"}
      end

      it "should create a new item" do
        lambda do
          post :create, :group_id => @group, :todo_id => @todo, :todo_item => @attr
        end.should change(TodoItem, :count).by(1)
      end

      it "should redirect to the todo show page" do
        post :create, :group_id => @group, :todo_id => @todo, :todo_item => @attr
        response.should redirect_to([@group, @todo])
      end

      it "should display a confirmation message" do
        post :create, :group_id => @group, :todo_id => @todo, :todo_item => @attr
        flash[:success].should =~ /added/i
      end

    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @attr = { :description => "description",
                :status => 2}
      @item = @todo.items.create(@attr)
    end

    describe "failure" do
      before(:each) do
        @attr = { :description => ""}
      end

      it "should redirect a non-member" do
        test_sign_in(Factory(:user, :email => Factory.next(:email)))
        put :update, :group_id => @group, :todo_id => @todo, :id => @item, :todo_item => @attr
        response.should redirect_to(@group)
      end
    end

    describe "success" do
      it "should update an item's description" do
        @attr = @attr.merge( :descrption => "new description")
        put :update, :group_id => @group, :todo_id => @todo, :id => @item, :todo_item => @attr
        @item.reload
        @item.description.should == @attr[:description]
      end

      it "should update an item's status" do
        @attr = @attr.merge( :status => 1)
        put :update, :group_id => @group, :todo_id => @todo, :id => @item, :todo_item => @attr
        @item.reload
        @item.status.should == @attr[:status]
      end

      it "should NOT update an item's order" do
        @attr = @attr.merge( :list_order => 57)
        put :update, :group_id => @group, :todo_id => @todo, :id => @item, :todo_item => @attr
        @item.reload
        @item.list_order.should_not == @attr[:list_order]
      end

      it "should have a confirmation message" do
        put :update, :group_id => @group, :todo_id => @todo, :id => @item, :todo_item => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

end
