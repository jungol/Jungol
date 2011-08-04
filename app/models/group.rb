class Group < ActiveRecord::Base

  attr_accessor :agreement
  attr_accessible :name, :about, :agreement

  validates(:name, :presence => true,
            :length => {:maximum => 50},
            :uniqueness => { :case_sensitive => false })
  validates :about, :presence => true

  validates_acceptance_of :agreement

  validate :max_users

  after_create :add_creator_as_member

  #AFFILIATES
  has_and_belongs_to_many :groups, :join_table => "group_groups", :association_foreign_key => :group2_id

  #MEMBERSHIPS
  has_many :memberships
  has_many :users, :through => :memberships

  #CREATOR
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  #ITEMS
  has_many :item_shares, :dependent => :destroy
  has_many :shared_todos, :through => :item_shares, :source => :item, :source_type => 'Todo'
  has_many :shared_discussions, :through => :item_shares, :source => :item, :source_type => 'Discussion'
  has_many :todos, :dependent => :destroy

  has_many :discussions, :dependent => :destroy

  def member?(user)
    users.include?(user)
  end

  def admin?(user)
    admins.include?(user) if user
  end

  def users_by_role
    users.all(:conditions => ['users.id not in (?)', self.creator], :include => :memberships, :order => 'memberships.role DESC' )
  end

  def admins
    users.includes(:memberships).where(:memberships => {:role => 1})
  end

  def non_admins
    users.includes(:memberships).where(:memberships => {:role => 2})
  end

  def non_admin?(user)
    non_admins.include?(user) if user
  end

  def unshared_groups(item)
    Group.find(:all, :conditions => ['id in (?)', self.groups - item.shared_groups])
  end

  def unconnected_groups
    if self.groups.present?
      Group.find(:all, :conditions => ['id not in (?) and id not in (?)', self.groups, self.id])
    else
      Group.find(:all, :conditions => ['id not in (?)', self.id])
    end
  end

  def shared_on_todos
    self.shared_todos.where "group_id not in ?", self.id
  end

  def shared_on_discussions
    self.shared_discussionss.where "group_id not in ?", self.id
  end

  def add_creator_as_member
    self.users << creator
  end

  def max_users
    if self.users.size > 30
      errors.add :base, "Group cannot have more than 30 users."
    end
  end
end



# == Schema Information
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

