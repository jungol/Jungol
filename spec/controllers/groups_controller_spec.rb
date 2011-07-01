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
                }
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
        @attr = {:name => "Test Group", :about => "A Sweet Group"}
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


  describe "GET 'edit'" do
    before(:each) do
      @attr = {:name => "Test Group",
                :about => "about us" }

      @group = @user.created_groups.create(@attr)
    end

    it "should redirect a non-creator" do
      test_sign_in(Factory(:user, :email => Factory.next(:email)))
      get :edit, :id => @group
      response.should redirect_to(root_path)
    end


    it "should be successful" do
      get :edit, :id => @group
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @group
      response.should have_selector( "title", :content => "Edit Group")
    end

  end

  describe "PUT 'update'" do
    before(:each) do
      @attr = {:name => "Test Group",
                :about => "about us" }

      @group = @user.created_groups.create(@attr)
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :about => ""}
      end

      it "should redirect a non-creator" do
        test_sign_in(Factory(:user, :email => Factory.next(:email)))
        put :update, :id => @group, :group => @attr
        response.should redirect_to(root_path)
      end

      it "should render the 'edit' page" do
        put :update, :id => @group, :group => @attr
        response.should render_template(:edit)
      end

      it "should render the 'edit' page" do
        put :update, :id => @group, :group => @attr
        response.should have_selector("title", :content => "Edit Group")
      end
    end

    describe "success" do
      it "should update a group's attributes" do
        @attr = @attr.merge :name => "New Name"
        put :update, :id => @group, :group  => @attr
        @group.reload
        @group.name.should == @attr[:name]
      end

      it "should redirect to the group show page" do
        put :update, :id => @group, :group => @attr
        response.should redirect_to(group_path(@group))
      end

      it "should have a flash message" do
        put :update, :id => @group, :group => @attr
        flash[:success].should =~ /updated/i
      end
    end

  end

end
