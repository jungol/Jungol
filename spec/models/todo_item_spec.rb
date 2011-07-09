require 'spec_helper'

describe TodoItem do

  before(:each) do
    @todo = Factory(:todo)
  end

  describe "validations" do
    it "should require a description" do
      nodesc = @todo.items.new(:description => "")
      nodesc.should_not be_valid
    end

    it "should have a max 140 description length" do
      bigdesc = @todo.items.new(:desc => "aaa"*50)
      bigdesc.should_not be_valid
    end

    it "should have a default status of 0" do
      defstat = @todo.items.create(:desc => "works")
      defstat.status.should == 0
    end

    it "should order items correctly" do
      todo = @todo.items.create(:desc => "first")
      todo.list_order.should == 1
    end
  end
end
