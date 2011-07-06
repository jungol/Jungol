class Todo < ActiveRecord::Base


  belongs_to :group
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User'

end
