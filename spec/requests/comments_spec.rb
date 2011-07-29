require 'spec_helper'

describe "Comments" do
  before(:each) do
    @user = Factory(:confirmed_user)
    integration_sign_in(@user)
    integration_make_group
    integration_make_todo
  end

  describe "Creation" do
    it "should create a comment" do
      lambda do
        fill_in 'Post Comment', :with => "Test Comment"
        click_button 'Post'
      end.should change(Comment, :count).by(1)
    end

    it "should add that comment to a user's comments" do
      lambda do
        fill_in 'Post Comment', :with => "Test Comment"
        click_button 'Post'
      end.should change(@user.comments, :count).by(1)
    end

    it "should add that comment to the todo's comments" do
      lambda do
        fill_in 'Post Comment', :with => "Test Comment"
        click_button 'Post'
      end.should change(Todo.first.comments, :count).by(1)
    end
  end
end
