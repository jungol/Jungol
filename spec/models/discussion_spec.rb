require 'spec_helper'

describe Discussion do
   before(:each) do
    @user = Factory(:user)
    @attr = {:title => "Test", :description => "Something"}
  end

  describe 'validations' do

    it "should require a title" do
      notitle = @user.created_discussions.new(@attr.merge(:title => ""))
      notitle.should_not be_valid
    end

    it "should be valid with valid attributes" do
      validdisc = @user.created_discussions.new(@attr)
      validdisc.should be_valid
    end

    it "should require a unique title" do
      @user.created_discussions.create(@attr)
      dup = @user.created_discussions.new(@attr)
      dup.should_not be_valid
    end

    it "should require a descrption" do
      nodesc = @user.created_discussions.new(@attr.merge(:description => ""))
      nodesc.should_not be_valid
    end

  end
end


# == Schema Information
#
# Table name: discussions
#
#  id          :integer         not null, primary key
#  creator_id  :integer
#  group_id    :integer
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

