require 'spec_helper'

describe Task do

  before(:each) do
    @todo = Factory(:todo)
  end

  describe "validations" do
    it "should require a description" do
      nodesc = @todo.tasks.new(:description => "")
      nodesc.should_not be_valid
    end

    it "should have a max 140 description length" do
      bigdesc = @todo.tasks.new(:description => "aaa"*50)
      bigdesc.should_not be_valid
    end

    it "should have a default status of 0" do
      defstat = @todo.tasks.create(:description => "works")
      defstat.status.should == 0
    end

    it "should order items correctly" do
      todo = @todo.tasks.create(:description => "first")
      todo.list_order.should == 1
    end
  end
end


# == Schema Information
#
# Table name: tasks
#
#  id          :integer         not null, primary key
#  description :string(255)
#  todo_id     :integer
#  status      :integer
#  list_order  :integer
#  task_num    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

