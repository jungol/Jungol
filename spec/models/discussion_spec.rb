require 'spec_helper'

describe Discussion do
   before(:each) do
    @user = Factory(:user)
    @attr = {:title => "Test", :body => "Something"}
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

    it "should require a body" do
      nobody = @user.created_discussions.new(@attr.merge(:body => ""))
      nobody.should_not be_valid
    end

  end
end
