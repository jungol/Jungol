require 'spec_helper'

describe Membership do
  before(:each) do
    @user = Factory(:user)
    @group = @user.created_groups.create!(
      :name => "Test Group",
      :about => "About Us",
    )
    @attr = {
      :user_id => @user.id,
      :group_id => @group.id,
      :role => 2
    }
  end

  describe "validations" do

    it "should have a role" do
      @mem = Membership.new(@attr.merge(:role => nil))
      @mem.should_not be_valid
    end

    it "should have a user_id" do
      @mem = Membership.new(@attr.merge(:user_id => ""))
      @mem.should_not be_valid
    end

    it "should have a group_id" do
      @mem = Membership.new(@attr.merge(:group_id => ""))
      @mem.should_not be_valid
    end

  end

end
