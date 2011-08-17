class Interaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, :polymorphic => true
end

# == Schema Information
#
# Table name: interactions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  summary    :string(255)
#  item_type  :string(255)
#  item_id    :integer
#  created_at :datetime
#  updated_at :datetime
#