require 'spec_helper'

describe "Groups" do
  describe "creation" do
    describe "failure" do

      it "should redirect to root if not logged in" do
        visit 'groups/new'
        response.should have_selector('div.flash.notice', :content => "Please sign in")
      end

      it "should not make a new group" do
        lambda do
          integration_sign_in(user = Factory(:user))
          visit 'groups/new'
          fill_in :group_name,    :with => ""
          fill_in :group_about,   :with => ""
          click_button
          response.should render_template('groups/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(Group, :count)
      end
    end

    describe "success" do

      it "should make a new group" do
        lambda do
          user = Factory(:user)
          integration_sign_in(user)
          visit 'groups/new'
          fill_in :group_name,    :with => "New Group"
          fill_in :group_about,   :with => "About us"
          check :agreement
          click_button
          response.should render_template('groups/show')
          response.should have_selector('div.flash.success', :content => "Group Created")
        end.should change(Group, :count).by(1)

      end

      it "should make a new creator membership" do
        lambda do
          user = Factory(:user)
          integration_sign_in(user)
          visit 'groups/new'
          fill_in :group_name,    :with => "New Group"
          fill_in :group_about,   :with => "About us"
          check :agreement
          click_button
          response.should render_template('groups/show')
          response.should have_selector('div.flash.success', :content => "Group Created")
        end.should change(Membership, :count).by(1)

      end
    end

    it "should redirect because we don't have JS to POST" do
      lambda do
        user = Factory(:user)
        integration_sign_in(user)
        group = user.created_groups.create(:name => "Test", :about => "something!")
        visit group_path(group)
        click_link "join_button"
        response.should have_selector('div.flash.error', :content => "Please enable javascript")
        response.should render_template('groups/show')
      end.should change(Membership, :count).by(1) #only for the creator, not the join
    end
  end
end
