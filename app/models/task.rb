class Task < ActiveRecord::Base

  attr_accessor :todo
  attr_accessible :description, :status
  attr_protected :list_order, :task_num

  @@count = 0
  belongs_to :todo, :counter_cache => true

  validates( :description, :presence => true,
            :length => {:maximum => 140})

  validates_numericality_of :status, :only_integer => true
  validates_inclusion_of :status, :in => 0..2

  validates_uniqueness_of :task_num, :list_order, :scope => :todo_id

  before_validation :add_default_status, :add_order_add_desc

  private
    def add_default_status
      self.status ||= 0
    end

    def add_order_add_desc
      if self.todo
        @@count = self.todo.tasks_count + 1
      else
        @@count += 1
      end
      self.task_num = @@count
      self.list_order = @@count
    end
end

#STATUS - 1=IN-P, 2=COMPLETE

# == Schema Information
#
# Table name: tasks
#
#  id          :integer         not null, primary key
#  description :string(255)
#  todo_id     :integer
#  status      :integer
#  list_order  :integer
#  task_num    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

