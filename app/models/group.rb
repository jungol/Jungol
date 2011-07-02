# == Schema Information
# Schema version: 20110624164937
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  about      :text
#  creator_id :integer
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


  after_create :add_creator

  #AFFILIATES
  has_and_belongs_to_many :groups, :join_table => "group_groups", :association_foreign_key => :group2_id

  #MEMBERSHIPS
  has_many :memberships
  has_many :users, :through => :memberships

  #CREATOR
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  def member?(user)
    users.include?(user)
  end

  def leader?(user)
    leaders.include?(user) if user
  end

  def leaders
    users.includes(:memberships).where(:memberships => {:role => 1})
  end

  def non_leaders
    users.includes(:memberships).where(:memberships => {:role => 2})
  end

  def non_leader?(user)
    non_leaders.include?(user) if user
  end


  def add_creator
    self.users << creator
  end
end
