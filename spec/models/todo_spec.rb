require 'spec_helper'

describe Todo do

  before(:each) do
    @user = Factory(:user)
  end

  describe 'validations' do

    it "should require a title" do
      notitle = @user.created_todos.new(:title => "")
      notitle.should_not be_valid
    end

    it "should require a unique title" do
      @user.created_todos.create(:title => "Test")
      dup = @user.created_todos.new(:title => "Test")
      dup.should_not be_valid
    end
  end
end




# == Schema Information
#
# Table name: todos
#
#  id          :integer         not null, primary key
#  creator_id  :integer
#  group_id    :integer
#  title       :string(255)
#  description :text
#  tasks_count :integer         default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

