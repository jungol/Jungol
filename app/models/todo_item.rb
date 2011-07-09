# == Schema Information
# Schema version: 20110707045835
#
# Table name: todo_items
#
#  id          :integer         not null, primary key
#  description :string(255)
#  todo_id     :integer
#  status      :integer
#  list_order  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class TodoItem < ActiveRecord::Base

  attr_accessor :todo
  attr_accessible :description, :status, :list_order

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
      self.list_order ||= self.todo.items.count + 1
    end

end
