require 'spec_helper'

describe "TasksJs" do
  describe "Tasks form" do
    before(:each) do
      @user = integration_sign_in(Factory(:user))
      integration_make_group

      it "should have 3 default task fields" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        visit new_group_todo_path
        page.should have_selector('input', :name => "todo[tasks_attributes]", :count => 3)
      end

      it "should add a task field when you click the link" do
        visit new_group_todo_path
        click_link 'Add Task'
        page.should have_selector('input', :name => "todo[tasks_attributes]", :count => 4)
      end

      it "should remove a task field when you click the link" do
        visit new_group_todo_path
        click_link 'Remove Task'
        page.should have_selector('input', :name => "todo[tasks_attributes]", :count => 22)
      end
    end
  end
end
