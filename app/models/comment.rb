# == Schema Information
# Schema version: 20110714194007
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

class Comment < ActiveRecord::Base

  attr_accessible :body

  belongs_to :item, :polymorphic => true
  belongs_to :user

  validates( :body, :presence => true,
                      :length => {:maximum => 512})

  private

end
