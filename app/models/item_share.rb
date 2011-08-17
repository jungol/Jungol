class ItemShare < ActiveRecord::Base

  attr_accessible :admins_only, :group_id

  belongs_to :item, :polymorphic => true
  belongs_to :group

  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'
  
  def notify_users
    user_list = (admins_only ? group.admins : group.members)
    user_list.each do |user|
      InteractionMailer.new_share(user, self).deliver unless user == creator
    end
  end

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

