class Membership < ActiveRecord::Base
  #SCOPES
  #scope :creator, :conditions => {:role => 1}
  #scope :admins, :conditions => {:role => 2}
  #scope :users, :conditions => {:role => 3}
  #scope :sharers, :conditions => {:role => 4}
  attr_accessible :group_id, :role

  validates_presence_of :role, :group_id, :user_id

  validates_associated :group

  #ASSOCIATIONS
  belongs_to :user
  belongs_to :group


  def change_role(role)
    update_attributes(:role => role)
  end

  before_validation :add_default_role

  private

    def add_default_role
      #SET FIRST MEMBER TO ADMIN
      #OTHERWISE DEFAULT TO USER
      if self.group_id && Group.find(self.group_id).memberships.empty?
        self.role = 1
      else
        self.role ||= 2
      end
    end

end

# == Schema Information
#
# Table name: memberships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  group_id   :integer
#  role       :integer
#  created_at :datetime
#  updated_at :datetime
#

