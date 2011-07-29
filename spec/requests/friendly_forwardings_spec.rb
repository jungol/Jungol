require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = Factory(:confirmed_user)
    visit new_user_session_path
    #should redirect to signin page
    fill_in 'Email',     :with => user.email
    fill_in 'Password',  :with => user.password
    click_button :submit
    #should redirect to users/edit
   page.should have_selector 'title', :content => 'Edit'
  end
end
