class Comment < ActiveRecord::Base

  attr_accessible :body

  belongs_to :item, :polymorphic => true
  belongs_to :user

  validates :body, :presence => true

  def item
    self.item
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

