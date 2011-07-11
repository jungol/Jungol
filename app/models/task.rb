# == Schema Information
# Schema version: 20110710015518
#
# Table name: tasks
#
#  id          :integer         not null, primary key
#  description :string(255)
#  todo_id     :integer
#  status      :integer
#  list_order  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Task < ActiveRecord::Base

  attr_accessor :todo
  attr_accessible :description, :status
  attr_protected :list_order

  @@count = 0
  belongs_to :todo

  validates( :description, :presence => true,
                       :length => {:maximum => 140})

  validates_numericality_of :status, :only_integer => true
  validates_inclusion_of :status, :in => 0..3

  before_validation :add_default_status, :add_order


  private

    def add_default_status
      self.status ||= 0
    end

    def add_order
      if self.todo
        @@count = 0
        self.list_order ||= self.todo.tasks.count + 1
      else
        @@count = @@count + 1
        self.list_order = @@count
      end
    end


end
