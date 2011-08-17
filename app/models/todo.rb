class Todo < ActiveRecord::Base
  attr_accessible :title, :tasks_attributes, :description

  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

  has_many :tasks, :dependent => :destroy, :order => 'list_order ASC'
  has_many :comments, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :item_shares, :dependent => :destroy, :as => :item, :order => 'created_at ASC'
  has_many :shared_groups, :through => :item_shares, :source => :group
  has_many :interactions, :dependent => :destroy, :as => :item
  has_many :interactors, :through => :interactions, :source => :user, :uniq => true

  accepts_nested_attributes_for :tasks, :reject_if => lambda {|t| t[:description].blank? }, :allow_destroy => true

  validates :title, :presence => true,
            :length => {:maximum => 60},
            :uniqueness => { :case_sensitive => false}

  def add_many(user, _tasks)
    _tasks.each do |task| 
      self.update_attributes(:tasks_attributes => [task])
    end
    
    self.interactions.create(:user => user, :summary => 'Created Todo Tasks')
    
    self.interactors.each do |to_mail|
      InteractionMailer.new_todo_task(tasks.last(_tasks.count), to_mail, user).deliver unless user == to_mail
    end
    
  end

  def update_order(_tasks)
    self.tasks.each do |task|
      task.update_attribute :list_order, _tasks.index(task.id.to_s) + 1
    end
  end
  
end




# == Schema Information
#
# Table name: todos
#
#  id          :integer         not null, primary key
#  creator_id  :integer
#  group_id    :integer
#  title       :string(255)
#  description :text
#  tasks_count :integer         default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

