class Discussion < ActiveRecord::Base
  attr_accessible :title, :body

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :item_shares, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :groups, :through => :item_shares
  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'

  validates( :title, :presence => true,
                      :length => {:maximum => 60},
                      :uniqueness => { :case_sensitive => false})

  validates :body, :presence => true

#  def shared_groups
#    shared = []
#    self.item_shares.each do |i|
#      shared << i.group_id
#    end
#  end

end

# == Schema Information
#
# Table name: discussions
#
#  id         :integer         not null, primary key
#  creator_id :integer
#  group_id   :integer
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

