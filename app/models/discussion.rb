class Discussion < ActiveRecord::Base
  attr_accessible :title, :body

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'

  validates( :title, :presence => true,
                      :length => {:maximum => 60},
                      :uniqueness => { :case_sensitive => false})

  validates :body, :presence => true
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

