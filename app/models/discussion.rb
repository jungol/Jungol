class Discussion < ActiveRecord::Base
  attr_accessible :title, :description

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :item_shares, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :shared_groups, :through => :item_shares, :source => :group
  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :interactions, :dependent => :destroy, :as => :item
  has_many :interactors, :through => :interactions, :source => :user, :uniq => true

  validates( :title, :presence => true,
                      :length => {:maximum => 60},
                      :uniqueness => { :case_sensitive => false})

  validates :description, :presence => true

  def admin_share?(group)
    self.item_shares.find_by_group_id(group.id).admins_only
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

