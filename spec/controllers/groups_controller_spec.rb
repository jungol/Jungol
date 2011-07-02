require 'spec_helper'

describe GroupsController do

  render_views


  describe "GET 'new'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

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
      @user = test_sign_in(Factory(:user))
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

      @user = test_sign_in(Factory(:user))
      @group = @user.created_groups.create(@attr)
    end

    it "should redirect a non-creator" do
      test_sign_in(Factory(:user, :email => Factory.next(:email)))
      get :edit, :id => @group
      response.should redirect_to(@group)
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

      @user = test_sign_in(Factory(:user))
      @group = @user.created_groups.create(@attr)
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :about => ""}
      end

      it "should redirect a non-creator" do
        test_sign_in(Factory(:user, :email => Factory.next(:email)))
        put :update, :id => @group, :group => @attr
        response.should redirect_to(@group)
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
        response.should redirect_to(@group)
      end

      it "should have a flash message" do
        put :update, :id => @group, :group => @attr
        flash[:success].should =~ /updated/i
      end
    end

  end

  describe "group connections" do
    before(:each) do
      @attr = {:name => "Test Group",
               :about => "TEST!"}
      @user = Factory(:user)
      @group = @user.created_groups.create(@attr)
    end

    describe "GET 'link'" do

      it "should render the 'link' page" do
        test_sign_in(@user)
        get :link, :id => @group
        response.should render_template(:link)
      end

      it "should have the right title" do
        test_sign_in(@user)
        get :link, :id => @group
        response.should have_selector("title", :content => "Connect to Group")
      end

      it "should redirect if not signed_in" do
        get :link, :id => @group
        response.should redirect_to(signin_path)
      end

      it "should redirect if user is not a group leader" do
        @user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(@user)
        get :link, :id => @group
        response.should redirect_to(@group)
      end
    end

    describe "POST 'link'" do
      before(:each) do
        @group2 = @user.created_groups.create(@attr.merge(:name => Factory.next(:name)))
        @group3 = @user.created_groups.create(@attr.merge(:name => Factory.next(:name)))
      end

      describe "failure" do

        it "should redirect if not signed_in" do
          post :link, :id => @group, :group => {:id => @group2.id}
          response.should redirect_to(signin_path)
        end

        it "should redirect if user is not a group leader" do
          @user = Factory(:user, :email => Factory.next(:email))
          test_sign_in(@user)
          post :link, :id => @group, :group => {:id => @group2.id}
          response.should redirect_to(@group)
        end
      end

      describe "success" do
        it "should connect group A to group B" do
          lambda do
            test_sign_in(@user)
            post :link, :id => @group, :group => {:id => @group2}
          end.should change(@group.groups, :count)
        end

        it "should connect group B to group A" do
          lambda do
            test_sign_in(@user)
            post :link, :id => @group2, :group => {:id => @group}
          end.should change(@group.groups, :count)
        end

        it "should redirect to the group page" do
          test_sign_in(@user)
          post :link, :id => @group, :group => {:id => @group2}
          response.should redirect_to(@group)
        end

      end
    end
  end
end
