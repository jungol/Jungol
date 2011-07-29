class ItemShare < ActiveRecord::Base

  attr_accessible :admins_only, :group_id

  belongs_to :item, :polymorphic => true
  belongs_to :group

  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

end


# == Schema Information
#
# Table name: item_shares
#
#  id          :integer         not null, primary key
#  item_id     :integer
#  item_type   :string(255)
#  group_id    :integer
#  creator_id  :integer
#  admins_only :boolean         default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

