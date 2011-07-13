require 'spec_helper'
describe "Layout links" do

  it "should have a home page at '/'" do
    visit root_path
    page.should have_selector('title', :content => "Home")
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      page.should have_selector("a", :href => signin_path,
                                    :content => "Sign in")
    end
  end

  describe "when signed in" do
    before(:each) do
      @user = integration_sign_in(Factory(:user))
    end

    it "should have a signout link" do
      visit root_path
      page.should have_selector("a", :href => signout_path,
                                    :content => "Sign out")
    end

    it "should have a profile link" do
      visit root_path
       page.should have_selector("a", :href => '/users/#{@user.id}',
                                     :content => "Profile")
    end

  end
end
