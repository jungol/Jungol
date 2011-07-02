require 'spec_helper'

describe PagesController do
  describe "Invitation" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "failure" do
      it "should redirect to signin if not logged in" do
        get :invite
        response.should redirect_to signin_path
      end
    end

    describe "success" do
      before(:each) do
        test_sign_in(@user)
        @emails = "example-1@jungolhq.com, example-2@jungolhq.com, example-3@jungolhq.com, else"
      end

      it "should render the invite page" do
        get :invite
        response.should be_successful
      end

      it "should render after post" do
        post :invite, :invitees => @emails
        response.should render_template(:invite)
      end

      it "should send valid emails" do
        post :invite, :invitees => @emails
        flash[:success].should =~ /example-1/
        flash[:success].should =~ /example-2/
        flash[:success].should =~ /example-3/
      end

      it "should not send invalid emails" do
        post :invite, :invitees => @emails
        flash[:error].should =~ /else/
      end
    end


  end

end
