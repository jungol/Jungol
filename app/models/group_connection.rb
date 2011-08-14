class GroupConnection < ActiveRecord::Base
  attr_accessible :group_id, :group_b_id, :status

  validates_presence_of :group_id, :group_b_id, :status

  validates_inclusion_of :status, :in => 0..2

  #ASSOCIATIONS
  belongs_to :group
  belongs_to :group_b, :class_name => 'Group'

end


# == Schema Information
#
# Table name: group_connections
#
#  id         :integer         not null, primary key
#  group_id   :integer
#  group_b_id :integer
#  is_pending :boolean         default(TRUE), not null
#  created_at :datetime
#  updated_at :datetime
#

