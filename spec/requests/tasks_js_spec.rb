require 'spec_helper'

describe "TasksJs" do
  describe "Task creation form" do
    before(:each) do
      @user = integration_sign_in(Factory(:confirmed_user))
      x = integration_make_group
      visit x + '/todos/new'
    end

    it "should have 3 default task fields" do
      page.should have_field('Task', :name => "todo[tasks_attributes]", :count => 3)
    end

    it "should add a task field when you click the link" do
      click_link 'Add Task'
      page.should have_field('Task', :name => "todo[tasks_attributes]", :count => 4)
    end

    it "should remove a task field when you click the link" do
      click_link 'remove'
      page.should have_field('Task', :name => "todo[tasks_attributes]", :count => 2)
    end
  end

  describe "Task editing" do
    before(:each) do
      @user = integration_sign_in(Factory(:confirmed_user))
      integration_make_todo integration_make_group
    end

    it "should show an inline editing field after click", :js => true do
      @task = page.find('span.edit_task_desc')
      page.should_not have_field('inplace_value')
      @task.click
      page.should have_field('inplace_value')
    end
  end
end
