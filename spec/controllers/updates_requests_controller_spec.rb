require 'spec_helper'

describe UpdatesRequestsController do
  describe "POST 'create'" do
    describe "failure" do
      it "should not create with blank email" do
        expect {
          post :create, :updates_request => {:email => ""}
        }.should_not change(UpdatesRequest, :count)
      end

      it "should not create with invalid email" do
        expect {
          post :create, :updates_request => {:email => "admin@"}
        }.should_not change(UpdatesRequest, :count)
      end
    end

    describe "success" do
      it "should be successful" do
        post :create, :updates_request => {:email => "admin@jungolhq.com"}
        response.should be_success
      end

      it "should add a record" do
        expect {
          post :create, :updates_request => {:email => "admin@jungolhq.com"}
        }.should change(UpdatesRequest, :count).by(1)
      end

    end
  end
end
