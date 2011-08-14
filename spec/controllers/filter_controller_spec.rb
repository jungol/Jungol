require 'spec_helper'

describe FilterController do

  before(:each) do
    @user = Factory(:confirmed_user)
    test_sign_in @user
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST 'filter'" do
    before(:each) do
      @attr = {:name => "Group Test", :about => "bla bla", :agreement => "1"}
      @group = @user.created_groups.create(@attr)
    end
    it "should be successful" do
      post :filter, "origin_group" => "1", "selected_groups" => [@group]
      response.should be_success
    end
  end

  describe "POST 'select'" do
    before(:each) do
      @attr = {:name => "Group Test", :about => "bla bla", :agreement => "1"}
      @group = @user.created_groups.create(@attr)
    end
    it "should be successful" do
      post :select, "group_id" => @group
      response.should be_success
    end
  end

end
