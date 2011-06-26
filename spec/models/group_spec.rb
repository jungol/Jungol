require 'spec_helper'

describe Group do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :name => "Test Group",
      :about => "About Us",
      :announcement => "Announcement"
    }
  end

  it "should create a new group given valid attributes" do
    @user.groups.create!(@attr)
  end

  describe "validations" do

    it "should require a name" do
      noname_group = @user.groups.new(@attr.merge(:name => ""))
      noname_group.should_not be_valid
    end

    it "should require an about section" do
      no_about = @user.groups.new(@attr.merge(:about =>""))
      no_about.should_not be_valid
    end

    it "should require a unique name" do
      Group.create!(@attr)
      dup_group = Group.new(@attr)
      dup_group.should_not be_valid
    end
  end

  describe "field checking" do
    before(:each) do
      @group = @user.groups.create!(@attr)
    end

    it "should have a creator" do
      @group.memberships.find_by_role(1).should_not be_nil
    end

    it "should respond to users" do
      @group.should respond_to(:users)
    end

    it "should respond to memberships" do
      @group.should respond_to(:memberships)
    end

  end

end
