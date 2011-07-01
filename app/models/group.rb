# == Schema Information
# Schema version: 20110624164937
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  about      :text
#  created_at :datetime
#  updated_at :datetime
#

class Group < ActiveRecord::Base

  attr_accessor :agreement

  attr_accessible :name, :about, :agreement

  validates(:name, :presence => true,
            :length => {:maximum => 50},
            :uniqueness => { :case_sensitive => false })
  validates :about, :presence => true

  validates_acceptance_of :agreement

  #MEMBERSHIPS
  has_many :memberships
  has_many :users, :through => :memberships

  #CREATOR
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  after_create :add_creator

  def add_creator
    self.users << creator
  end
end
