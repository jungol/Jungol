require 'spec_helper'

describe UpdatesRequest do
  before(:each) do
    @attr = {
      :email => "req@example.com"
    }
  end

  it "should require an email" do
    no_email = UpdatesRequest.new(@attr.merge(:email => ""))
    no_email.valid?.should_not == true #same as above test
  end

  it "should accept valid emails" do
    valid_emails = %w[req@foo.com the_req@foo.bar.org first.last@foo.jp]
    valid_emails.each do |email|
      valid_email_req = UpdatesRequest.new(@attr.merge(:email => email))
      valid_email_req.should be_valid
    end
  end

  it "should reject invalid emails" do
    invalid_emails = %w[req@foo,com the_req_at_foo.bar.org first.last@foo.]
    invalid_emails.each do |email|
      invalid_email_req = UpdatesRequest.new(@attr.merge(:email => email))
      invalid_email_req.should_not be_valid
    end
  end

  it "should reject duplicate emails" do
    #put req in database
    UpdatesRequest.create!(@attr)
    req_with_dup_email = UpdatesRequest.new(@attr)
    req_with_dup_email.should_not be_valid
  end

  it "should reject email identical in case" do
    upcased_email = @attr[:email].upcase
    UpdatesRequest.create!(@attr.merge(:email => upcased_email))
    req_with_dup_email = UpdatesRequest.new(@attr)
    req_with_dup_email.should_not be_valid
  end

end

# == Schema Information
#
# Table name: updates_requests
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  ip         :string(255)
#  created_at :datetime
#  updated_at :datetime
#

