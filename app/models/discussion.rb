class Discussion < ActiveRecord::Base
  attr_accessible :title, :description

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :item_shares, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :shared_groups, :through => :item_shares, :source => :group
  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'

  validates( :title, :presence => true,
                      :length => {:maximum => 60},
                      :uniqueness => { :case_sensitive => false})

  validates :description, :presence => true

  def all_groups #all groups that can see this item
    ret = [] << self.group
    ret | self.shared_groups
  end

end


# == Schema Information
#
# Table name: discussions
#
#  id          :integer         not null, primary key
#  creator_id  :integer
#  group_id    :integer
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

