class Group < ActiveRecord::Base

  attr_accessor :agreement
  attr_accessible :name, :about, :agreement, :logo

  validates(:name, :presence => true,
            :length => {:maximum => 50},
            :uniqueness => { :case_sensitive => false })
  validates :about, :presence => true

  validates_acceptance_of :agreement

  validate :max_users

  after_create :add_creator_as_member

  #LOGO
  has_attached_file :logo, {
    :styles => { :medium => "300x100>", :thumb => "50x17>", :small => "30x10>" },
    :whiny => false
  }.merge(PAPERCLIP_IMAGE_OPTIONS)

  validates_attachment_size :logo, :less_than => 1.megabyte, :message => "must be less than 1MB in size"
  validates_attachment_content_type :logo, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

  #AFFILIATES
  has_many :group_connections, :dependent => :destroy
  has_many :groups, :through => :group_connections, :source => :group_b, :conditions => ['status = ?', 2]
  has_many :requested_groups, :through => :group_connections, :source => :group_b, :conditions => ['status = ?', 0]
  has_many :pending_groups, :through => :group_connections, :source => :group_b, :conditions => ['status = ?', 1]

  #MEMBERSHIPS
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :members, :through => :memberships, :source => :user, :conditions => ['is_pending = ?', false]
  has_many :pending_members, :through => :memberships, :source => :user, :conditions => ['is_pending = ?', true]

  #CREATOR
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  #ITEMS
  has_many :item_shares, :dependent => :destroy
  has_many :shared_todos, :through => :item_shares, :source => :item, :source_type => 'Todo'
  has_many :todos, :dependent => :destroy

  has_many :shared_discussions, :through => :item_shares, :source => :item, :source_type => 'Discussion'
  has_many :discussions, :dependent => :destroy

  has_many :shared_documents, :through => :item_shares, :source => :item, :source_type => 'Document'
  has_many :documents, :dependent => :destroy

  def approve_user(user)
    if pending_members.include?(user)
      user.memberships.find_by_group_id(self.id).update_attributes(:is_pending => false)
    end
  end

  def member?(user)
    members.include?(user)
  end

  def pending_member?(user)
    pending_members.include?(user)
  end

  def admin?(user)
    admins.include?(user) if user
  end

  def users_by_role
    members.all(:conditions => ['users.id not in (?)', self.creator], :include => :memberships, :order => 'memberships.role DESC' )
  end

  def admins
    members.includes(:memberships).where(:memberships => {:role => 1})
  end

  def non_admins
    members.includes(:memberships).where(:memberships => {:role => 2})
  end

  def non_admin?(user)
    non_admins.include?(user) if user
  end

  def unshared_groups(item)
    Group.find(:all, :conditions => ['id in (?)', self.groups - item.shared_groups])
  end

  def unconnected_groups
    if self.group_connections.present?
      Group.find(:all, :conditions => ['id not in (?) and id not in (?)', self.groups | self.pending_groups | self.requested_groups, self.id])
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
    approve_user creator
  end

  def max_users
    if self.users.size > 30
      errors.add :base, "Group cannot have more than 30 users."
    end
  end

  def connect(group)
    if self.unconnected_groups.include? group
      req = self.group_connections.build(:group_b_id => group.id)
      pend = group.group_connections.build(:group_b_id => self.id, :status => 1)
      req.save! && pend.save!
    else
      return false
    end
  end

  def approve_group(group)
    req = self.group_connections.find_by_group_b_id(group.id)
    pend = group.group_connections.find_by_group_b_id(self.id)
    req.update_attributes(:status => 2) && pend.update_attributes(:status => 2)
  end

  def deny_group(group)
    req = self.group_connections.find_by_group_b_id(group.id)
    pend = group.group_connections.find_by_group_b_id(self.id)
    req.destroy && pend.destroy
  end

end




# == Schema Information
#
# Table name: groups
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  about             :text
#  creator_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

