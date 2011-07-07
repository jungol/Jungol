# == Schema Information
# Schema version: 20110706212751
#
# Table name: todos
#
#  id         :integer         not null, primary key
#  creator_id :integer
#  group_id   :integer
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Todo < ActiveRecord::Base
  attr_accessible :title

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :items, :class_name => 'TodoItem', :dependent => :destroy

  validates( :title, :presence => true,
                      :length => {:maximum => 60},
                      :uniqueness => { :case_sensitive => false})



end
