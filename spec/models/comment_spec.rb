require 'spec_helper'

describe Comment do

  before(:each) do
    @todo = Factory(:todo)
  end

  describe "validations" do
    it "should require a body" do
      nobody = @todo.comments.new(:body => "")
      nobody.should_not be_valid
    end

    it "should have a max 512 body length" do
      bigbody = @todo.comments.new(:body => "aaaaaa"*100)
      bigbody.should_not be_valid
    end

  end
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  body       :text
#  item_type  :string(255)
#  item_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

