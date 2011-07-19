class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  #attr_accessor :password

  #MEMBERSHIPS
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships

  #CREATOR
  has_many :created_groups, :foreign_key => 'creator_id', :class_name => 'Group'
  has_many :created_todos, :foreign_key => 'creator_id', :class_name => 'Todo'
  has_many :created_discussions, :foreign_key => 'creator_id', :class_name => 'Discussion'
  has_many :comments

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => true,
            :length => {:maximum => 50}
            #:uniqueness => { :case_sensitive => false }

  validates :email, :presence => true,
                    :format => {:with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40}
end


# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  about                  :text
#
