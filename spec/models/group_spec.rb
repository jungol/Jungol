require 'spec_helper'

describe Group do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :name => "Test Group",
      :about => "About Us",
    }
  end

  it "should create a new group given valid attributes" do
    @user.created_groups.create!(@attr)
  end

  describe "validations" do

    it "should require a name" do
      noname_group = @user.created_groups.new(@attr.merge(:name => ""))
      noname_group.should_not be_valid
    end

    it "should require an about section" do
      no_about = @user.created_groups.new(@attr.merge(:about =>""))
      no_about.should_not be_valid
    end

    it "should require a unique name" do
      @user.created_groups.create!(@attr)
      dup_group = Group.new(@attr)
      dup_group.should_not be_valid
    end
  end

  describe "field checking" do
    before(:each) do
      @group = @user.created_groups.create!(@attr)
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

  describe "member limits" do
    before(:each) do
      @user = Factory(:confirmed_user)
      @group = @user.created_groups.create(:name => "Test", :about => "something!")
    end

    it "should allow 30 existing members in a group" do
      @group.users.stub!(:size).and_return 30
      @group.should be_valid
    end

    it "should not allow 31 members in a group" do
      @group.users.stub!(:size).and_return 31
      @group.should_not be_valid
    end
  end
end




# == Schema Information
#
# Table name: groups
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  about             :text
#  creator_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

