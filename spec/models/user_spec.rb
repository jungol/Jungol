require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com" ,
      :password => "foobar" ,
      :password_confirmation => "foobar"
    }
  end

  it "should create new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.valid?.should_not == true #same as above test
  end

  it "should reject long names" do
    long_name = "a" * 51
    long_user = User.new(@attr.merge(:name => long_name))
    long_user.should_not be_valid
  end

  it "should accept valid emails" do
    valid_emails = %w[user@foo.com the_user@foo.bar.org first.last@foo.jp]
    valid_emails.each do |email|
      valid_email_user = User.new(@attr.merge(:email => email))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    invalid_emails = %w[user@foo,com the_user_at_foo.bar.org first.last@foo.]
    invalid_emails.each do |email|
      invalid_email_user = User.new(@attr.merge(:email => email))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate emails" do
    #put user in database
    User.create!(@attr)
    user_with_dup_email = User.new(@attr)
    user_with_dup_email.should_not be_valid
  end

  it "should reject email identical in case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_dup_email = User.new(@attr)
    user_with_dup_email.should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge( :password_confirmation => "else")).
        should_not be_valid
    end

    it "should reject short password" do
      short = "a" *5
      hash = @attr.merge( :password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
  end

#  describe "admin attribute" do
#    before(:each) do
#      @user = User.create!(@attr)
#    end
#
#    it "should respond to admin" do
#      @user.should respond_to(:admin)
#    end
#
#    it "should not be an admin by default" do
#      @user.should_not be_admin
#    end
#
#    it "should be convertible to an admin" do
#      @user.toggle!(:admin)
#      @user.should be_admin
#    end
#  end

end


# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  about                  :text
#

