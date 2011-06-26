# == Schema Information
# Schema version: 20110624164937
#
# Table name: groups
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  announcement :text
#  about        :text
#  created_at   :datetime
#  updated_at   :datetime
#

class Group < ActiveRecord::Base

  attr_accessible :name, :announcement, :about

  validates(:name, :presence => true,
            :length => {:maximum => 50},
            :uniqueness => { :case_sensitive => false })
  validates :about, :presence => true


  #MEMBERSHIPS
  has_many :memberships
  has_many :users, :through => :memberships


end
