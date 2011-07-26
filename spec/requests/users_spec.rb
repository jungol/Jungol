require 'spec_helper'

describe "Users" do

  describe "views" do

    describe "signup" do

      before(:each) do
        visit new_user_registration_path
      end


      it "should have the right title" do
        page.should have_css('title', :content => "Sign up")
      end

      it "should have a name field" do
        page.should have_css("input", :id => 'user_name', :type => 'text')
      end

      it "should have a email field" do
        page.should have_css("input", :id => 'user_email', :type => 'text')
      end

      it "should have a password field" do
        page.should have_selector("input[id='user_password'][type='password']")
      end

      it "should have a password confirmation field" do
        page.should have_selector("input[id='user_password_confirmation'][type='password']")
      end
    end

    describe "show view" do
      before(:each) do
        @user = Factory(:user)
        integration_sign_in @user
        visit user_path(@user)
      end

      it "should include the user's name" do
        page.should have_selector("h1", :content => @user.name)
      end

      it "should have a profile image" do
        page.should have_selector( "h1>img", :class => "gravatar")
      end

    end

    describe "edit view" do

      before(:each) do
        @user = Factory(:user)
        integration_sign_in @user
        visit edit_user_registration_path @user
      end

      it "should have a link to change the Gravatar" do
        gravatar_url = "http://en.gravatar.com/emails"
        page.should have_selector( "a", :href => gravatar_url,
                                      :content => "change" )
      end
    end
  end

  describe "signup" do
    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "Name",             :with => ""
          fill_in "Email",            :with => ""
          fill_in "Password",         :with => ""
          fill_in "Password confirmation",     :with => ""
          click_button :submit
        end.should_not change(User, :count)
      end
    end
    describe "success" do

      it "should make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in 'user_name',              :with => "Example User"
          fill_in 'user_email',            :with => "user@example.com"
          fill_in 'user_password',         :with => "foobar"
          fill_in 'user_password_confirmation',     :with => "foobar"
          click_button :submit
        end.should change(User, :count).by(1)
      end
    end

  end

  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        user = User.new( :email => "fake@fake.com", :password => "invalid")
        visit new_user_session_path
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => user.password
        click_button :submit
        page.should have_selector("div.flash.alert", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        user.confirm!
        visit new_user_session_path
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => user.password
        click_button :submit
        page.should have_content "Signed in successfully"
        click_link "Logout"
        page.should have_content "Signed out successfully"
      end
    end
  end

end
