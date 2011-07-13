require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    #should redirect to signin page
    fill_in :email,     :with => user.email
    fill_in :password,  :with => user.password
    click_button :submit
    #should redirect to users/edit
   page.should have_selector 'title', :content => 'Edit'
  end
end
