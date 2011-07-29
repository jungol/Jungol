class User < ActiveRecord::Base
  require 'ruby-debug'
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :about, :email, :password, :password_confirmation, :remember_me
  #attr_accessor :password

  #MEMBERSHIPS
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships

  #CREATOR
  has_many :created_groups, :foreign_key => 'creator_id', :class_name => 'Group'
  has_many :created_todos, :foreign_key => 'creator_id', :class_name => 'Todo'
  has_many :created_discussions, :foreign_key => 'creator_id', :class_name => 'Discussion'
  has_many :created_shares, :foreign_key => 'creator_id', :class_name => 'ItemShare'
  has_many :comments

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => true,
            :length => {:maximum => 50}
            #:uniqueness => { :case_sensitive => false }

  def member_of?(group)
    self.groups.include? group
  end

  def admin_of?(group)
    self.groups.includes(:memberships).where(:memberships => {:role => 1}).include? group
  end

  def can_view?(current_group, item)  #whether a user can see an item, given the group they're viewing from
    if self.member_of? current_group  # user has to be member of viewing group
      if item.shared_groups.include? current_group  #group has to be shared on this item
        share = item.item_shares.find_by_group_id current_group.id
        return (! share.admins_only) || (self.admin_of? current_group) #either item isn't admin_only, or user is an admin
      end
    end
  end

  def can_delete?(item)
    (admin_of? item.group) || (item.creator == self)
  end

  def share(group, item)
    share = self.created_shares.create
    item.item_shares << share
    group.item_shares << share
  end

end


# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  about                  :text
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#

