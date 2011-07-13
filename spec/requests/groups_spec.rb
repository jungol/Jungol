require 'spec_helper'

describe "Groups" do
  describe "creation" do
    describe "failure" do

      it "should not make a new group" do
        lambda do
          integration_sign_in(user = Factory(:user))
          visit new_group_path
          fill_in :group_name,    :with => ""
          fill_in :group_about,   :with => ""
          click_button :submit
          page.should have_selector('div#error_explanation')
        end.should_not change(Group, :count)
      end
    end

    describe "success" do

      it "should make a new group" do
        lambda do
          user = Factory(:user)
          integration_sign_in(user)
          visit new_group_path
          fill_in 'Name',    :with => "New Group"
          fill_in 'About',   :with => "About us"
          check 'Agreement'
          click_button :submit
          page.should have_selector('div.flash', :content => "Group Created")
        end.should change(Group, :count).by(1)

      end

      it "should make a new creator membership" do
        lambda do
          user = Factory(:user)
          integration_sign_in(user)
          visit new_group_path
          fill_in 'Name',    :with => "New Group"
          fill_in 'About',   :with => "About us"
          check 'Agreement'
          click_button :submit
          page.should have_selector('div.flash', :content => "Group Created")
        end.should change(Membership, :count).by(1)

      end

      it "should add a member to a group" do
        lambda do
          user = Factory(:user)
          group = user.created_groups.create(:name => "Test", :about => "something!")

          user2 = Factory(:user, :email => Factory.next(:email))
          integration_sign_in(user2)
          visit group_path(group)
          click_link "join_button"
          page.should have_selector('div.flash', :content => "Please enable javascript")
        end.should change(Membership, :count).by(2) #one for user1, one for user2
      end
    end
  end
end
