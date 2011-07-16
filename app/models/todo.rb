class Todo < ActiveRecord::Base
  attr_accessible :title, :tasks_attributes

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :tasks, :dependent => :destroy, :order => 'list_order ASC'
  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'

  accepts_nested_attributes_for :tasks, :reject_if => lambda {|t| t[:description].blank? }, :allow_destroy => true

  validates( :title, :presence => true,
                      :length => {:maximum => 60},
                      :uniqueness => { :case_sensitive => false})

end

# == Schema Information
#
# Table name: todos
#
#  id         :integer         not null, primary key
#  creator_id :integer
#  group_id   :integer
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

